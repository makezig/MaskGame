extends Control

# Path to your main menu scene
const MAIN_MENU_SCENE := "res://UI/MainMenu.tscn"

# Buttons will be fetched safely in _ready
var resume_button: Button
var main_menu_button: Button

func _ready():
	# Hide the pause menu initially
	visible = false

	# Fetch buttons safely
	resume_button = $Control/ResumeButton
	main_menu_button = $Control/MainMenuButton

	# Connect signals only if the buttons exist
	if resume_button:
		resume_button.pressed.connect(resume_game)
	else:
		push_warning("ResumeButton not found!")

	if main_menu_button:
		main_menu_button.pressed.connect(return_to_main_menu)
	else:
		push_warning("MainMenuButton not found!")

# Call this to show the pause menu
func show_pause_menu():
	get_tree().paused = true
	visible = true
	# Make sure the mouse is visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Resume button: hides the pause menu and unpauses
func resume_game():
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Main Menu button: unpause and load main menu scene
func return_to_main_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)
