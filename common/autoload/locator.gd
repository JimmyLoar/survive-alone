extends Node


func _init() -> void:
	initialize_service(GameDb)
	initialize_service(SaveDb)
	initialize_service(GameState)
	initialize_service(ResourceDb)
	initialize_service(ExecuteKeeperState)
	_game_db = GameDb.new()
	_save_db = SaveDb.new()
	_game_state = GameState.new()
	_resource_db = ResourceDb.new()
	_execute_keeper = ExecuteKeeperState.new()


var _storage: Dictionary = {}


func initialize_service(script: GDScript, values: Array = []):
	var _name = script.get_global_name()
	var property = script.new.callv(values)
	Log.get_global_logger().debug("finished initialize service '[color=red]%s[/color]'.
		[color=yellow]Initialize values[/color]: " % [_name], values)
	_storage[_name] = property
	
	var signal_name = "ready_%s" % script.get_global_name()
	if has_user_signal(signal_name):
		emit_signal(signal_name)
	return property


func get_service(script: Script, emit_callable: Callable = func(o): pass) -> Object:
	if _storage.has(script.get_global_name()):
		return _storage[script.get_global_name()]
	
	Log.get_global_logger().debug("Failed to get service an '[color=red]%s[/color]' because it wasn't initialized!\n" % 
		[script.get_global_name()], get_stack())
	
	if not emit_callable:
		return null
	
	var signal_name = "ready_%s" % script.get_global_name()
	if not has_user_signal(signal_name):
		add_user_signal(signal_name, [{"name": "service", "type": TYPE_OBJECT}])
		connect(signal_name, remove_user_signal, CONNECT_ONE_SHOT)
	
	connect(signal_name, emit_callable, CONNECT_ONE_SHOT)
	Log.get_global_logger().debug("A signal will be emitted connected to '[color=lightblue]%s[/color]' when server '[color=red]%s[/color] is initialized.' \n" % 
		[script.get_global_name()])
	return null



func _init_state(property: Variant, state: GDScript, _signal: Signal, values: Array = []) -> Object:
	if not property:
		property = state.new.callv(values)
		_signal.emit(property)
		Log.get_global_logger().debug("init state '[color=red]%s[/color] %s'\n" % [state.get_global_name(), property], values)
	return property 


#region GameDB
var _game_db: GameDb


func get_game_db() -> GameDb:
	return _game_db


#endregion
#region SaveDB
var _save_db: SaveDb


func get_save_db() -> SaveDb:
	return _save_db


#endregion
#region GameState
var _game_state: GameState


func get_game_state() -> GameState:
	return _game_state


#endregion
#region ResourceDb
var _resource_db: ResourceDb


func get_resource_db() -> ResourceDb:
	return _resource_db


#endregion
#region ExecuteKeeper
var _execute_keeper: ExecuteKeeperState


func get_execute_keeper() -> ExecuteKeeperState:
	return _execute_keeper


#endregion


#region Character
signal ready_character(state: CharacterState)
var _character: CharacterState


func init_character(_node) -> CharacterState:
	_character = _init_state(_character, CharacterState, ready_character, [_node])
	return _character


func get_character() -> CharacterState:
	return _character


#endregion
#region GameTime
signal ready_game_time(state: GameTimeState)
var _game_time: GameTimeState


func init_game_time(_node) -> GameTimeState:
	_game_time = _init_state(_game_time, GameTimeState, ready_game_time, [_node])
	return _game_time


func get_game_time() -> GameTimeState:
	return _game_time


#endregion
#region WorldScreenState
signal ready_world_screen(state: WorldScreenState)
var _world_screen: WorldScreenState


func init_world_screen(_node) -> WorldScreenState:
	_world_screen = _init_state(_world_screen, WorldScreenState, ready_world_screen, [_node])
	return _world_screen


func get_world_screen() -> WorldScreenState:
	return _world_screen


#endregion
#region ActionState
signal ready_action_state(state: ActionState)
var _action_state: ActionState


func init_action_state(_node) -> ActionState:
	_action_state = _init_state(_action_state, ActionState, ready_action_state, [_node])
	return _action_state


func get_action_state() -> ActionState:
	return _action_state


#endregion
#region MainCamera
signal ready_main_camera(state: MainCameraState)
var _main_camera: MainCameraState


func init_main_camera(_node) -> MainCameraState:
	_main_camera = _init_state(_main_camera, MainCameraState, ready_main_camera, [_node])
	return _main_camera


func get_main_camera() -> MainCameraState:
	return _main_camera


#endregion
#region InventoryCharacter
signal ready_inventory_character(state: InventoryCharacterState)
var _inventory_char: InventoryCharacterState


func init_inventory_character(_node) -> InventoryCharacterState:
	_inventory_char = _init_state(_inventory_char, InventoryCharacterState, ready_inventory_character, [_node])
	return _inventory_char


func get_inventory_character() -> InventoryCharacterState:
	return _inventory_char


#endregion
#region InventoryLocation
signal ready_inventory_location(state: InventoryLocationState)
var _inventory_local: InventoryLocationState


func init_inventory_location(_node) -> InventoryLocationState:
	_inventory_local = _init_state(_inventory_local, InventoryLocationState, ready_inventory_location, [_node])
	return _inventory_local


func get_inventory_location() -> InventoryLocationState:
	return _inventory_local


#endregion
#region EventState
signal ready_event_state(state: EventState)
var _event_state: EventState


func init_event_state(_node) -> EventState:
	_event_state = _init_state(_event_state, EventState, ready_event_state, [_node])
	return _event_state


func get_event_state() -> EventState:
	return _event_state


#endregion
