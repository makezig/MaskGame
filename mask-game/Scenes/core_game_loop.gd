extends Node

@export var boss: Node3D
@export var npc: Node3D
@export var item_spawn_point: Node3D

#Current fails and max fail count
var fail_count: int = 0
var max_fails: int = 3
#Mood counter (low bad, high good)
var mood: float
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
	pass

func mood_degradation(delta: float):
	pass

func game_over(delta):
	pass #TODO: Add game over screen and return to main screne
