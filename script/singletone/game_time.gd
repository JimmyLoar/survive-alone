extends Node

signal new_day
signal time_update(delta: int)
signal time_skipped(skipped_time: int)

const DEFAULT_MULTYPER = 2
const TIME_MULTYPER = 10
const MINUT_IN_DAY = 1440 * TIME_MULTYPER
const _DATA =  {
		"year": 2001,
		"month": 6, 
		"day": 4,
		"hour": 11,
		"minut": 23,
	}

var _time: int = 0  # 1 real second = 6 game minut
var _day: int = 0 

var _reaming_add_time: int = 0
var _multiper: int = DEFAULT_MULTYPER
var _infinite: bool = false:
	set(value):
		_infinite = value
		set_physics_process(value)

var _time_progress: CanvasLayer

func _init() -> void:
	#set_physics_process(false)
	_time = (_DATA.hour * 60 + _DATA.minut) * TIME_MULTYPER
	_day = _DATA.month * 30 + _DATA.day
	
	_time_progress = preload("uid://ddfsnjx44w5ik").instantiate()
	add_child(_time_progress)


func get_minut() -> int: return fmod(_time / TIME_MULTYPER, 60)
func get_hour()  -> int: return floori(_time / TIME_MULTYPER / 60.0)
func get_day()   -> int: return fmod(_day, 30.0) 
func get_month() -> int: return ceil(fmod(_day, 360.0) / 30)
func get_year()  -> int: return _DATA.year + floori(_day / 360.0)


func get_date() -> Dictionary:
	return {
		"year": str(get_year()).lpad(2, "4"),
		"month": str(get_month()).lpad(2, "0"),
		"day": str(get_day()).lpad(2, "0"),
		"hour": str(get_hour()).lpad(2, "0"),
		"minut": str(get_minut()).lpad(2, "0"),
	}


func start():
	_infinite = true
	_multiper = DEFAULT_MULTYPER


func stop():
	_infinite = false


func add_action_time(action_minut: int = 0, multiper: int = 1):
	_multiper = clampi(multiper, 0, 1000)
	_reaming_add_time = action_minut * TIME_MULTYPER
	_time_progress.show_with_time(_reaming_add_time)
	set_physics_process(true)


func clear_action_time():
	_reaming_add_time = 0
	_multiper = DEFAULT_MULTYPER


func timeskip(minut: int) -> void:
	_time_step(minut)


func _physics_process(_delta: float) -> void:
	if _infinite: 
		_time_step(_multiper)
		return
	
	elif _reaming_add_time > 0:
		_reaming_add_time -= _multiper
		_time_step(_multiper)
		return
	
	set_physics_process(false)
	return


func _time_step(delta: int):
	_time += delta
	emit_signal("time_update", delta)
	if _time >= MINUT_IN_DAY:
		_day += floori(_time / MINUT_IN_DAY)
		_time -= snapped(_time, MINUT_IN_DAY)
		new_day.emit()
	
	PlayerProperty.update(delta)
