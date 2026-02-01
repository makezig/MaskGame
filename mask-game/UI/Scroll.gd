extends Sprite2D

@export var scroll_speed: Vector2 = Vector2(50, 0) # pixels per second
@export var color_a: Color = Color(0,1,0)
@export var color_b: Color = Color(1,0,0)
@export var color_cycle_speed: float = 1.0 # seconds per full cycle

var _time_elapsed: float = 0.0

func _ready():
	# Make sure Region is enabled for scrolling
	region_enabled = true

func _process(delta: float) -> void:
	# --- Scroll the texture ---
	var new_region = region_rect
	new_region.position += scroll_speed * delta
	region_rect = new_region

	# --- Smoothly cycle the color ---
	_time_elapsed += delta
	var t = (sin(_time_elapsed * TAU / color_cycle_speed) + 1.0) * 0.5
	modulate = color_a.lerp(color_b, t)
