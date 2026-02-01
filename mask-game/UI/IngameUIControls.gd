extends Control

enum UIState {
	HAPPY,
	NEUTRAL,
	MAD,
	SAD
}

var current_color: Color
var target_color: Color
var color_lerp_speed := 5.0


@export var current_state: UIState = UIState.HAPPY
@export var default_color: Color = Color.WEB_GREEN
@export var fail_count_text: String = "Testing"

@onready var state_images: Array[TextureRect] = [
	$Happy,
	$Neutral,
	$Mad,
	$Sad
]

@onready var fail_label = $FailCounter

@onready var color_image: TextureRect = $Color

func _ready():
	update_state_visuals()
	set_color_image_color(default_color)
	set_failcounter(9)

func _process(delta):
	current_color = current_color.lerp(target_color, delta * color_lerp_speed)
	set_color_image_color(current_color)


func set_failcounter(count: int):
	fail_label.text = fail_count_text + str(count)

#Call if you want to update both face and color
func uppdate_rage_mask(state: UIState, color: Color):
	set_state(state)
	target_color = color

func set_state(value: UIState):
	current_state = value
	update_state_visuals()

func set_color_image_color(color: Color):
	if color_image:
		color_image.modulate = color


#Helper function to update the image state
func update_state_visuals():
	for img in state_images:
		if img:
			img.visible = false

	var index := int(current_state)
	if index < state_images.size():
		state_images[index].visible = true
