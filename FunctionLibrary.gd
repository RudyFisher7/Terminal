extends Reference


#####################################################################
# Encapsulates a library of Functions.
#####################################################################


class_name FunctionLibrary


const target_index : int = 0
const name_index : int = 1
const builder_arg_num_index : int = 1
const builder_arg_types_index : int = 2


var functions : Dictionary = {
}


func get_function_names() -> Array:
	return functions.keys()


# Not safe. First call validate().
func get_function(pool_function : PoolStringArray) -> Function:
	return functions[pool_function[name_index]]

func validate(parsed_fun : PoolStringArray) -> int:
	var fun_error : int = Function.Error.FUNCTION_VALID
	
	if parsed_fun.empty():
		fun_error = Function.Error.NO_FUNCTION_ENTERED
	elif parsed_fun[name_index] in functions.keys():
		var fun = functions[parsed_fun[name_index]]
		
		if fun is Function:
			fun_error = fun.validate(parsed_fun)
		else:
			fun_error = Function.Error.INVALID_FUNCTION
	else:
		fun_error = Function.Error.INVALID_FUNCTION
	
	return fun_error


func populate_functions(object_with_methods : Object, 
						function_builder : Dictionary) -> Dictionary:
	var funs : Dictionary = {}
	for fun in object_with_methods.get_method_list():
		if fun["flags"] == METHOD_FLAG_NORMAL + METHOD_FLAG_FROM_SCRIPT:
			var fun_name : String = fun["name"]
			if fun_name in function_builder.keys():
				var fun_info : Array = function_builder[fun_name]
				var function : = Function.new(fun_name, fun_info[target_index],\
									funcref(fun_info[target_index],\
									fun_name), fun_info[builder_arg_num_index],\
									fun_info[builder_arg_types_index])
				funs[fun_name] = function
	for key in funs.keys():
		print(funs[key].to_string())
	return funs


func unmerge_library(fun_lib : Dictionary) -> void:
	for key in fun_lib.keys():
		functions.erase(key)
