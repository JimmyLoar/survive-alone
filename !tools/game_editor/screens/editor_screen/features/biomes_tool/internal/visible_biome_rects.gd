extends Control

@onready var _biomes_layer_state: BiomesLayerState = Injector.inject(BiomesLayerState, self)
@onready var tile_size: int = ProjectSettings.get_setting("application/game/size/tile", 16)
@onready var _main_camera_sate: MainCameraState = Injector.inject(MainCameraState, self)
@onready var _tool_state: GameEditor__BiomesToolState = Injector.inject(GameEditor__BiomesToolState, self)
@onready var _game_editor__biomes_tool_state: GameEditor__BiomesToolState = Injector.inject(GameEditor__BiomesToolState, self)

func _ready() -> void:
	_biomes_layer_state.visible_biome_rects_chaged.connect(func(rects): queue_redraw())
	_main_camera_sate.viewport_rect_changed.connect(func(value): queue_redraw())
	_game_editor__biomes_tool_state.paint_state_changed.connect(func(value): queue_redraw())

func _draw() -> void:
	_set_draw_transform()
	for visible_rect: BiomeRectEntity in _biomes_layer_state.visible_biome_rects.values():
		var global_pos = _biomes_layer_state.map_to_global(visible_rect.rect.position)
		var global_end = _biomes_layer_state.map_to_global(visible_rect.rect.end)
		var rect: Rect2 = Rect2i(global_pos, (global_end - global_pos))
		var tight_rect = Rect2(rect.position.x + 2, rect.position.y + 2, rect.size.x - 4, rect.size.y - 4)

		if is_instance_of(_tool_state.paint_state, GameEditor__BiomesToolState.EditBiomeRectPaintState) and _tool_state.paint_state.biome_rect.id == visible_rect.id:
			draw_rect(tight_rect, Color.BLUE, false, 2)
		else:
			draw_rect(tight_rect, Color.GRAY, false, 2)

func _set_draw_transform():
	var camera_pos = _main_camera_sate.viewport_rect.position
	var scale =_main_camera_sate.zoom
	draw_set_transform(camera_pos * -scale, 0, scale)
