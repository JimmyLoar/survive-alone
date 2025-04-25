extends Control

var _state: GameEditor__StructuresToolState
@onready var _screen_mouse_events_state: ScreenMouseEventsState = Locator.get_service(ScreenMouseEventsState)
@onready var _screen_state: GameEditor__EditorScreenState = Locator.get_service(GameEditor__EditorScreenState)
@onready var _world_object_state: WorldObjectsLayerState = Locator.get_service(WorldObjectsLayerState)
@onready var _camera_state: MainCameraState = Locator.get_service(MainCameraState)
@onready var tile_size: int = ProjectSettings.get_setting("application/game/size/tile", 16)

func _enter_tree() -> void:
	_state = Locator.initialize_service(GameEditor__StructuresToolState, [self])


func _ready() -> void:
	_screen_mouse_events_state.left_button_changed.connect(_on_left_button_click)
	_screen_mouse_events_state.right_button_changed.connect(_on_right_button_click)

func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on and _state.selected_object_uid != _state.UNSELECTED_OBJECT_UID:
		var place_mode = _state.PlaceObjectMode.new()
		place_mode.scene = ResourceLoader.load(ResourceUID.get_id_path(_state.selected_object_uid), "", ResourceLoader.CacheMode.CACHE_MODE_IGNORE_DEEP)
		_state.mode = place_mode
	else:
		_state.mode = null

func _on_left_button_click(value: Variant):
	if _screen_state.current_tool != _screen_state.ToolType.Structure:
		return
	if not (value is ScreenMouseEventsState.Click):
		return
	var pos = get_global_mouse_position() / _camera_state.zoom + _camera_state.viewport_rect.position
	if _screen_state.hovered_biome_tile_pos == _screen_state.UNHOVERED_BIOME_TILE_POS:
		return
	if _state.mode == null or is_instance_of(_state.mode, _state.EditObjectMode):
		var object = _world_object_state.get_object_by_position_fast(pos)
		
		if object:
			var mode = _state.EditObjectMode.new()
			mode.object = object
			_state.mode = mode
	

func _unhandled_input(event):
	if _screen_state.current_tool != _screen_state.ToolType.Structure:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE and event.pressed:
			if is_instance_of(_state.mode, _state.EditObjectMode):
				var prev_tile_pos = Vector2i(round(_state.mode.object.get_offset() / tile_size))
				var new_tile_pos = _screen_state.hovered_biome_tile_pos
				
				if prev_tile_pos != new_tile_pos:
					_state.move_object()

func _on_right_button_click(value: Variant):
	if _screen_state.current_tool != _screen_state.ToolType.Structure:
		return
	if not (value is ScreenMouseEventsState.Click):
		return
	
	if _state.mode != null:
		_state.mode = null


func _on_remove_pressed() -> void:
	if is_instance_of(_state.mode, _state.EditObjectMode):
		_state.remove_object()
		_state.mode = null
