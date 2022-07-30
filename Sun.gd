extends Position3D


# TODO
#####################################################################
# Defines functionality of the world's sun
#####################################################################


export var path_to_pivot : NodePath
export var path_to_light : NodePath


var angular_speed_deg : float = 2.0
var previous_time_of_day : = DateTime.new()
var time_of_day : = DateTime.new()

onready var pivot : Position3D = get_node(path_to_pivot)
onready var light : DirectionalLight = get_node(path_to_light)
onready var pivot_previous_rotation_deg : = pivot.rotation_degrees


func _ready():
	var sig : String = "sun_changed"
	var method : String = "_on_WorldManager_sun_changed"
	WorldManager.connect(sig, self, method)
	
	sig = "time_changed"
	method = "_on_WorldManager_time_changed"
	WorldManager.connect(sig, self, method)


func _process(delta) -> void:
	pivot.rotate_x(deg2rad(angular_speed_deg) * delta)
	time_of_day.set_time_of_day(pivot.rotation_degrees)
	
	if !previous_time_of_day.equals(time_of_day):
		previous_time_of_day.copy_other(time_of_day)
		print(time_of_day.to_string())
		print(rad2deg(pivot.rotation.x))


func _on_WorldManager_sun_changed(cmd) -> void:
	match cmd[1]:
		"speed":
			_set_speed(float(cmd[2]))
		"position":
			_set_sun_position(float(cmd[2]), float(cmd[3]))
		"brightness":
			_set_sun_brightness(float(cmd[2]))


func _on_WorldManager_time_changed(cmd : PoolStringArray) -> void:
	var arg_2 : String = "0"
	if cmd.size() >= 4:
		arg_2 = cmd[3]
		
	_set_time_of_day(cmd[1], int(cmd[2]), int(arg_2))


func _set_speed(speed : float) -> void:
	angular_speed_deg = speed


func _set_sun_position(latitude : float, longitude : float) -> void:
	pivot.rotation_degrees = Vector3(longitude, pivot.rotation_degrees.y, latitude)


func _set_sun_brightness(brightness : float) -> void:
	light.light_energy = brightness


# TODO:
func _set_time_of_day(am_pm : String, hours : int, minutes : int) -> void:
	#TODO: time of day set time from hours and minutes
	var flag : int = DateTime.Flag.get(am_pm.to_upper())
	var deg_x : float = time_of_day.get_sun_rotation_degrees_x_from_time_of_day(hours, minutes, flag)
	pivot.rotation.x = deg2rad(deg_x)
	print(time_of_day.to_string())
