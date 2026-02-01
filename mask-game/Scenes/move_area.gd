extends Area3D

var body_to_move: Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("pickable"):
		body_to_move = body
		print("Object on the belt")

func _physics_process(delta: float) -> void:
	if body_to_move:
		body_to_move.global_position -= Vector3(.2,0,0) * delta
