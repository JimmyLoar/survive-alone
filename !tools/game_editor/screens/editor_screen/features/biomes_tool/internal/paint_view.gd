extends Control

@onready var _game_editor__biomes_tool_state: GameEditor__BiomesToolState = Locator.get_service(GameEditor__BiomesToolState, self)
@onready var _biome_layer_state: BiomesLayerState = Locator.get_service(BiomesLayerState, self)
@onready var _screen_mouse_events_state: ScreenMouseEventsState = Locator.get_service(ScreenMouseEventsState, self)
@onready var tile_size: int = ProjectSettings.get_setting("application/game/size/tile", 16)

var _main_camera_state: MainCameraState


func _enter_tree() -> void:
	if Locator.get_main_camera():
		_on_ready_main_camera(Locator.get_main_camera())
		return 
	
	Locator.ready_main_camera.connect(_on_ready_main_camera, CONNECT_ONE_SHOT)


func _ready() -> void:
	_game_editor__biomes_tool_state.paint_state_changed.connect(func(value): queue_redraw())
	_game_editor__biomes_tool_state.hovered_biome_tile_pos_changed.connect(func(value): queue_redraw())
	
	_screen_mouse_events_state.left_button_changed.connect(_on_left_mouse_button_click)
	_screen_mouse_events_state.right_button_changed.connect(_on_right_mouse_button_click)


func _on_ready_main_camera(camera):
	_main_camera_state = camera
	_main_camera_state.viewport_rect_changed.connect(func(value): queue_redraw())


func _on_right_mouse_button_click(value: Variant):
	_game_editor__biomes_tool_state.paint_state = null


func _on_left_mouse_button_click(value: Variant):
	if value is ScreenMouseEventsState.Click:
		var paint_state = _game_editor__biomes_tool_state.paint_state
		if is_instance_of(paint_state, GameEditor__BiomesToolState.CreateBiomeRectPaintState):
			_create_rect_input(paint_state)


func _create_rect_input(paint_state: GameEditor__BiomesToolState.CreateBiomeRectPaintState):
	if paint_state.state == paint_state.State.PlaceRectPosition:
		paint_state.position = _game_editor__biomes_tool_state.hovered_biome_tile_pos
		paint_state.state = paint_state.State.PlaceRectEnd
		_game_editor__biomes_tool_state.paint_state_changed.emit(paint_state)
	elif paint_state.state == paint_state.State.PlaceRectEnd:
		_game_editor__biomes_tool_state._place_biome_rect()


func _draw() -> void:
	_set_draw_transform()
	var paint_state = _game_editor__biomes_tool_state.paint_state
	
	if paint_state == null:
		return
	
	if is_instance_of(paint_state, GameEditor__BiomesToolState.CreateBiomeRectPaintState):
		_draw_create_rect(paint_state)


func _set_draw_transform(): 
	var camera_pos = _main_camera_state.viewport_rect.position
	var scale = _main_camera_state.zoom
	draw_set_transform(camera_pos * -scale, 0, scale)


func _draw_create_rect(paint_state: GameEditor__BiomesToolState.CreateBiomeRectPaintState):
	if paint_state.state == paint_state.State.PlaceRectPosition:
		var tile_pos = _game_editor__biomes_tool_state.hovered_biome_tile_pos
		var global_pos = _biome_layer_state.map_to_global(tile_pos)
		var global_end = _biome_layer_state.map_to_global(tile_pos)
		var rect: Rect2 = Rect2i(global_pos, (global_end - global_pos))
		var tight_rect = Rect2(rect.position.x + 2, rect.position.y + 2, rect.size.x - 4, rect.size.y - 4)
		draw_rect(tight_rect, Color.BLUE, false, 2)
	if paint_state.state == paint_state.State.PlaceRectEnd:
		var position = Vector2i(paint_state.position)
		var end = Vector2i(_game_editor__biomes_tool_state.hovered_biome_tile_pos)
		
		if position.x > end.x:
			var temp = position.x
			position.x = end.x
			end.x = temp
		if position.y > end.y:
			var temp = position.y
			position.y = end.y
			end.y = temp

		var global_pos = _biome_layer_state.map_to_global(position)
		var global_end = _biome_layer_state.map_to_global(end)
		var rect: Rect2 = Rect2i(global_pos, (global_end - global_pos))
		var tight_rect = Rect2(rect.position.x + 2, rect.position.y + 2, rect.size.x - 4, rect.size.y - 4)
		draw_rect(tight_rect, Color.BLUE, false, 2)
