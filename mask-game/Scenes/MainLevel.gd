extends Node3D

@onready var hud_scene := preload("res://UI/IngameUI.tscn") 
@onready var player_character := preload("res://Player/test.tscn")

const PAUSE_MENU_SCENE := "res://UI/PauseMenu.tscn"
var pause_menu: Control = null

func _ready() -> void:
	var hud = hud_scene.instantiate()
	add_child(hud)
	
	var player = player_character.instantiate()
	add_child(player)

func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Esc key
		if pause_menu and pause_menu.visible:
			resume_game()
		else:
			show_pause_menu()

func show_pause_menu():
	if pause_menu == null:
		# Load the pause menu scene
		var scene_res = load(PAUSE_MENU_SCENE)
		pause_menu = scene_res.instantiate() as Control
		# Add to scene tree
		add_child(pause_menu)
		# Make sure in editor: Pause → Mode = Process
	get_tree().paused = true
	pause_menu.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func resume_game():
	if pause_menu:
		pause_menu.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
