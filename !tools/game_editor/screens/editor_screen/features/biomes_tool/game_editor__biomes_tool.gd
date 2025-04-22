class_name GameEditor__BiomesTool
extends Control

@onready var _hovered_tile_pos: Label = %HoveredTilePos
@onready var _map_hovered_catcher: Control = %MapHoveredCatcher
@onready var _paint_rect_button: Button = %PaintRectButton
@onready var _main_camera: MainCameraState = Locator.get_service(MainCameraState)

var _state: GameEditor__BiomesToolState


func _enter_tree() -> void:
	_state = Locator.initialize_service(GameEditor__BiomesToolState)


func _ready() -> void:
	_state.init(self)
	_state.hovered_biome_tile_pos_changed.connect(_on_hovered_biome_tile_pos_changed)
	_state.selected_biome_id_changed.connect(_on_selected_biome_id_changed)
	
	Callable(func():
		_state.reload_all_biomes()
	).call_deferred()
	
func _process(delta: float) -> void:
	if _state.hovered_biome_tile_pos != _state.UNHOVERED_BIOME_TILE_POS:
		_state.change_hovered_biome_tile_pos(get_global_mouse_position() / _main_camera.zoom + _main_camera.global_position - _main_camera.viewport_rect.size / 2)

func _on_selected_biome_id_changed(id: int):
	if id == GameEditor__BiomesToolState.UNSELECTED_BIOME_ID:
		_paint_rect_button.disabled = true
	else:
		_paint_rect_button.disabled = false

func _on_hovered_biome_tile_pos_changed(pos: Vector2i):
	if pos == _state.UNHOVERED_BIOME_TILE_POS:
		_hovered_tile_pos.text = "unhovered"
	else:
		_hovered_tile_pos.text = "hovered tile - x: %d y: %d" % [pos.x, pos.y]

func _on_map_hovered_catcher_mouse_entered() -> void:
	_state.change_hovered_biome_tile_pos(get_global_mouse_position() / _main_camera.zoom + _main_camera.global_position - _main_camera.viewport_rect.size / 2)

func _on_map_hovered_catcher_mouse_exited() -> void:
	_state.unhover_biome_tile_pos()

func _on_paint_rect_toggled(toggled_on: bool) -> void:
	if toggled_on and _state.selected_biome_id != _state.UNSELECTED_BIOME_ID:
		var paint_state = _state.CreateBiomeRectPaintState.new()
		paint_state.state = paint_state.State.PlaceRectPosition
		_state.paint_state = paint_state
	else:
		_state.paint_state = null
