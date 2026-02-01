extends Control

const MAIN_MENU_SCENE := "res://UI/MainMenu.tscn"

var main_menu_button: Button
var quit_button: Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu_button = $Control/MainMenuButton
	quit_button = $Control/QuitButton
	
	visible = false
	
	if main_menu_button:
		main_menu_button.pressed.connect(main_menu)
	else:
		push_warning("Main menu button not found!")
	if quit_button:
		quit_button.pressed.connect(quit_game)
	else:
		push_warning("Quit button not found!")

func game_over():
	get_tree().paused = true
	visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func main_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)

func quit_game():
	get_tree().quit()
