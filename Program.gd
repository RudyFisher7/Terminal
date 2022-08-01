extends Reference


#####################################################################
# Defines a base class for a program.
# This script will be what is capable of validating and executing
# programs on any programmable node/object the player can program.
#####################################################################


class_name Program


var _cmds : Dictionary


func _init(in_cmds : Dictionary) -> void:
	_cmds = in_cmds


func cmd_names() -> Array:
	return _cmds.keys()
