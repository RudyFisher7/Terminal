extends Reference

# TODO
#####################################################################
# Represents a cmd.
#####################################################################

class_name Cmd

enum ArgType {
	NONE,
	FLOAT,
	INT,
	STRING,
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
}

const name_index : int = 0

var name : String
var subcmd : Cmd
var num_args : Array
var arg_type : int

func _init(in_name : String, in_subcmd : Cmd = null, 
		   in_num_args : = [0], 
		   in_arg_type : int = ArgType.NONE) -> void:
	name = in_name
	subcmd = in_subcmd
	num_args = in_num_args
	arg_type = in_arg_type


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
			if !_validate_arg_type(cmd[i]):
				return Error.ARGS_WRONG_TYPE
	return Error.CMD_VALID


# Returns true if the given arg can be converted to a valid
# specific type. The type that is considered valid is determined 
# by self.arg_type.
func _validate_arg_type(arg : String) -> bool:
	match arg_type:
		ArgType.NONE:
			return true
		ArgType.FLOAT:
			return arg.is_valid_float()
		ArgType.INT:
			return arg.is_valid_integer()
		ArgType.STRING:
			return true
		_:
			return true
