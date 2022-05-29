extends WorldEnvironment

# TODO
#####################################################################
# Singleton that keeps track of all high-level properties of the
# game world. Is also able to manipulate those properties through
# signals which other nodes must subscribe to.
#####################################################################


func _ready():
	var sig : String = "sky_changed"
	var method : String = "_on_WorldManager_sky_changed"
	WorldManager.connect(sig, self, method)


func _on_WorldManager_sky_changed(cmd) -> void:
	match cmd[1]:
		"sun":
			_set_sun_latitude(float(cmd[2]))


func _set_sun_latitude(latitude : float) -> void:
	var sky : Sky = get_environment().background_sky
	sky.sun_latitude = latitude
	print("sun lat: " + String(sky.sun_latitude))
