class_name Throttle

var _time = 0
var _fn: Callable
var _timer: SceneTreeTimer = null


@warning_ignore("shadowed_variable")
func _init(fn: Callable, time) -> void:
	_fn = fn
	_time = time


func fn():
	if _timer == null:
		fn.call()
		_timer = Engine.get_main_loop().create_timer(_time, true, true)
		_timer.timeout.connect(_reset_timer)


func _reset_timer():
	_timer = null
