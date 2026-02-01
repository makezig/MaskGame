extends Node

enum UIState {
	HAPPY,
	NEUTRAL,
	MAD,
	SAD
}

@export var boss: Node3D
@export var npc: Node3D
@export var item_spawn_point: Node3D
@export var main_level: Node3D
@export var npc_spawner: Node3D

#Current fails and max fail count
@export var fail_count: int = 0
var max_fails: int = 10
#Mood counter (low bad, high good)
var mood: float = 100
#Timer untill boss changes state
var boss_clock: float = 5.0
#Npc spawn timer
var npc_clock: float = 5
var item_clock: float = 2


# Keep track of already connected pickables
var connected_pickables: Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	npc_item_spawn_loop(delta)
	boss_timer(delta)
	mood_degradation(delta)
	game_over(delta)
	_check_new_pickables()


func _check_new_pickables():
	var pickables = get_tree().get_nodes_in_group("pickable")
	for obj in pickables:
		if obj in connected_pickables:
			continue
		if obj.has_signal("destroyed"):
			print("Connecting to pickable:", obj.name)
			obj.destroyed.connect(_on_pickable_destroyed)
			connected_pickables.append(obj)

			
func _on_pickable_destroyed(obj: Node3D) -> void:
	print("Pickable destroyed:", obj.name)
	var ui := get_tree().get_first_node_in_group("ui")
	if not ui:
		return
		
	if boss.moving_to_active:  # Boss is active → fail
		fail_count += 1
		ui.set_failcounter(fail_count)
	else:  # Boss inactive → increase mood
		mood += 10
		mood = clamp(mood, 0, 100)
		print("Mood increased! Current mood:", mood)
	# Remove from connected list
	connected_pickables.erase(obj)

func npc_item_spawn_loop(delta: float):
	npc_clock -= delta
	item_clock -= delta
	
	if npc_clock <= 0: # Spawning npc at even intervals
		#npc_spawner.force_exit_all()
		npc_spawner.spawn_npc()
		npc_clock = randf_range(5.0, 8.0)
	
	if item_clock <= 0:
		main_level.call_deferred("spawn_items")
		item_clock = randf_range(1.5, 4.0)
	pass


func boss_timer(delta: float):
	boss_clock -= delta
	if boss_clock <= 0:
		#toggle_active_to_inactive
		boss.toggle_active_inactive()
		#reset timer
		boss_clock = 5
		
	pass

func mood_degradation(delta: float):
	mood -= 5 * delta
	mood = clamp(mood, 0, 100)

	var ui := get_tree().get_first_node_in_group("ui")
	if not ui:
		return

	if mood == 0:
		main_level.show_game_over_screen()
		ui.uppdate_rage_mask(UIState.SAD, Color.DARK_GRAY)
	elif mood >= 75:
		ui.uppdate_rage_mask(UIState.HAPPY, Color.GREEN)
	elif mood >= 40:
		ui.uppdate_rage_mask(UIState.NEUTRAL, Color.WHITE)
	elif mood >= 15:
		ui.uppdate_rage_mask(UIState.MAD, Color.ORANGE)
	else:
		ui.uppdate_rage_mask(UIState.SAD, Color.BLUE)


func game_over(delta):
	if fail_count == max_fails:
		main_level.show_game_over_screen()

func get_ui() -> Node:
	return get_tree().get_first_node_in_group("ui")
