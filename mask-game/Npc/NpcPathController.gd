extends Node3D

class NPC:
	var npc: Node3D
	var state: int = 0      # 0 = to tiller, 1 = waiting, 2 = to exit
	var wait_time: float = 0

var npc_scene = preload("res://Npc/npc.tscn")
@export var spawn: Node3D
@export var tiller: Node3D
@export var exit: Node3D
@export var player_marker: Node3D   # player to look at while waiting
@export var tiller_wait_time: float = 3.0  # seconds to wait at tiller
@export var speed: float = 2.0

var npc_list: Array = []

#func _input(event):
	#if event is InputEventKey and event.pressed:
		#if event.keycode == Key.KEY_N:  # Enter key
			#spawn_npc()
		#if event.keycode == Key.KEY_M:
			#command_npc_to_exit(npc_list[0])

func _ready():
	spawn_npc()

func _process(delta):
	move_npcs(delta)

func force_exit_all():
	for npc_data in npc_list:
		command_npc_to_exit(npc_data)

# Spawn NPC at spawn point
func spawn_npc():
	var npc_instance = npc_scene.instantiate()
	npc_instance.position = spawn.position
	var npc_data = NPC.new()
	npc_data.npc = npc_instance
	npc_data.state = 0
	npc_data.wait_time = tiller_wait_time
	npc_list.append(npc_data)
	add_child(npc_instance)

# Move all NPCs according to their state
func move_npcs(delta):
	for npc_data in npc_list:
		var npc_node = npc_data.npc
		
		match npc_data.state:
			0:  # Moving to tiller
				move_npc_toward(npc_node, tiller.position, delta)
				if npc_node.position.distance_to(tiller.position) < 0.1:
					npc_data.state = 1  # Start waiting
					npc_data.wait_time = tiller_wait_time
					
			1:  # Waiting at tiller
				look_at_player(npc_node, delta)
				npc_data.wait_time -= delta
				# You can also externally trigger NPC to move here
				if npc_data.wait_time <= 0:
					npc_data.state = 2  # Move to exit
					
			2:  # Moving to exit
				move_npc_toward(npc_node, exit.position, delta)
				# Optional: remove NPC when it reaches exit
				if npc_node.position.distance_to(exit.position) < 0.1:
					npc_node.queue_free()
					npc_list.erase(npc_data)

# Move NPC toward a target
func move_npc_toward(npc_node: Node3D, target_pos: Vector3, delta: float):
	var direction = (target_pos - npc_node.position).normalized()
	npc_node.position += direction * speed * delta
	npc_node.look_at(npc_node.position + direction, Vector3.UP)

# Make NPC look at the player
func look_at_player(npc_node: Node3D, delta):
	if player_marker:
		var target_pos = player_marker.position
		target_pos.y = npc_node.position.y
		var target_dir = (target_pos - npc_node.position).normalized()
		var target_rotation = npc_node.global_transform.looking_at(target_pos, Vector3.UP).basis
		npc_node.global_transform.basis = npc_node.global_transform.basis.slerp(target_rotation, 5 * delta)


# External command to move NPCs to exit immediately
func command_npc_to_exit(npc_data: NPC):
	npc_data.state = 2
