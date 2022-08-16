extends RigidBody


#####################################################################
# Defines a base class for all programmable objects
#####################################################################


class_name ProgrammableNode


var _program : = Program.new()
var _speed : float = 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	print(has_method("get_program_function_names"))
	var fref : FuncRef = funcref(self, "get_program_function_names")
	fref.call_funcv([])


func _physics_process(_delta):
	var impulse : Vector3 = transform.basis.xform(Vector3.FORWARD)
	apply_central_impulse(impulse * _speed)


func connect_to_terminal() -> String:
	return name + ".CONNECTED"


func get_program_function_names() -> Array:
	print("called")
	return _program.function_names()








