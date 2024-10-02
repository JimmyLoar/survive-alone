extends Node

var _time: int = 0 
var _time_max: int = 14400
var _day: int = 0 

var _reaming_add_time: int = 0
var _multiper: float = 0


func _init() -> void:
	set_physics_process(false)


func get_time_value() -> int:
	return _time


func get_time_text() -> Dictionary:
	return {
		"hour": str(ceili(_time / 600)).lpad(2, "0"),
		"minut": str(fmod(_time / 10, 60)).lpad(2, "0"),
	}


func get_day_count() -> int:
	return _day


func add_action_time(action_time: int = 0, multiper: float = 1.0):
	_reaming_add_time = action_time
	_multiper = multiper
	set_physics_process(true)


func clear_action_time():
	_reaming_add_time = 0
	_multiper = 1.0


func _physics_process(delta: float) -> void:
	if _reaming_add_time <= 0: 
		set_physics_process(false)
		return 
	
	var time_addational = ceil(delta * _multiper)
	_reaming_add_time -= time_addational
	_time += time_addational
	if _time >= _time_max:
		var _days_complited = floori(_time / _time_max)
		_day += _days_complited
		_time -= _days_complited * _time_max
