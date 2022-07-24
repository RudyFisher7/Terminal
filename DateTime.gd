extends Reference



#####################################################################
# Encapsulates and represents a date and time
#####################################################################


class_name DateTime


const SUN_ANGLE_AT_MIDNIGHT : int = 180
const MINUTES_PER_DEGREE : float = 4.0
const MINUTES_PER_HOUR : float = 60.0
const HOURS_PER_DAY : float = 24.0
const NOON_AND_MIDNIGHT : float = 12.0
const FIRST_HOUR_OF_DAY : int = 6
const DAYS_PER_MONTH : int = 24
const MONTHS_PER_YEAR : int = 8


var _time_of_day_hrs : float
var _year : int
var _month: int
var _day_of_month : int
var _new_day_just_began : bool = false


func _init(in_time_of_day_hrs : float = 0.0, 
		   in_year : int = 2000, in_month : int = 1, 
		   in_day_of_month : int = 1) -> void:
	_time_of_day_hrs = in_time_of_day_hrs
	_year = in_year
	_month = in_month
	_day_of_month = in_day_of_month


func time_of_day_hours() -> float:
	return _time_of_day_hrs


func year() -> int:
	return _year


func month() -> int:
	return _month


func day_of_month() -> int:
	return _day_of_month


func set_time_of_day_hours(value : float) -> void:
	_time_of_day_hrs = value


# Copies the properties/fields of other onto self (this object), essentially,
# making self.equals(other) true. Does NOT change other.
func copy_other(other : DateTime) -> void:
	_time_of_day_hrs = other.time_of_day_hours()
	_year = other.year()
	_month = other.month()
	_day_of_month = other.day_of_month()


# Sets the current time of day based on the rotation of the sun about
# its x axis. This doesn't rely on any previous calculations for the time
# portion of this object. Also increments the calendar year accordingly.
func set_time_of_day(sun_rotation_degrees : Vector3) -> void:
	var minutes : int
	var is_am : bool = false
	if sun_rotation_degrees.x >= 0.0: # PM
		minutes = int(sun_rotation_degrees.x * MINUTES_PER_DEGREE)
		_new_day_just_began = false
	else: # AM
		var dif : int = SUN_ANGLE_AT_MIDNIGHT + int(sun_rotation_degrees.x)
		minutes = int(dif * MINUTES_PER_DEGREE)
		is_am = true
	_time_of_day_hrs = minutes / MINUTES_PER_HOUR
	
	if _time_of_day_hrs < 1.0:
		_time_of_day_hrs += NOON_AND_MIDNIGHT
	
	if !_new_day_just_began:
		if is_am && (int(time_of_day_hours()) == FIRST_HOUR_OF_DAY):
			_increment_day()

func to_string() -> String:
	var me : String = ""
	var tod_hrs_int : = int(_time_of_day_hrs)
	var minutes_in_current_hour : int = (_time_of_day_hrs - tod_hrs_int) * MINUTES_PER_HOUR
	me += String(tod_hrs_int) + ":"
	me += String(minutes_in_current_hour)
	me += " -- " + String(_day_of_month) + " " + String(_month) + ", " + String(_year)
	return me


# TODO:
func get_sun_rotation_degrees_x_from_time_of_day(hours : int, minutes : int) -> float:
	var sun_rotation_degrees_x : float = 0.0
	
#	var minutes : int
#	var is_am : bool = false
#	if sun_rotation_degrees.x >= 0.0: # PM
#		minutes = int(sun_rotation_degrees.x * MINUTES_PER_DEGREE)
#		_new_day_just_began = false
#	else: # AM
#		var dif : int = SUN_ANGLE_AT_MIDNIGHT + int(sun_rotation_degrees.x)
#		minutes = int(dif * MINUTES_PER_DEGREE)
#		is_am = true
#	_time_of_day_hrs = minutes / MINUTES_PER_HOUR
#
#	var minutes_in_current_hour : int = (_time_of_day_hrs - int(_time_of_day_hrs)) * MINUTES_PER_HOUR
#
#	if _time_of_day_hrs < 1.0:
#		_time_of_day_hrs += NOON_AND_MIDNIGHT
	
	return sun_rotation_degrees_x


func equals(other : DateTime) -> bool:
	return (abs(time_of_day_hours() - other.time_of_day_hours()) < 0.00001) && (year() == other.year()) && (day_of_month() == other.day_of_month())


# Increments the calendar day of this object.
func _increment_day() -> void:
	_day_of_month += 1
	
	if _day_of_month > DAYS_PER_MONTH:
		_day_of_month = 1
		_month += 1
		
		if _month > MONTHS_PER_YEAR:
			_month = 1
			_year += 1
	
	_new_day_just_began = true

