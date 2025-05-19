class_name GameEditor__EditorScreen
extends Node2D

@export var data_base_path: String

@onready var _biomes_tool: Control = %BiomesTool
@onready var _structures_tool: Control = %StructuresTool
@onready var _hovered_tile_pos: Label = %HoveredTilePos
@onready var _map_hover_catcher: Control = %MapHoveredCatcher

@onready var _main_camera = Locator.get_service(MainCameraState)

var _state: GameEditor__EditorScreenState

func _enter_tree() -> void:
	var db: GameDb = Locator.initialize_service(GameDb)
	var save_db: SaveDb = Locator.initialize_service(SaveDb) 
	Locator.initialize_service(BiomeRepository)
	Locator.initialize_service(BiomeRectRepository)
	Locator.initialize_service(WorldObjectRepository)
	_state = Locator.initialize_service(GameEditor__EditorScreenState, [self])

	db.db_connect(data_base_path)
	save_db.db_connect(":memory:") # Нужно для WorldObjectRepository но по факт не используется


func _ready() -> void:
	_state.hovered_biome_tile_pos_changed.connect(_on_hovered_biome_tile_pos_changed)
	_state.current_tool_changed.connect(_on_current_tool_changed)
	_on_current_tool_changed(GameEditor__EditorScreenState.ToolType.Biome)

func _process(delta: float) -> void:
	if _state.hovered_biome_tile_pos != _state.UNHOVERED_BIOME_TILE_POS:
		_state.change_hovered_biome_tile_pos(_map_hover_catcher.get_global_mouse_position() / _main_camera.zoom + _main_camera.global_position - _main_camera.viewport_rect.size / 2)

func _on_choose_tool_editor_tab_changed(tab: int) -> void:
	_state.current_tool = tab

func _on_current_tool_changed(value: GameEditor__EditorScreenState.ToolType):
	match value:
		GameEditor__EditorScreenState.ToolType.Biome:
			_biomes_tool.show()
			_structures_tool.hide()
		GameEditor__EditorScreenState.ToolType.Structure:
			_biomes_tool.hide()
			_structures_tool.show()

func _on_hovered_biome_tile_pos_changed(pos: Vector2i):
	if pos == _state.UNHOVERED_BIOME_TILE_POS:
		_hovered_tile_pos.text = "unhovered"
	else:
		_hovered_tile_pos.text = "hovered tile - x: %d y: %d" % [pos.x, pos.y]


func _on_map_hovered_catcher_mouse_entered() -> void:
	_state.change_hovered_biome_tile_pos(_map_hover_catcher.get_global_mouse_position() / _main_camera.zoom + _main_camera.global_position - _main_camera.viewport_rect.size / 2)

func _on_map_hovered_catcher_mouse_exited() -> void:
	_state.unhover_biome_tile_pos()
