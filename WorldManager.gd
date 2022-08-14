extends Node

# TODO
#####################################################################
# Singleton that keeps track of all high-level properties of the
# game world. Is also able to manipulate those properties through
# signals which other nodes must subscribe to.
#####################################################################


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
