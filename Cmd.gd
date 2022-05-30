extends Reference

# TODO
#####################################################################
# Represents a cmd.
#####################################################################

class_name Cmd


const name_index : int = 0
const property_index : int = 1
const arg_start_index : int = 2

var name : String
var property : String
var args : Array

func _init(in_name : String, in_property : String = "", 
		   in_args : Array = []) -> void:
	name = in_name
	property = in_property
	args = in_args


func validate(cmd : Array) -> String:
	var error_msg : String = ""
	if !name == cmd[name_index]:
		error_msg = "No command found of that name."
	elif !property == cmd[property_index]:
		error_msg = cmd[name_index] + " has no property named "
		error_msg += cmd[property_index]
	elif !args.size() == (cmd.size() - arg_start_index):
		error_msg = "Wrong number of args entered."
	else:
		for i in range(arg_start_index, cmd.size()):
			pass # TODO: validation logic here - check type casting
	return error_msg
