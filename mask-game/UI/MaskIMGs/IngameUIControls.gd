extends Control

# ----- STATE -----
enum UIState {
	HAPPY,
	NEURAL,
	MAD,
	SAD
}
@export var current_state := UIState.HAPPY : set = set_state

@export var state_image_1: TextureRect
@export var state_image_2: TextureRect
@export var state_image_3: TextureRect
@export var state_image_4: TextureRect

@export var color_image: TextureRect

@export var editor_test_color: Color = Color.WHITE
@export var preview_color_in_editor := false : set = _preview_color

var state_images: Array[TextureRect]

func _ready():
	state_images = [
		state_image_1,
		state_image_2,
		state_image_3,
		state_image_4
	]
	update_state_visuals()

func set_state(value):
	current_state = value
	update_state_visuals()

func update_state_visuals():
	for img in state_images:
		if img:
			img.visible = false
	
	var index := int(current_state)
	if index < state_images.size() and state_images[index]:
		state_images[index].visible = true

func set_color_image_color(color: Color):
	if color_image:
		color_image.modulate = color

func _preview_color(value: bool):
	preview_color_in_editor = value
	if Engine.is_editor_hint() and color_image:
		color_image.modulate = editor_test_color
