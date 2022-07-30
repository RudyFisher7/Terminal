extends Reference



#####################################################################
# Encapsulates and represents a date and time
#####################################################################


class_name DateTime


enum Flag {AM, PM,}


const SUN_ANGLE_AT_MIDNIGHT : int = 180
const MINUTES_PER_DEGREE : float = 4.0
const MINUTES_PER_HOUR : float = 60.0
const HOURS_PER_DAY : float = 24.0
const NOON_AND_MIDNIGHT : float = 12.0
const FIRST_HOUR_OF_DAY : int = 6
const DAYS_PER_MONTH : int = 24
const MONTHS_PER_YEAR : int = 8


var _flag : int = Flag.AM
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


func flag() -> int:
	return _flag


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
	if sun_rotation_degrees.x >= 0.0: # Negative angle values are AM
		minutes = int(sun_rotation_degrees.x * MINUTES_PER_DEGREE)
		_new_day_just_began = false
		_flag = Flag.PM
	else:
		var dif : int = SUN_ANGLE_AT_MIDNIGHT + int(sun_rotation_degrees.x)
		minutes = int(dif * MINUTES_PER_DEGREE)
		_flag = Flag.AM
	_time_of_day_hrs = minutes / MINUTES_PER_HOUR
	
	if _time_of_day_hrs < 1.0:
		_time_of_day_hrs += NOON_AND_MIDNIGHT
	
	if !_new_day_just_began:
		if _flag == Flag.AM && (int(time_of_day_hours()) == FIRST_HOUR_OF_DAY):
			_increment_day()


func to_string() -> String:
	var me : String = ""
	var tod_hrs_int : = int(_time_of_day_hrs)
	var minutes_in_current_hour : int = (_time_of_day_hrs - tod_hrs_int) * MINUTES_PER_HOUR
	me += String(tod_hrs_int) + ":"
	me += String(minutes_in_current_hour)
	me += Flag.keys()[_flag]
	me += " -- " + String(_day_of_month) + " " + String(_month) + ", " + String(_year)
	return me


# Gets the rotation about the x axis the sun should be at the given time
# as defined by the given hours, minutes in the current hour, and am/pm flag
func get_sun_rotation_degrees_x_from_time_of_day(hours : int, 
												 minutes : int, 
												 flag : int) -> float:
	hours = clamp(hours, 0, HOURS_PER_DAY / 2)
	minutes = clamp(minutes, 0, MINUTES_PER_HOUR - 1.0)
	
	var sun_rotation_degrees_x : float = 0.0
	var cumulative_minutes : float = minutes + (hours * MINUTES_PER_HOUR)
	
	_flag = flag
	_time_of_day_hrs = cumulative_minutes / MINUTES_PER_HOUR
	
	sun_rotation_degrees_x = cumulative_minutes / MINUTES_PER_DEGREE
	
	if hours == NOON_AND_MIDNIGHT:
		if _flag == Flag.PM:
			_new_day_just_began = false
			sun_rotation_degrees_x -= SUN_ANGLE_AT_MIDNIGHT
	else:
		if _flag == Flag.AM:
			sun_rotation_degrees_x -= SUN_ANGLE_AT_MIDNIGHT
	
	if _time_of_day_hrs < 1.0:
		_time_of_day_hrs += NOON_AND_MIDNIGHT
	
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

