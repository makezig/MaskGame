extends Area3D

var bodies_to_move: Array[Node3D] = []

@export var belt_speed := 0.2
@export var belt_direction := Vector3.LEFT


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("pickable") and body not in bodies_to_move:
		bodies_to_move.append(body)
		print("Object entered belt")

func _on_body_exited(body: Node3D) -> void:
	if body in bodies_to_move:
		bodies_to_move.erase(body)
		print("Object left belt")


func _physics_process(delta: float) -> void:
	for body in bodies_to_move:
		if is_instance_valid(body):
			body.global_position += belt_direction * belt_speed * delta
