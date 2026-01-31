extends RigidBody3D

# Exported variables let you assign masks in the editor
@export var Mask1: Node3D
@export var Mask2: Node3D
@export var Mask3: Node3D
@export var Mask4: Node3D
@export var Mask5: Node3D

var masks: Array

func _ready():
	# Put all masks in an array
	masks = [Mask1, Mask2, Mask3, Mask4, Mask5]

	# Disable all masks
	for mask in masks:
		if mask:
			mask.visible = false

	# Enable one random mask
	var random_index = randi() % masks.size()
	if masks[random_index]:
		masks[random_index].visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
