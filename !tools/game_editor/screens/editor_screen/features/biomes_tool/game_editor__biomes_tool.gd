class_name GameEditor__BiomesTool
extends Control

@onready var _paint_rect_button: Button = %PaintRectButton
@onready var _remove_rect_button: Button = %RemoveRect
@onready var _main_camera: MainCameraState = Locator.get_service(MainCameraState)
@onready var _biome_repository:BiomeRepository = Locator.get_service(BiomeRepository)
@onready var _biome_rect_repository: BiomeRectRepository = Locator.get_service(BiomeRectRepository)
@onready var _biomes_state: BiomesLayerState = Locator.get_service(BiomesLayerState)
@onready var _screen_mouse_events_state: ScreenMouseEventsState = Locator.get_service(ScreenMouseEventsState)
@onready var _screen_state: GameEditor__EditorScreenState = Locator.get_service(GameEditor__EditorScreenState)

var _state: GameEditor__BiomesToolState


func _enter_tree() -> void:
	_state = Locator.initialize_service(GameEditor__BiomesToolState)


func _ready() -> void:
	_state.init(self)
	_state.selected_biome_id_changed.connect(_on_selected_biome_id_changed)

	_screen_mouse_events_state.left_button_changed.connect(_on_left_button_click)

	_state.paint_state_changed.connect(_on_paint_state_changed)
	
	Callable(func():
		_state.reload_all_biomes()
	).call_deferred()

func _on_selected_biome_id_changed(id: int):
	if id == GameEditor__BiomesToolState.UNSELECTED_BIOME_ID:
		_paint_rect_button.disabled = true
	else:
		_paint_rect_button.disabled = false

func _on_paint_rect_toggled(toggled_on: bool) -> void:
	if toggled_on and _state.selected_biome_id != _state.UNSELECTED_BIOME_ID:
		var paint_state = _state.CreateBiomeRectPaintState.new()
		paint_state.state = paint_state.State.PlaceRectPosition
		_state.paint_state = paint_state
	else:
		_state.paint_state = null

func _on_left_button_click(value: Variant):
	if _screen_state.current_tool != _screen_state.ToolType.Biome:
		return
	if not (value is ScreenMouseEventsState.Click):
		return
	if _screen_state.hovered_biome_tile_pos == _screen_state.UNHOVERED_BIOME_TILE_POS:
		return
	if _state.paint_state == null or is_instance_of(_state.paint_state, GameEditor__BiomesToolState.EditBiomeRectPaintState):
		var biome_rects = _biome_rect_repository.get_all_by_tile_pos(_screen_state.hovered_biome_tile_pos)

		if biome_rects.size() == 0:
			_state.paint_state = null
			return

		var edit_state = GameEditor__BiomesToolState.EditBiomeRectPaintState.new()
		if _state.paint_state == null:
			edit_state.biome_rect = biome_rects[0]
		else:
			var index = Utils.find_index(biome_rects, func(x: BiomeRectEntity): return x.id == _state.paint_state.biome_rect.id)

			if index >= 0:
				var next_index = index + 1
				if next_index >= biome_rects.size():
					edit_state.biome_rect = biome_rects[0]
				else:
					edit_state.biome_rect = biome_rects[next_index]
			else:
				edit_state.biome_rect = biome_rects[0]

		_state.paint_state = edit_state
		_state.selected_biome_id = edit_state.biome_rect.biome_id


func _on_remove_rect_pressed() -> void:
	if is_instance_of(_state.paint_state, GameEditor__BiomesToolState.EditBiomeRectPaintState):
		_biome_rect_repository.delete(_state.paint_state.biome_rect.id)
		_biomes_state.delete_biome_rect(_state.paint_state.biome_rect.id)

func _on_paint_state_changed(value: Variant):
	if not is_instance_of(value, GameEditor__BiomesToolState.EditBiomeRectPaintState):
		_remove_rect_button.disabled = true
	else:
		_remove_rect_button.disabled = false
	if not is_instance_of(value, GameEditor__BiomesToolState.CreateBiomeRectPaintState):
		_paint_rect_button.button_pressed = false
