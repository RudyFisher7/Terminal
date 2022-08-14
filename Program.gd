extends Reference


#####################################################################
# Defines a base class for a program.
# This script will be what is capable of validating and executing
# programs on any programmable node/object the player can program.
#####################################################################


class_name Program


var _functions : Dictionary


func _init(in_functions : Dictionary) -> void:
	_functions = in_functions


func function_names() -> Array:
	return _functions.keys()
