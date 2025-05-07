extends Control

@onready var _state: GameEditor__StructuresToolState = Locator.get_service(GameEditor__StructuresToolState)
@onready var _biome_layer_state: BiomesLayerState = Locator.get_service(BiomesLayerState)
@onready var _main_camera_sate: MainCameraState = Locator.get_service(MainCameraState, _on_ready_main_camera)
@onready var _screen_mouse_events_state: ScreenMouseEventsState = Locator.get_service(ScreenMouseEventsState)
@onready var tile_size: int = ProjectSettings.get_setting("application/game/size/tile", 16)
@onready var _screen_state: GameEditor__EditorScreenState = Locator.get_service(GameEditor__EditorScreenState)

func _ready() -> void:
	_state.mode_changed.connect(func(value): queue_redraw())
	_screen_state.hovered_biome_tile_pos_changed.connect(func(value): queue_redraw())
	
	_screen_mouse_events_state.left_button_changed.connect(_on_left_mouse_button_click)
	_screen_mouse_events_state.right_button_changed.connect(_on_right_mouse_button_click)


func _on_ready_main_camera(camera: MainCameraState):
	assert(camera is MainCameraState, "not init main camera")
	_main_camera_sate = camera
	_main_camera_sate.viewport_rect_changed.connect(func(value): queue_redraw())


func _on_right_mouse_button_click(value: Variant):
	if _screen_state.current_tool != _screen_state.ToolType.Structure:
		return
	_state.mode = null

func _on_left_mouse_button_click(value: Variant):
	if _screen_state.current_tool != _screen_state.ToolType.Structure:
		return
	if value is ScreenMouseEventsState.Click:
		var mode = _state.mode
		if is_instance_of(mode, GameEditor__StructuresToolState.PlaceObjectMode):
			_place_object()

func _place_object():
	_state.place_object()
	_state.mode = null

func _draw() -> void:
	_set_draw_transform()
	var mode = _state.mode
	
	if mode == null:
		return
	
	if is_instance_of(mode, GameEditor__StructuresToolState.PlaceObjectMode):
		_draw_place_rect()
	if is_instance_of(mode, GameEditor__StructuresToolState.EditObjectMode):
		_draw_select_rect(mode.object)

func _set_draw_transform():
	var camera_pos = _main_camera_sate.viewport_rect.position
	var scale = _main_camera_sate.zoom
	draw_set_transform(camera_pos * -scale, 0, scale)

func _draw_place_rect():
	var tile_pos = _screen_state.hovered_biome_tile_pos
	var global_pos = _biome_layer_state.map_to_global(tile_pos)
	var global_end = _biome_layer_state.map_to_global(tile_pos + Vector2i.ONE)
	var rect: Rect2 = Rect2i(global_pos, (global_end - global_pos))
	var tight_rect = Rect2(rect.position.x + 2, rect.position.y + 2, rect.size.x - 4, rect.size.y - 4)
	draw_rect(tight_rect, Color.BLUE, false, 2)
func _draw_select_rect(object: WorldObjectEntity):
	var rect: Rect2 = object.get_collision_shape_in_global_coords().get_rect()
	draw_rect(rect, Color(0.1396, 0.1396, 0.293, 1.0), false, 2)
