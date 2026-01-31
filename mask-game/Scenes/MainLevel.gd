extends Node3D

#Refrences top Preload needing scenes
@onready var hud_scene := preload("res://UI/IngameUI.tscn") 
@onready var player_character := preload("res://Player/Player.tscn")


# Preload item scenes
var items: Array = [
	preload("res://Assets/Bottle/bottle_pieces_modified.tscn")
]


#Scene refrences needed for gameloop
const PAUSE_MENU_SCENE := "res://UI/PauseMenu.tscn"

# Variables to control random spawning
@export var min_items: int = 3
@export var max_items: int = 7
@export var item_spawn_radius: float = 5.0  # How far from the spawn point items can appear

#Variables
var pause_menu: Control = null
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

func spawn_items():
	if not item_spawn_point:
		push_warning("Item spawn point not assigned!")
		return

	# Decide how many items to spawn this call
	var num_items = randi() % (max_items - min_items + 1) + min_items

	for i in num_items:
		# Pick a random item from the array
		var random_index = randi() % items.size()
		var item_scene = items[random_index]
		var item_instance = item_scene.instantiate() as Node3D

		# Pick a random position around the spawn point within a radius
		var random_offset = Vector3(
			randf_range(-item_spawn_radius, item_spawn_radius),
			0,  # Keep Y the same (adjust if you want vertical variation)
			randf_range(-item_spawn_radius, item_spawn_radius)
		)
		item_instance.global_transform.origin = item_spawn_point.global_transform.origin + random_offset

		# Add to scene
		add_child(item_instance)
