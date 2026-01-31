extends Node  # Or Control if your menu is a UI scene

# Assign these in the editor or via code
@onready var credits_label: Label = $CreditsLabel

# Path to your main level scene
const MAIN_LEVEL_SCENE := "res://Scenes/MainLevel.tscn"

func _ready():
	# Hide the credits label initially
	credits_label.visible = false

	# Connect buttons (optional if not connected in editor)
	$StartButton.pressed.connect(start_game)
	$CreditsButton.pressed.connect(toggle_credits)
	$QuitButton.pressed.connect(quit_game)

# Start Game button: loads the main level
func start_game():
	get_tree().change_scene_to_file(MAIN_LEVEL_SCENE)

# Credits button: toggles the label visibility
func toggle_credits():
	credits_label.visible = not credits_label.visible

# Quit button: exits the game
func quit_game():
	get_tree().quit()
