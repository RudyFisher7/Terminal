extends Reference


#####################################################################
# Represents a cmd.
#####################################################################


class_name Cmd


enum ArgType {
	NONE,
	FLOAT,
	INT,
	STRING,
	FUNCREF,
}


enum Error {
	CMD_VALID,
	INVALID_CMD,
	ARGS_WRONG_TYPE,
	ARGS_WRONG_TYPE_OR_OUT_OF_RANGE,
	INVALID_ARG,
	ARGS_OUT_OF_RANGE,
	WRONG_NUMBER_OF_ARGS,
	NO_CMD_ENTERED,
	FAILED_TO_EXECUTE_ON_TARGET,
	NO_TARGET_TO_EXECUTE_ON,
}


const name_index : int = 0


var name : String
var subcmd : Cmd
var num_args : Array
var arg_types : Array
var target : Object


func _init(in_name : String, in_subcmd : Cmd = null, 
		   in_num_args : = [0], 
		   in_arg_types : Array = [ArgType.NONE],
		   in_target : Object = null) -> void:
	name = in_name
	subcmd = in_subcmd
	num_args = in_num_args
	arg_types = in_arg_types
	target = in_target


# Validates the given PoolStringArray that contains the parsed cmd
# information. Also recursively validates the subcmd contained within.
# Returns an error code (as an int) depending on the result of the
# validation:
#	- if the cmd's name didn't match self.name, return Error.INVALID_CMD
#	- if the cmd contains the wrong number of args, 
#	  return Error.WRONG_NUMBER_OF_ARGS
#	- if the cmd's args' types were incorrect, return Error.ARGS_WRONG_TYPE
#	- otherwise, return Error.CMD_VALID
func validate(pool_cmd : PoolStringArray) -> int:
	var cmd : = Array(pool_cmd)
	if !name == cmd[name_index]:
		return Error.INVALID_CMD
		
	if subcmd != null:
		return subcmd.validate(cmd.slice(name_index + 1, cmd.size()))
	else:
		var first_arg_index : int = name_index + 1
		if !(cmd.size() - first_arg_index) in num_args:
			return Error.WRONG_NUMBER_OF_ARGS
		
		for i in range(first_arg_index, cmd.size()):
			if !_validate_arg_type(cmd[i], i):
				return Error.ARGS_WRONG_TYPE
	return Error.CMD_VALID


# Returns true if the given arg can be converted to a valid
# specific type. The type that is considered valid is determined 
# by self.arg_type.
func _validate_arg_type(arg : String, index : int) -> bool:
	var result : bool = false
	match arg_types[index]:
		ArgType.NONE:
			result = true
		ArgType.FLOAT:
			result = arg.is_valid_float()
		ArgType.INT:
			result = arg.is_valid_integer()
		ArgType.STRING:
			result = true
		ArgType.FUNCREF:
			if target != null:
				result = target.has_method(arg)
			else:
				result = false
	return result


func execute_on_target() -> int:
	var result : int = Error.FAILED_TO_EXECUTE_ON_TARGET
	if arg_types[0] != ArgType.FUNCREF:
		result = Error.ARGS_WRONG_TYPE
	elif target == null:
		result = Error.NO_TARGET_TO_EXECUTE_ON
	else:
		pass
	return result


func to_string() -> String:
	if subcmd == null:
		return "cmd: " + name + " -args --types." + get_arg_type_string() + " --num." + String(num_args)
	return "cmd: " + name + "\n\tsubcmd: " + subcmd.to_string()


func subcmd_to_string() -> String:
	return "subcmd: " + subcmd.name + " -args --type." + ArgType.keys()[subcmd.arg_type] + " --num." + String(subcmd.num_args)


func _get_arg_string() -> String:
	var args : String = ""
	for num in num_args:
		args += String(num) + ","
	return args


func get_arg_type_string() -> String:
	var types : String = ""
	for arg_type in arg_types:
		types += ArgType.keys()[arg_type] + ","
	return types
