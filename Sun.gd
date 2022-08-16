extends Position3D


# TODO
#####################################################################
# Defines functionality of the world's sun
#####################################################################


export var path_to_pivot : NodePath
export var path_to_light : NodePath


var function_builder : Dictionary = {
	"set_speed":[self, [1], [Function.ArgType.FLOAT]],
	"set_position":[self, [2], [Function.ArgType.FLOAT, Function.ArgType.FLOAT]],
	"set_brightness":[self, [1], [Function.ArgType.FLOAT]],
}


var functions : Dictionary = {}


var angular_speed_deg : float = 2.0
var previous_time_of_day : = DateTime.new()
var time_of_day : = DateTime.new()

onready var pivot : Position3D = get_node(path_to_pivot)
onready var light : DirectionalLight = get_node(path_to_light)
onready var pivot_previous_rotation_deg : = pivot.rotation_degrees


func _ready():
	functions = GlobalLibrary.function_library.populate_functions(self, function_builder)
	GlobalLibrary.function_library.functions.merge(functions)


func _process(delta) -> void:
	pivot.rotate_x(deg2rad(angular_speed_deg) * delta)
	time_of_day.set_time_of_day(pivot.rotation_degrees)
	
	if !previous_time_of_day.equals(time_of_day):
		previous_time_of_day.copy_other(time_of_day)


func set_speed(speed : float) -> void:
	angular_speed_deg = speed


func set_position(latitude : float, longitude : float) -> void:
	pivot.rotation_degrees = Vector3(longitude, pivot.rotation_degrees.y, latitude)


func set_brightness(brightness : float) -> void:
	light.light_energy = brightness


# TODO:
func set_time_of_day(am_pm : String, hours : int, minutes : int) -> void:
	#TODO: time of day set time from hours and minutes
	var flag : int = DateTime.Flag.get(am_pm.to_upper())
	var deg_x : float = time_of_day.get_sun_rotation_degrees_x_from_time_of_day(hours, minutes, flag)
	pivot.rotation.x = deg2rad(deg_x)
	print(time_of_day.to_string())
