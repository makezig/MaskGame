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

#Current fails and max fail count
@export var fail_count: int = 0
var max_fails: int = 3
#Mood counter (low bad, high good)
var mood: float = 100
#Timer untill boss changes state
var boss_clock: float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	npc_item_spawn_loop(delta)
	boss_timer(delta)
	mood_degradation(delta)

func npc_item_spawn_loop(delta: float):
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
