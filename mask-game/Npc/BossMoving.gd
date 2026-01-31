extends Node

@export var boss: Node3D
@export var active: Node3D
@export var inactive: Node3D
@export var player_marker: Node3D   # player to look at while waiting
@export var speed: float = 2.0

# Internal state: true = moving to active, false = moving to inactive
var moving_to_active: bool = true
var target_node: Node3D

# Threshold to consider "arrived"
const ARRIVAL_THRESHOLD: float = 0.05

# Input function to toggle using N key
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == Key.KEY_N:
			toggle_active_inactive()

func _ready() -> void:
	# Start moving to the active node by default
	target_node = active

func _process(delta: float) -> void:
	if boss and target_node:
		move_boss_toward(target_node, delta)

# Move the boss toward a target node
func move_boss_toward(target: Node3D, delta: float) -> void:
	var direction: Vector3 = target.global_transform.origin - boss.global_transform.origin
	var distance: float = direction.length()
	
	if distance > ARRIVAL_THRESHOLD:
		direction = direction.normalized()
		# Move
		boss.global_translate(direction * speed * delta)
		# Look in direction of travel
		look_in_direction(direction, delta)
	else:
		# Arrived at target, look at player
		look_at_player_smooth(delta)

# Rotate boss to look in the direction of travel smoothly
func look_in_direction(direction: Vector3, delta: float) -> void:
	if direction.length() < 0.001:
		return  # Prevent degenerate vector
	
	# Flatten direction to XZ plane
	var flat_dir: Vector3 = Vector3(direction.x, 0, direction.z).normalized()
	
	# Compute target basis
	var target_pos: Vector3 = boss.global_transform.origin + flat_dir
	var target_basis: Basis = boss.global_transform.looking_at(target_pos, Vector3.UP).basis.orthonormalized()
	
	# Orthonormalize current basis
	var current_basis: Basis = boss.global_transform.basis.orthonormalized()
	
	# Smoothly slerp rotation
	boss.global_transform.basis = current_basis.slerp(target_basis, 5.0 * delta)

# Make boss look at player smoothly
func look_at_player_smooth(delta: float) -> void:
	if player_marker:
		# Keep the boss upright
		var target_pos: Vector3 = player_marker.global_transform.origin
		target_pos.y = boss.global_transform.origin.y
		
		# Orthonormalize both source and target bases
		var current_basis: Basis = boss.global_transform.basis.orthonormalized()
		var target_basis: Basis = boss.global_transform.looking_at(target_pos, Vector3.UP).basis.orthonormalized()
		
		# Smoothly slerp
		boss.global_transform.basis = current_basis.slerp(target_basis, 5.0 * delta)



# Public functions to move to active or inactive node
func move_to_active() -> void:
	target_node = active
	moving_to_active = true

func move_to_inactive() -> void:
	target_node = inactive
	moving_to_active = false

# Toggle function: switches the current target
func toggle_active_inactive() -> void:
	if moving_to_active:
		move_to_inactive()
	else:
		move_to_active()
