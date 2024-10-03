extends Node

signal new_day
signal time_update(delta: int)
signal time_skipped(skipped_time: int)

const TIME_MULTYPER = 10
const MINUT_IN_DAY = 1440 * TIME_MULTYPER
const _DATA =  {
		"year": 2001,
		"month": 7, 
		"day": 4,
		"hour": 11,
		"minut": 23,
	}

var _time: int = 0 
var _day: int = 0 

var _reaming_add_time: int = 0
var _multiper: float = 0


func _init() -> void:
	set_physics_process(false)
	_time = (_DATA.hour * 60 + _DATA.minut) * TIME_MULTYPER
	_day = _DATA.month * 30 + _DATA.day


func get_date() -> Dictionary:
	return {
		"year": str(get_year()).lpad(2, "4"),
		"month": str(get_month()).lpad(2, "0"),
		"day": str(get_day()).lpad(2, "0"),
		"hour": str(get_hour()).lpad(2, "0"),
		"minut": str(get_minut()).lpad(2, "0"),
	}

func get_minut() -> int: return fmod(_time / TIME_MULTYPER, 60)
func get_hour()  -> int: return floori(_time / TIME_MULTYPER / 60.0)
func get_day()   -> int: return fmod(_day, 30.0) 
func get_month() -> int: return ceil(fmod(_day, 360.0) / 30)
func get_year()  -> int: return _DATA.year + floori(_day / 360.0)


func add_action_time(action_time: int = 0, multiper: float = 1.0):
	_multiper = clampi(multiper, 0, 1000)
	_reaming_add_time += action_time * _multiper
	set_physics_process(true)


func clear_action_time():
	_reaming_add_time = 0
	_multiper = 1.0


func timeskip(time_in_minut: int) -> void:
	pass


func _physics_process(_delta: float) -> void:
	if _reaming_add_time <= 0: 
		set_physics_process(false)
		return 
	
	var time_addational = ceili(_multiper)
	_reaming_add_time -= time_addational
	_time += time_addational
	emit_signal("time_update", time_addational)
	if _time >= MINUT_IN_DAY:
		_day += floori(_time / MINUT_IN_DAY)
		_time -= snapped(_time, MINUT_IN_DAY)
		new_day.emit()
