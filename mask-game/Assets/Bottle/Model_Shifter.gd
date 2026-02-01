extends Node3D

@export var broken_model:PackedScene;
@export var simple_model:Node3D;

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		
		var bottle_transform: Transform3D = simple_model.global_transform
		print_debug(bottle_transform)
		
		#Instantiate broken model to bottle's position
		var broken_model_inst:Node3D = broken_model.instantiate();
		broken_model_inst.set_centre(bottle_transform.origin)	
		
		#get_parent().add_child(broken_model_inst);
		
		get_tree().current_scene.add_child(broken_model_inst)
		broken_model_inst.global_transform = bottle_transform
		
		print("Bottle:", global_position)
		print("Broken:", broken_model_inst.global_position)
		
		print("Bottle parent:", get_parent().name)
		
		self.queue_free(); #Destroy model
		
