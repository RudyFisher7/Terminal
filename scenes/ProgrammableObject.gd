extends RigidBody


#####################################################################
# Defines a base class for all programmable objects
#####################################################################


class_name ProgrammableObject


var _speed : float = 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var impulse : Vector3 = transform.basis.xform(Vector3.FORWARD)
	apply_central_impulse(impulse * _speed)
