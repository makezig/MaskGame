extends Node3D

#Refrences top Preload needing scenes
@onready var hud_scene := preload("res://UI/IngameUI.tscn") 
@onready var player_character := preload("res://Player/test.tscn")
@onready var npc_scene := preload("res://Npc/npc.tscn")

#Scene refrences needed for gameloop

const PAUSE_MENU_SCENE := "res://UI/PauseMenu.tscn"

#Variables
var pause_menu: Control = null
@export var npc_spawn_point: Node3D

func _ready() -> void:
	#Spawn HUD
	var hud = hud_scene.instantiate()
	add_child(hud)
	
	#Spawn Player
	var player = player_character.instantiate()
	add_child(player)
	
	# Spawn NPC at the specified Node3D spawn point
	var test_npc = npc_scene.instantiate() as Node3D
	test_npc.global_transform.origin = npc_spawn_point.global_transform.origin
	add_child(test_npc)

func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Esc key
		if pause_menu and pause_menu.visible:
			resume_game()
		else:
			show_pause_menu()


#Pasuse Menu helper functions
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
