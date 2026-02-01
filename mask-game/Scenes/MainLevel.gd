extends Node3D

#Refrences top Preload needing scenes
@onready var hud_scene := preload("res://UI/IngameUI.tscn") 
@onready var player_character := preload("res://Player/Player.tscn")


@export var items: Array[PackedScene]


#Scene refrences needed for gameloop
const PAUSE_MENU_SCENE := "res://UI/PauseMenu.tscn"
const GAME_OVER_SCENE := "res://UI/GameOverMenu.tscn"

# Variables to control random spawning
@export var min_items: int = 3
@export var max_items: int = 7
@export var item_spawn_radius: float = 5.0  # How far from the spawn point items can appear

#Variables
var pause_menu: Control = null
var game_over: Control = null
@export var item_spawn_point: Node3D

func _ready() -> void:
	#Spawn HUD
	var hud = hud_scene.instantiate()
	add_child(hud)
	
	#Spawn Player
	var player = player_character.instantiate()
	add_child(player)
	player.global_position += Vector3(.5,0,-.2)

func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Esc key
		if pause_menu and pause_menu.visible:
			resume_game()
		else:
			show_pause_menu()

#Pause Menu helper functions
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

# game over
func show_game_over_screen():
	if game_over == null:
		var scene_res = load(GAME_OVER_SCENE)
		game_over = scene_res.instantiate() as Control
		add_child(game_over)
	game_over.game_over()
	

func spawn_items():
	if not item_spawn_point:
		push_warning("Item spawn point not assigned!")
		return

	if items.is_empty():
		push_warning("No items assigned to spawn!")
		return

	# Decide how many items to spawn
	var num_items := randi_range(min_items, max_items)

	for i in range(num_items):
		# Pick a random item scene
		var item_scene: PackedScene = items.pick_random()
		var item_instance := item_scene.instantiate() as Node3D

		# Random position around spawn point
		var random_offset := Vector3(
			randf_range(-item_spawn_radius, item_spawn_radius),
			0.0,
			randf_range(-item_spawn_radius, item_spawn_radius)
		)
		
		if item_instance == null:
			return
		
		item_instance.global_position = item_spawn_point.global_position + random_offset
		item_instance.scale *= 1.5

		# Add to scene
		add_child(item_instance)
