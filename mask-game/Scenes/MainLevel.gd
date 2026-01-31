extends Node

@onready var hud_scene := preload("res://UI/IngameUI.tscn")
@onready var player_character := preload("res://Player/test.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var hud = hud_scene.instantiate()
	add_child(hud)
	
	var player = player_character.instantiate()
	add_child(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
