extends Reference


#####################################################################
# Represents a Function.
#####################################################################


class_name Function


enum ArgType {
	NONE,
	FLOAT,
	INT,
	STRING,
}


enum Error {
	FUNCTION_VALID,
	INVALID_FUNCTION,
	ARGS_WRONG_TYPE,
	ARGS_WRONG_TYPE_OR_OUT_OF_RANGE,
	INVALID_ARG,
	ARGS_OUT_OF_RANGE,
	WRONG_NUMBER_OF_ARGS,
	NO_FUNCTION_ENTERED,
	FAILED_TO_EXECUTE,
	FUNCTION_INVALID,
}


const name_index : int = 0


var name : String
var func_ref : FuncRef
var num_args : Array
var arg_types : Array


func _init(in_name : String, 
		   in_func_ref : FuncRef,
		   in_num_args : = [0], 
		   in_arg_types : Array = [ArgType.NONE]) -> void:
	name = in_name
	func_ref = in_func_ref
	num_args = in_num_args
	arg_types = in_arg_types


func validate(pool_func : PoolStringArray) -> int:
	var function : = Array(pool_func)
	if name != function[name_index]:
		return Error.INVALID_FUNCTION

	var first_arg_index : int = name_index + 1
	if !(function.size() - first_arg_index) in num_args:
		return Error.WRONG_NUMBER_OF_ARGS
	
	for i in range(first_arg_index, function.size()):
		if !_validate_arg_type(function[i], i):
			return Error.ARGS_WRONG_TYPE
	return Error.FUNCTION_VALID


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
	return result


func _manage_args(pool_func : PoolStringArray) -> Array:
	var managed_args : Array = []
	for index in range(name_index + 1, pool_func.size()):
		match arg_types[index]:
			ArgType.FLOAT:
				managed_args.append(float(pool_func[index]))
			ArgType.INT:
				managed_args.append(int(pool_func[index]))
			ArgType.STRING:
				managed_args.append(pool_func[index])
	return managed_args


func execute(pool_func : PoolStringArray) -> int:
	var result : int = Error.FAILED_TO_EXECUTE
	if !func_ref.is_valid():
		result = Error.FUNCTION_INVALID
	else:
		var managed_args : = _manage_args(pool_func)
		func_ref.call_funcv(managed_args)
	return result


func to_string() -> String:
	return "func: " + name + " -args --types." + get_arg_type_string() + " --nums." + String(num_args)


func get_arg_type_string() -> String:
	var types : String = ""
	for arg_type in arg_types:
		types += ArgType.keys()[arg_type] + ","
	return types

