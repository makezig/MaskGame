extends TextureRect

@export var color_cycle_speed: float = 2.0 # seconds per full cycle

var _time_elapsed := 0.0

func _process(delta: float) -> void:
	_time_elapsed += delta

	# Cycle hue over time (0..1)
	var hue := fmod(_time_elapsed / color_cycle_speed, 1.0)
	modulate = Color.from_hsv(hue, 0.5, 1.0)
