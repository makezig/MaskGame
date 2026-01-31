extends Node3D


@export var INTENSITY:float = 8.0;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	for bottlePieces:RigidBody3D in self.get_children():
		
		var dir = (bottlePieces.global_position - global_position).normalized()
		bottlePieces.apply_impulse(dir * INTENSITY);
		
	await get_tree().create_timer(5.0).timeout
	queue_free()
	
