extends Node

# TODO
#####################################################################
# Singleton that keeps track of all high-level properties of the
# game world. Is also able to manipulate those properties through
# signals which other nodes must subscribe to.
#####################################################################

signal sky_changed(cmd)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Terminal_cmd_executed(cmd) -> void:
	match cmd[0]:
		"sky":
			emit_signal("sky_changed", cmd)
