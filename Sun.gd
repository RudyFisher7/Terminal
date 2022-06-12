extends Position3D


# TODO
#####################################################################
# Defines functionality of the world's sun
#####################################################################


func _ready():
	var sig : String = "sun_changed"
	var method : String = "_on_WorldManager_sun_changed"
	WorldManager.connect(sig, self, method)


func _process(delta) -> void:
	pass


func _on_WorldManager_sun_changed(cmd) -> void:
	match cmd[1]:
		"speed":
			_set_speed(float(cmd[2]))
		"time":
			_set_time_of_day(cmd[2])


func _set_speed(speed : float) -> void:
	pass


func _set_time_of_day(time_of_day : Vector2) -> void:
	pass
