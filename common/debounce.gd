class_name Debounce

var _time = 0
var _fn: Callable
var _timer: SceneTreeTimer = null


func _init(fn: Callable, time) -> void:
	_fn = fn
	_time = time


func emit():
	_reset_timer()
	_timer = Engine.get_main_loop().create_timer(_time, true, true)
	_timer.timeout.connect(_fn)


func _reset_timer():
	if _timer != null:
		_timer.timeout.disconnect(_fn)
		_timer = null
