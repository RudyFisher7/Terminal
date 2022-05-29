extends Reference

# TODO
#####################################################################
# Encapsulates a "database" of all commands in the game and their
# validation.
#####################################################################

class_name Commands

const cmd_errors : Dictionary = {
	0:"Cmd sent successfully.",
	1:"Invalid command: - ",
	2:"Arguments wrong type: - ",
	3:"Wrong number of arguments: - ",
}

var cmds : Dictionary = {
	"ls":funcref(self, "_validate_ls"), # List all game objects, maybe arg "-p" could be list all
		  # people
	"ps":funcref(self, "_validate_ps"), # Lists all the running machines in the world
	"pkill":funcref(self, "_validate_ps"), # Kills all running machines in the world 
			 # (options: <name of machine>)
	"cd":funcref(self, "_validate_ps"),
	"hi":funcref(self, "_validate_hi"),
	"quit":funcref(self, "_validate_quit"),
	"mv":funcref(self, "_validate_ps"),
	"sky":funcref(self, "_validate_sky"),
}


func validate_cmd(cmd) -> String:
	var cmd_error : String = cmd_errors[0]
	if cmd[0] in cmds.keys():
		var func_ref : FuncRef = cmds[cmd[0]]
		if func_ref.is_valid():
			cmd_error = func_ref.call_func(cmd)
	return cmd_error


func _validate_ls(cmd) -> String:
	return ""


func _validate_ps(cmd) -> String:
	return ""


func _validate_hi(cmd) -> String:
	return ""


func _validate_sky(cmd) -> String:
	return ""


func _validate_quit(cmd) -> String:
	return ""





