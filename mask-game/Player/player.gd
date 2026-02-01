extends Node3D

@onready var cam = $"."
@onready var raycast = $Camera3D/RayCast3D
@onready var raycast2 = $Camera3D/RayCast3DHand
@onready var hand = $Hand

var v = Vector3()
var sensitivity = 0.12

@export var throwForce = 20

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta):
	cam.rotation_degrees.x = v.x
	cam.rotation_degrees.y = v.y
	
	handle_object_interaction()


func  _input(event):
	if event is InputEventMouseMotion:
		v.y -= (event.relative.x * sensitivity)
		v.x -= (event.relative.y * sensitivity)
		v.x = clamp(v.x, -80, 70)
		v.y = clamp(v.y, -100, 75)


func handle_object_interaction():
	var object = raycast.get_collider()
	var object2 = raycast2.get_collider()
	if raycast2.is_colliding():
		if object2.is_in_group("pickable"):
			# hold object in hand when left mouse down
			if Input.is_action_pressed("Interact"):
				hold_object(object2)
			# when left mouse released
			if Input.is_action_just_released("Interact"):
				# place object "nicely" when 'E' pressed
				if Input.is_action_pressed("Place"):
					place_object(object2)
				# throw object if not
				else: throw_object(object2)
		
	if raycast.is_colliding():
		if object.is_in_group("pickable"):
			# hold object in hand when left mouse down
			if Input.is_action_pressed("Interact"):
				hold_object(object)
			# when left mouse released
			if Input.is_action_just_released("Interact"):
				# place object "nicely" when 'E' pressed
				if Input.is_action_pressed("Place"):
					place_object(object)
				# throw object if not
				else: throw_object(object)

func hold_object(obj):
	obj.global_position = hand.global_position
	obj.global_rotation = hand.global_rotation
	obj.collision_layer = 2

func throw_object(obj):
	obj.apply_central_impulse(-cam.global_transform.basis.z * throwForce)

func place_object(obj):
	obj.apply_central_impulse(-cam.global_transform.basis.z * throwForce * .2)
