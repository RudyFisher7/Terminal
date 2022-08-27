extends RigidBody


#####################################################################
# Defines a base class for all programmable objects
#####################################################################


class_name ProgrammableNode

var function_builder : Dictionary = {
	"set_speed":[self, [1], [Function.ArgType.FLOAT]],
	"set_position":[self, [3], [Function.ArgType.FLOAT, Function.ArgType.FLOAT, Function.ArgType.FLOAT]],
}

var function_lib : = FunctionLibrary.new()
var _program : = Program.new()
var _speed : float = 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	print(has_method("get_program_function_names"))
	var fref : FuncRef = funcref(self, "get_program_function_names")
	fref.call_funcv([])
	
	function_lib.functions = function_lib.populate_functions(self, function_builder)
	function_lib.function_target_nodes[self.name] = self
	print(function_lib.functions)


func _physics_process(_delta):
	var impulse : Vector3 = transform.basis.xform(Vector3.FORWARD)
	#apply_central_impulse(impulse * _speed)


func connect_to_terminal() -> String:
	return name + ".CONNECTED"


func disconnect_from_terminal() -> String:
	return name + ".DISCONNECTED"


func get_program_function_names() -> Array:
	return _program.function_names()


func set_speed(value : float) -> void:
	_speed = value


func set_position(x : float, y : float, z : float) -> void:
	transform.origin = Vector3(x, y, z)







