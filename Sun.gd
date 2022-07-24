extends Position3D


# TODO
#####################################################################
# Defines functionality of the world's sun
#####################################################################



const MINUTES_PER_HOUR : float = 60.0
const HOURS_PER_DAY : float = 24.0
const SUN_ANGLE_AT_MIDNIGHT : int = 180
const MINUTES_PER_DEGREE : float = 4.0
const NOON_AND_MIDNIGHT : float = 12.0


var angular_speed_deg : float = 32.0
var time_of_day : float

onready var pivot : Position3D = $Pivot
onready var pivot_previous_rotation_deg : = pivot.rotation_degrees


func _ready():
	var sig : String = "sun_changed"
	var method : String = "_on_WorldManager_sun_changed"
	WorldManager.connect(sig, self, method)


func _process(delta) -> void:
	pivot.rotate_x(deg2rad(angular_speed_deg) * delta)
	_set_time_of_day()


func _set_time_of_day() -> void:
	var minutes : int
	if pivot.rotation_degrees.x >= 0.0:
		minutes = int(pivot.rotation_degrees.x * MINUTES_PER_DEGREE)
	else:
		var dif : int = SUN_ANGLE_AT_MIDNIGHT + int(pivot.rotation_degrees.x)
		minutes = int(dif * MINUTES_PER_DEGREE)
	time_of_day = minutes / MINUTES_PER_HOUR
	
	if time_of_day < 1.0:
		time_of_day += NOON_AND_MIDNIGHT


func _on_WorldManager_sun_changed(cmd) -> void:
	match cmd[1]:
		"speed":
			_set_speed(float(cmd[2]))
		"position":
			_set_sun_position(cmd[2], cmd[3])


func _set_speed(speed : float) -> void:
	angular_speed_deg = speed


func _set_sun_position(latitude : float, longitude : float) -> void:
	pass
