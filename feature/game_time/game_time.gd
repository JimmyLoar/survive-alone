extends Label


var _state: GameTimeState

func _enter_tree() -> void:
	_state = Injector.provide(GameTimeState, GameTimeState.new(self), self, "closest")


func _ready() -> void:
	_state.finished_step.connect(_update_time_label)
	_update_time_label(0)


func _update_time_label(_delta):
	text = "{hour}:{minut} {day}/{month}/{year}".format(_state._time.get_date())
