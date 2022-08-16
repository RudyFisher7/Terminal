extends Node


#####################################################################
# Encapsulates a "database" in cache of all functions in the game that
# are of global scope. Also provides helper methods related to
# functions.
#####################################################################

#	"help":fun.new("help"),
#	"ls":fun.new("ls"),
#	"ps":fun.new("ps"),
#	"pkill":fun.new("pkill"),
#	"cd":fun.new("cd"),
#	"hi":fun.new("hi"),
#	"quit":fun.new("quit", null, [0, 1], [fun.ArgType.FLOAT]),
#	"mv":fun.new("mv"),
#	"sky":fun.new("sky"),

class_name GlobalFunctionLibrary

var function_library : = FunctionLibrary.new()



