extends PanelContainer


var _state: GameTimeState
var click_to_cansel := false

@onready var progress_bar: TextureProgressBar = $VBoxContainer/TextureProgressBar


func _enter_tree() -> void:
	_state = Injector.provide(GameTimeState, GameTimeState.new(self), self, Injector.ContainerType.CLOSEST)


func _ready() -> void:
	_register_methods()


func _register_methods():
	var execute_keeper := Injector.inject(ExecuteKeeperState, self) as ExecuteKeeperState
	var _use_time := func(time:int, real_time: float, use_progress_bar: bool):
		_state.timeskip(time, real_time, use_progress_bar)
		await _state.finished_skip
		return _state._remiang_value <= 0
	
	execute_keeper.register(
		execute_keeper.TYPE_CONDITION, "is used time", _use_time,
		["int/1,1440,1,or_greater", "float/0.1,10,0.1,or_greater", "bool"], 
		["time", "real_time", "using_progres_bar"], 
		[15, 1.0, false]
	)
	
	execute_keeper.register(
		execute_keeper.TYPE_EFFECT, "time skip", _state.timeskip,
		["int/1,1440,1,or_greater", "float/0.1,10,0.1,or_greater", "bool"], 
		["time", "real_time", "using_progres_bar"], 
		[15, 1.0, false]
	)
	return


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released() and visible:
		if click_to_cansel:
			click_to_cansel = false
			close()
			_state.finish_skip()
		
		else:
			click_to_cansel = true
			get_tree().create_timer(1.5).timeout.connect(func(): click_to_cansel = false)


func open():
	if not _state.started_skip.is_connected(_reset):
		_state.started_skip.connect(_reset)
		_state.finished_step.connect(_update)
		_state.finished_skip.connect(close)
	self.show()


func close(_reamin_value: int = 0):
	self.hide()
	if _state.started_skip.is_connected(_reset):
		_state.started_skip.disconnect(_reset)
		_state.finished_step.disconnect(_update)
		_state.finished_skip.disconnect(close)


func _reset(start_value: int):
	progress_bar.max_value = start_value
	progress_bar.value = 0


func _update(delta: int):
	if not visible: return
	progress_bar.value += delta



	
