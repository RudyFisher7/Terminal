extends Node

# TODO
#####################################################################
# Encapsulates a "database" of all commands in the game and their
# validation.
#####################################################################

enum {
	LS,
	PS,
	PKILL,
	CD,
	HI,
	QUIT,
	MV,
	SKY,
	SUN,
}

enum CmdErrors {
	CMD_VALID,
	INVALID_CMD,
	ARGS_WRONG_TYPE,
	ARGS_WRONG_TYPE_OR_OUT_OF_RANGE,
	INVALID_ARG,
	ARGS_OUT_OF_RANGE,
	WRONG_NUMBER_OF_ARGS,
	NO_CMD_ENTERED,
}

var cmd_keys : Dictionary = {
	"ls":LS,
	"ps":PS,
	"pkill":PKILL,
	"cd":CD,
	"hi":HI,
	"quit":QUIT,
	"mv":MV,
	"sky":SKY,
	"sun":SUN,
}

var _cmds : Dictionary = {
	LS:funcref(self, "_validate_ls"), # List all game objects, maybe arg "-p" could be list all
		  # people
	PS:funcref(self, "_validate_ps"), # Lists all the running machines in the world
	PKILL:funcref(self, "_validate_ps"), # Kills all running machines in the world 
			 # (options: <name of machine>)
	CD:funcref(self, "_validate_ps"),
	HI:funcref(self, "_validate_hi"),
	QUIT:funcref(self, "_validate_quit"),
	MV:funcref(self, "_validate_ps"),
	SKY:funcref(self, "_validate_sky"),
	SUN:funcref(self, "_validate_sun"),
}

# Validates commands.
# The structure of the validator is:
# key = cmd key enum,
# value = {<subcommand>, <length of whole command, including the key>}
# E.g. ">>sun speed 22.0" has a subcommand "speed" and a length of 3,
# so it would be valid in this case
var cmd_validator : Dictionary = {
	LS:[], # List all game objects, maybe arg "-p" could be list all
		  # people
	PS:[], # Lists all the running machines in the world
	PKILL:[], # Kills all running machines in the world 
			 # (options: <name of machine>)
	CD:[],
	HI:[],
	QUIT:[],
	MV:[],
	SKY:[],
	SUN:{"speed":3,"position":4,"brightness":3,}
}


func get_cmds() -> Array:
	return cmd_keys.keys()


func validate(parsed_cmd : PoolStringArray) -> int:
	var cmd_error : int = CmdErrors.CMD_VALID
	if parsed_cmd.size() > 0:
		if parsed_cmd[0] in cmd_keys.keys():
			var key : int = cmd_keys[parsed_cmd[0]]
			var validator_dict : Dictionary = cmd_validator[key]
			if parsed_cmd[1] in validator_dict.keys():
				if parsed_cmd.size() != validator_dict[parsed_cmd[1]]:
						cmd_error = CmdErrors.WRONG_NUMBER_OF_ARGS
			else:
				cmd_error = CmdErrors.INVALID_CMD
		else:
			cmd_error = CmdErrors.INVALID_CMD
	else:
		cmd_error = CmdErrors.NO_CMD_ENTERED
	return cmd_error


func _validate_ls(parsed_cmd : PoolStringArray) -> int:
	return 0


func _validate_ps(parsed_cmd : PoolStringArray) -> int:
	return 0


func _validate_hi(parsed_cmd : PoolStringArray) -> int:
	var result : int = 0
	if !parsed_cmd.size() == 1:
		result = CmdErrors.WRONG_NUMBER_OF_ARGS
	return result


# TODO: clean up, debug, finish implementing
func _validate_sun(parsed_cmd : PoolStringArray) -> int:
	var result : int = 0
	if !parsed_cmd.size() == 3:
		result = CmdErrors.WRONG_NUMBER_OF_ARGS
	return result


# TODO: clean up, debug, finish implementing
func _validate_sky(parsed_cmd : PoolStringArray) -> int:
	var result : int = 0
	var arg_2_i: int = 2
	var arg_3_i: int = 3
	var cmd_size : int = 4
	var max_lat_long : float = 180
	var zero : String = "0"
	var second_args : Array = [
		"sun"
	]
	
	if !parsed_cmd.size() == cmd_size:
		result = CmdErrors.WRONG_NUMBER_OF_ARGS
	elif !parsed_cmd[1] in second_args:
		result = CmdErrors.INVALID_ARG
	else:
		var still_valid : bool = true
		var i : int = arg_2_i
		while still_valid && i < parsed_cmd.size():
			var arg_float : float = float(parsed_cmd[i])
			var is_above_min : bool = arg_float >= -max_lat_long
			var is_below_max : bool = arg_float <= max_lat_long
			if arg_float == 0:
				if parsed_cmd[i] != zero:
					still_valid = false
					result = CmdErrors.ARGS_WRONG_TYPE
			elif !is_above_min || !is_below_max:
				still_valid = false
				result = CmdErrors.ARGS_OUT_OF_RANGE
	return result


func _validate_quit(parsed_cmd : PoolStringArray) -> int:
	var result : int = 0
	var max_cmd_size : int = 2
	if !parsed_cmd.size() in [1, max_cmd_size]:
		result = CmdErrors.WRONG_NUMBER_OF_ARGS
	elif parsed_cmd.size() == max_cmd_size:
		if !float(parsed_cmd[1]) > 0:
			result = CmdErrors.ARGS_WRONG_TYPE_OR_OUT_OF_RANGE
	return result





