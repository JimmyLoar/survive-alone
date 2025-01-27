class_name GameTimeState
extends Injectable

var _node


func _init(node: Node):
	_node = node


signal time_changed(delta: int, value: int)
signal day_changed(value: int)

const DEFAULT_MULTYPER = 2
const TIME_MULTYPER = 10.0
const MINUT_IN_DAY = 1440 * TIME_MULTYPER
const _DATA = {
	"year": 2001,
	"month": 6,
	"day": 4,
	"hour": 11,
	"minut": 23,
}

var _reaming_add_time: int = 0

var _multiper: int = DEFAULT_MULTYPER
var _infinite: bool = false:
	set(value):
		_infinite = value
		_node.set_physics_process(value)

var _time: int = 0:  # 1 real second = 6 game minut
	get:
		return _time
	set(value):
		if _time != value:
			var delta = value - _time
			_time = value
			time_changed.emit(value, delta)

var _day: int = 0:
	get:
		return _day
	set(value):
		if _day != value:
			return
		_day = value
		day_changed.emit(value)


func init_time(time: int, day: int):
	_time = time
	_day = day
	time_changed.emit(0, _time)
	day_changed.emit(_day)


func start():
	_infinite = true
	_multiper = DEFAULT_MULTYPER


func stop():
	_infinite = false


#func add_action_time(action_minut: int = 0, multiper: int = 1):
#_multiper = clampi(multiper, 0, 1000)
#_reaming_add_time = action_minut * TIME_MULTYPER
#_time_progress.show_with_time(_reaming_add_time)
#_node.set_physics_process(true)

#func clear_action_time():
#_reaming_add_time = 0
#_multiper = DEFAULT_MULTYPER


func timeskip(min: int) -> void:
	#чтобы пропустить 2 часа нужно пропустить 1200 min (тоесть 2 часав минуты * 10)
	_time_step(min)


func _time_step(delta: int):
	_time += delta
	time_changed.emit(delta, _time)
	if _time >= MINUT_IN_DAY:
		_day += floori(_time / MINUT_IN_DAY)
		_time -= snapped(_time, MINUT_IN_DAY)
		day_changed.emit()


func get_minut() -> int:
	return fmod(_time / TIME_MULTYPER, 60)


func get_hour() -> int:
	return floori(_time / TIME_MULTYPER / 60.0)


func get_month_day() -> int:
	return fmod(_day, 30.0)


func get_month() -> int:
	return ceil(fmod(_day, 360.0) / 30)


func get_year() -> int:
	return _DATA.year + floori(_day / 360.0)


func get_date() -> Dictionary:
	return {
		"year": str(get_year()).lpad(2, "4"),
		"month": str(get_month()).lpad(2, "0"),
		"day": str(get_month_day()).lpad(2, "0"),
		"hour": str(get_hour()).lpad(2, "0"),
		"minut": str(get_minut()).lpad(2, "0"),
	}
