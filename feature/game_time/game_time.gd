extends Label


var _state: GameTimeState


func _enter_tree() -> void:
	_state = Injector.provide(GameTimeState, GameTimeState.new(self), self, "closest")


func _ready() -> void:
	_state.time_changed.connect(_update_time_label)
	Callable(func():
		var day = _state._DATA.month * 30 + _state._DATA.day
		var time = (_state._DATA.hour * 60 + _state._DATA.minut) * _state.TIME_MULTYPER
		_state.init_time(time, day)
	).call_deferred()


func _physics_process(_delta: float) -> void:
	if _state._infinite: 
		_state.time_step(_state._multiper)
		return
	
	elif _state._reaming_add_time > 0:
		_state._reaming_add_time -= _state._multiper
		_state.time_step(_state._multiper)
		return
	
	set_physics_process(false)
	return


func _update_time_label(_delta, _value):
	text = "{hour}:{minut} {day}/{month}/{year}".format(_state.get_date())
