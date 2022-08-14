extends Node


#####################################################################
# Encapsulates a "database" in cache of all functions in the game that
# are of global scope. Also provides helper methods related to
# functions.
#####################################################################


const target_index : int = 0
const arg_num_index : int = 1
const arg_types_index : int = 2


var functions : Dictionary = {
#	"help":fun.new("help"),
#	"ls":fun.new("ls"),
#	"ps":fun.new("ps"),
#	"pkill":fun.new("pkill"),
#	"cd":fun.new("cd"),
#	"hi":fun.new("hi"),
#	"quit":fun.new("quit", null, [0, 1], [fun.ArgType.FLOAT]),
#	"mv":fun.new("mv"),
#	"sky":fun.new("sky"),
#	"sun":_sun_funs,
#	"time":_time_funs,
}


func get_function_names() -> Array:
	return functions.keys()


func validate(parsed_fun : PoolStringArray) -> int:
	var fun_error : int = Function.Error.fun_VALID
	
	if parsed_fun.empty():
		fun_error = Function.Error.NO_fun_ENTERED
	elif parsed_fun[0] in functions.keys():
		var fun = functions[parsed_fun[0]]
		
		if fun is Function:
			fun_error = fun.validate(parsed_fun)
		else:
			fun_error = Function.Error.INVALID_fun
	else:
		fun_error = Function.Error.INVALID_fun
	
	return fun_error


func populate_functions(object : Object, function_builder : Dictionary) -> Dictionary:
	var functions : Dictionary = {}
	for fun in object.get_method_list():
		if fun["flags"] == METHOD_FLAG_NORMAL + METHOD_FLAG_FROM_SCRIPT:
			var fun_name : String = fun["name"]
			if fun_name in function_builder.keys():
				var fun_info : Array = function_builder[fun_name]
				var function : = Function.new(fun_name, fun_info[target_index],\
										funcref(fun_info[target_index],\
										fun_name), fun_info[arg_num_index],\
										fun_info[arg_types_index])
				functions[fun_name] = function
	for key in functions.keys():
		print(functions[key].to_string())
	return functions




