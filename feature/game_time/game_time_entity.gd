class_name GameTimeEntity


const MINUT_IN_HOUR	 = 60.0
const MINUT_IN_DAY	 = 1440.0
const MINUT_IN_MONTH = 43200.0
const MINUT_IN_YEAR	 = 518400.0

signal changed_value(new_value)

var _value: int = 0:
	set(value):
		_value = value
		changed_value.emit(_start_value + _value)

var _start_value: int


func _init(start_value: int) -> void:
	_start_value = start_value


func get_minut() -> int: 		return time_to_minut(_start_value + _value)
func get_hour() -> int: 		return time_to_hour	(_start_value + _value)
func get_day() -> int: 			return time_to_day	(_start_value + _value)
func get_month() -> int: 		return time_to_month(_start_value + _value)
func get_year() -> int: 		return time_to_year	(_start_value + _value)


func get_date() -> Dictionary:
	return {
		"year": 	str(get_year()).lpad(4, "0"),
		"month": 	str(get_month()).lpad(2, "0"),
		"day": 		str(get_day()).lpad(2, "0"),
		"hour": 	str(get_hour()).lpad(2, "0"),
		"minut": 	str(get_minut()).lpad(2, "0"),
	}

@warning_ignore_start('narrowing_conversion')
static func time_to_minut(time: int) -> int:
	return fmod(time, MINUT_IN_HOUR)
static func time_to_hour(time: int) -> int:
	return fmod(floori(time / MINUT_IN_HOUR), 24)
static func time_to_day(time: int) -> int:
	return fmod(ceili(time / MINUT_IN_DAY), 30)
static func time_to_month(time: int) -> int:
	return fmod(ceili(time / MINUT_IN_MONTH), 12)
static func time_to_year(time: int) -> int:
	return floori(time / MINUT_IN_YEAR)


static func hour_to_time(hours: int) -> int:
	return MINUT_IN_HOUR * hours
static func day_to_time(days: int) -> int:
	return MINUT_IN_DAY * days
static func month_to_time(months: int) -> int:
	return MINUT_IN_MONTH * months
static func year_to_time(years: int) -> int:
	return MINUT_IN_YEAR * years


static func date_to_time(date: Dictionary) -> int:
	var _time: int = 0
	_time += year_to_time(int(date.year))
	_time += month_to_time(int(date.month) - 1)
	_time += day_to_time(int(date.day) - 1)
	_time += hour_to_time(int(date.hour))
	_time += int(date.minut)
	return _time
@warning_ignore_restore('narrowing_conversion')
