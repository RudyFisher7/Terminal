extends Node

# TODO
#####################################################################
# Encapsulates a "database" in cache of all commands in the game.
#####################################################################


var _sun_cmds : Dictionary = {
	"speed":Cmd.new("sun", Cmd.new("speed", null, [1], Cmd.ArgType.FLOAT)),
	"position":Cmd.new("sun", Cmd.new("position", null, [2], Cmd.ArgType.FLOAT)),
	"brightness":Cmd.new("sun", Cmd.new("brightness", null, [1], Cmd.ArgType.FLOAT)),
}


var _time_cmds : Dictionary = {
	"am":Cmd.new("time", Cmd.new("am", null, [1, 2], Cmd.ArgType.INT)),
	"pm":Cmd.new("time", Cmd.new("pm", null, [1, 2], Cmd.ArgType.INT)),
}


var _cmds : Dictionary = {
	"help":Cmd.new("help"),
	"ls":Cmd.new("ls"),
	"ps":Cmd.new("ps"),
	"pkill":Cmd.new("pkill"),
	"cd":Cmd.new("cd"),
	"hi":Cmd.new("hi"),
	"quit":Cmd.new("quit", null, [0, 1], Cmd.ArgType.FLOAT),
	"mv":Cmd.new("mv"),
	"sky":Cmd.new("sky"),
	"sun":_sun_cmds,
	"time":_time_cmds,
}


func get_cmd_to_string(cmd_name : String) -> String:
	var cmd = _cmds[cmd_name]
	
	if cmd is Cmd:
		return _cmds[cmd_name].to_string()
	elif cmd is Dictionary:
		var result : String = "cmd: " + cmd_name + "\n"
		for key in cmd.keys():
			result += "\t" + cmd[key].subcmd_to_string() + "\n"
		return result
	else:
		return ""


func get_all_cmd_names() -> Array:
	var cmd_keys = _cmds.keys()
	cmd_keys.append_array(_sun_cmds.keys())
	cmd_keys.append_array(_time_cmds.keys())
	return cmd_keys


func get_cmd_names() -> Array:
	return _cmds.keys()


func get_all_subcmds() -> Array:
	var cmd_keys = _sun_cmds.keys()
	cmd_keys.append_array(_time_cmds.keys())
	#cmd_keys.append_array(<other subcmd dictionary>.keys())
	return cmd_keys


func validate(parsed_cmd : PoolStringArray) -> int:
	var cmd_error : int = Cmd.Error.CMD_VALID
	
	if parsed_cmd.empty():
		cmd_error = Cmd.Error.NO_CMD_ENTERED
	elif parsed_cmd[0] in _cmds.keys():
		var cmd = _cmds[parsed_cmd[0]]
		
		if cmd is Dictionary:
			if parsed_cmd.size() > 1:
				if parsed_cmd[1] in cmd.keys():
					cmd = cmd[parsed_cmd[1]]
		
		if cmd is Cmd:
			cmd_error = cmd.validate(parsed_cmd)
		else:
			cmd_error = Cmd.Error.INVALID_CMD
	else:
		cmd_error = Cmd.Error.INVALID_CMD
	
	return cmd_error





