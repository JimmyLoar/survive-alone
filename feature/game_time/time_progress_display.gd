extends PanelContainer


var _state: GameTimeState


@onready var progress_bar: TextureProgressBar = $VBoxContainer/TextureProgressBar


func _enter_tree() -> void:
	_state = Injector.provide(GameTimeState, GameTimeState.new(self), self, "closest")
	_state.time = Injector.provide(GameTimeEntity, _state.time, self, "closest")


func open():
	_state.started_skip.connect(_reset)
	_state.finished_step.connect(_update)
	_state.finished_skip.connect(close)
	self.show()


func close(finish_value: int):
	self.hide()
	_state.started_skip.disconnect(_reset)
	_state.finished_step.disconnect(_update)
	_state.finished_skip.disconnect(close)


func _reset(start_value: int):
	progress_bar.max_value = start_value
	progress_bar.value = 0


func _update(delta: int):
	if not visible: return
	progress_bar.value += delta
