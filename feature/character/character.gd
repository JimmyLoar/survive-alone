class_name Character
extends Node2D

var _state: CharacterState

@export var time_unit = 1 # times per one _physics_process
@export var move_speed = 50 # pixels per time_unit
@onready var _moving_line = %MovingLine
@onready var _screen_mouse_events: ScreenMouseEventsState = Injector.inject(ScreenMouseEventsState, self)
@onready var _game_time: GameTimeState = Injector.inject(GameTimeState, self)
@onready var _character_repositoty: CharacterRepository = Injector.inject(CharacterRepository, self)
@onready var _save_db: SaveDb = Injector.inject(SaveDb, self)
@onready var _resource_db: ResourceDb = Injector.inject(ResourceDb, self)
var _character_properties_repository: CharacterPropertyRepository


func _enter_tree() -> void:
	_state = Injector.provide(CharacterState, CharacterState.new(self), self, Injector.ContainerType.CLOSEST)
	_character_properties_repository = Injector.provide(CharacterPropertyRepository, CharacterPropertyRepository.new(), self, Injector.ContainerType.CLOSEST)

func _ready() -> void:
	_screen_mouse_events.left_button_changed.connect(_on_screen_left_button)
	_game_time.finished_step.connect(_update_props_by_time_spend)
	_game_time.started_skip.connect(_state.reset_target, CONNECT_DEFERRED)

	_character_properties_repository.init(_save_db)
	
	
	Callable(func():
		position = _character_repositoty.get_world_position()
		_state._target_postion = _character_repositoty.get_world_position()
		var props = _character_properties_repository.get_all()
		var dict = Dictionary()
		for prop in props:
			dict[prop.data_name] = prop
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
	var distance = position.distance_to(_state.target_position)

	if distance > move_step:
		update_position(position.move_toward(_state.target_position, move_step))
		_game_time.do_step(time_unit)
		
	else:
		update_position(_state.target_position)
		time_unit = max(time_unit * (distance / move_step), 1)
		_game_time.do_step(time_unit)
		
	_moving_line.points[1] = _state.target_position - position
	_moving_line.show()
	_update_props_by_time_spend(time_unit)


func _process_idle():
	_moving_line.hide()


func _update_props_by_time_spend(_delta: int):
	var props = _state._properties.values()
	for prop in props:
		var prop_value_delta = prop.delta
		if prop_value_delta != 0:
			prop.value += prop_value_delta * _delta
			_state.set_property(prop)


func update_position(pos: Vector2):
	position = pos
	_state.position_changed.emit(pos)
	_save_position_debounce.emit()


var _save_position_debounce = Debounce.new(_save_position, 0.2)
func _save_position():
	_character_repositoty.set_world_position(position)


func _on_visible_on_screen_notifier_2d_screen_exited():
	_state.player_exited_from_screen.emit()


func _on_visible_on_screen_notifier_2d_screen_entered():
	_state.player_enter_on_screen.emit()


var _save_properties_debounce = Debounce.new(_save_properties, 0.2)
func _save_properties():
	_character_properties_repository.update_batch(_state._properties.values())
