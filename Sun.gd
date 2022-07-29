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


func _process(delta) -> void:
	pivot.rotate_x(deg2rad(angular_speed_deg) * delta)
	time_of_day.set_time_of_day(pivot.rotation_degrees)
	
	if !previous_time_of_day.equals(time_of_day):
		previous_time_of_day.copy_other(time_of_day)
		#print(time_of_day.to_string())


func _on_WorldManager_sun_changed(cmd) -> void:
	match cmd[1]:
		"speed":
			_set_speed(float(cmd[2]))
		"position":
			_set_sun_position(float(cmd[2]), float(cmd[3]))
		"brightness":
			_set_sun_brightness(float(cmd[2]))


func _set_speed(speed : float) -> void:
	angular_speed_deg = speed


func _set_sun_position(latitude : float, longitude : float) -> void:
	pivot.rotation_degrees = Vector3(longitude, pivot.rotation_degrees.y, latitude)


func _set_sun_brightness(brightness : float) -> void:
	light.light_energy = brightness


# TODO:
func _set_time_of_day(hours : int, minutes : int) -> void:
	#TODO: time of day set time from hours and minutes
	var deg_x : float = time_of_day.get_sun_rotation_degrees_x_from_time_of_day(hours, minutes)
