class_name Character
extends Node2D

var _state: CharacterState

@export var time_unit = 1 # times per one _physics_process
@export var move_speed = 50 # pixels per time_unit
@export var biome_check_gap = 20
@onready var _screen_mouse_events: ScreenMouseEventsState = Locator.get_service(ScreenMouseEventsState)
@onready var _game_time: GameTimeState = Locator.get_service(GameTimeState)
@onready var _character_repositoty: CharacterRepository = Locator.get_service(CharacterRepository)
@onready var _save_db: SaveDb = Locator.get_service(SaveDb)
@warning_ignore('unused_private_class_variable')
@onready var _camera_state: MainCameraState = Locator.get_service(MainCameraState)
var _character_properties_repository: CharacterPropertyRepository
@onready var _biomes_layer_state: BiomesLayerState = Locator.get_service(BiomesLayerState)



func _enter_tree() -> void:
	_state = Locator.initialize_service(CharacterState, [self])
	_character_properties_repository = Locator.initialize_service(CharacterPropertyRepository)

func _ready() -> void:
	
	_screen_mouse_events.left_button_changed.connect(_on_screen_left_button)
	_game_time.finished_step.connect(_update_props_by_time_spend)
	_game_time.started_skip.connect(_state.reset_target, CONNECT_DEFERRED)

	_character_properties_repository.init(_save_db)
	
	_camera_state.mode = _camera_state.TargetMode.new(self)
	
	Callable(func():
		position = _character_repositoty.get_world_position()
		_state._target_postion = _character_repositoty.get_world_position()
		var props = _character_properties_repository.get_all()
		var dict = Dictionary()
		for prop in props:
			dict[prop.data_name] = prop
		_state._properties = dict

		_state.position_changed.emit(position)
	).call_deferred()


var passability = {'water': 0}

func _on_screen_left_button(value):
	if value is ScreenMouseEventsState.Click:
		
		for biome in _biomes_layer_state.get_visible_tile_biomes_fast(_biomes_layer_state.global_to_map(get_global_mouse_position())):
			if biome.name in passability.keys():
				if passability.get(biome.name) == 0:
					return
				
		_state.target_position = get_global_mouse_position()
		%CharacterStateMachina.change_state(%Move)


func _update_props_by_time_spend(_delta: int):
	var props = _state._properties.values()
	for prop in props:
		var prop_value_delta = prop.delta
		if prop_value_delta != 0:
			prop.value += prop_value_delta * _delta
			_state.set_property(prop)

@warning_ignore('unused_private_class_variable')
var _save_position_debounce = Debounce.new(_save_position, 0.2)
func _save_position():
	_character_repositoty.set_world_position(position)


func _on_visible_on_screen_notifier_2d_screen_exited():
	_state.player_exited_from_screen.emit()


func _on_visible_on_screen_notifier_2d_screen_entered():
	_state.player_enter_on_screen.emit()

@warning_ignore('unused_private_class_variable')
var _save_properties_debounce = Debounce.new(_save_properties, 0.2)
func _save_properties():
	_character_properties_repository.update_batch(_state._properties.values())
