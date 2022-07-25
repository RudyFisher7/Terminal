extends KinematicBody


#####################################################################
# Defines a kinematic body based player controller
#####################################################################


export var path_to_eyes : NodePath
export var path_to_y_pivot : NodePath
export var path_to_x_pivot : NodePath


const cam_sensitivity_divisor_touch : float = 256.0
const cam_sensitivity_divisor : float = 32.0
const speed : int = 8


onready var eyes : Position3D = get_node(path_to_eyes)
onready var y_pivot : Position3D = get_node(path_to_y_pivot)
onready var x_pivot : Position3D = get_node(path_to_x_pivot)


func _ready() -> void:
	pass 


func _physics_process(_delta) -> void:
	var velocity : = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var camera_velocity : = Input.get_vector("look_right", "look_left", "look_down", "look_up")
	
	# Move the player character
	var movement : = Vector3(velocity.x, 0.0, velocity.y) * speed
	movement = transform.basis.xform(movement)
	move_and_slide(movement)
	
	# Rotate the FPS player camera
	var camera_motion : = camera_velocity / cam_sensitivity_divisor
	x_pivot.rotate_x(camera_motion.y)
	rotate_y(camera_motion.x)


func _unhandled_input(event) -> void:
	if event is InputEventScreenDrag:
		x_pivot.rotate_x(event.relative.y / cam_sensitivity_divisor_touch)
		rotate_y(event.relative.x / cam_sensitivity_divisor_touch)
		get_tree().set_input_as_handled()














