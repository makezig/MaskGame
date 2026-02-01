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
@onready var clock = $Clock
# Variable to track elapsed time in seconds
var elapsed_time: float = 0.0

@onready var color_image: TextureRect = $Color

func _ready():
	update_state_visuals()
	set_color_image_color(default_color)
	set_failcounter(0)

func _process(delta):
	current_color = current_color.lerp(target_color, delta * color_lerp_speed)
	set_color_image_color(current_color)
	
		# Increment elapsed time by delta
	elapsed_time += delta
	
	# Convert elapsed_time to hours, minutes, seconds
	var minutes = int(fmod(elapsed_time, 3600) / 60)
	var seconds = int(fmod(elapsed_time, 60))
	
	# Format as HH:MM:SS
	clock.text = "%02d:%02d" % [minutes, seconds]

func set_failcounter(count: int):
	var fails = 10-count
	fail_label.text = fail_count_text + str(fails)

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
