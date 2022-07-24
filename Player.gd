extends KinematicBody


# TODO
#####################################################################
# Defines a kinematic body-based player controller
#####################################################################

export var path_to_eyes : NodePath
export var path_to_y_pivot : NodePath
export var path_to_x_pivot : NodePath

const cam_sensitivity_divisor : float = 256.0
const speed : int = 2

onready var eyes : Position3D = get_node(path_to_eyes)
onready var y_pivot : Position3D = get_node(path_to_y_pivot)
onready var x_pivot : Position3D = get_node(path_to_x_pivot)



func _ready() -> void:
	pass 


func _physics_process(delta) -> void:
	var velocity : = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var movement : = Vector3(velocity.x, 0.0, velocity.y) * speed
	movement = transform.basis.xform(movement)
	move_and_slide(movement)


func _unhandled_input(event) -> void:
	if event is InputEventScreenDrag:
		x_pivot.rotate_x(event.relative.y / cam_sensitivity_divisor)
		rotate_y(event.relative.x / cam_sensitivity_divisor)
		get_tree().set_input_as_handled()














