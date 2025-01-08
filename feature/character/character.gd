class_name Character
extends Node2D

var _state: CharacterState

@export var time_unit = 10 # times per one _physics_process
@export var move_speed = 50 # pixels per time_unit
@onready var _moving_line = %MovingLine
@onready var _screen_mouse_events: ScreenMouseEventsState = Injector.inject(ScreenMouseEventsState, self)
@onready var _game_time: GameTimeState = Injector.inject(GameTimeState, self)
@onready var _character_properties_repository: CharacterPropertyRepository = Injector.inject(CharacterPropertyRepository, self)

func _enter_tree() -> void:
	_state = Injector.provide(CharacterState, CharacterState.new(self), self, "closest")

func _ready() -> void:
	_screen_mouse_events.left_button_changed.connect(_on_screen_left_button)
	_game_time.time_changed.connect(_update_props_by_time_spend)
	
	Callable(func():
		var props = _character_properties_repository.get_all()
		var dict = Dictionary()
		for prop in props:
			dict[prop.name_key] = prop
		_state._properties = dict
	).call_deferred()

func _on_screen_left_button(value):
	if value is ScreenMouseEventsState.Click:
		_state.target_position = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	if _state.is_moving:
		_process_moving(delta)
	else:
		_process_idle()

func _process_moving(delta: float):
	var move_step = delta * move_speed
	var distance = _state.position.distance_to(_state.target_position)

	if distance > move_step:
		_state.position =_state.position.move_toward(_state.target_position, move_step)
		_game_time.timeskip(time_unit)
	else:
		_state.position = _state.target_position
		_game_time.timeskip(time_unit * (distance / move_step))

	_moving_line.points[1] = _state.target_position - _state.position
	_moving_line.show()

func _process_idle():
	_moving_line.hide()

func _update_props_by_time_spend(delta: int, _time: int):
	var props = _state._properties.values()
	for prop in props:
		var prop_value_delta = prop.default_delta_value * delta
		if prop_value_delta != 0:
			prop.default_value += prop_value_delta
			_state.set_property(prop)
