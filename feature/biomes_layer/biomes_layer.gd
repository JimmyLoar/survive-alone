class_name BiomesLayer
extends Node2D

var tile_size: int = ProjectSettings.get_setting("application/game/size/tile", 16) 
@onready var _forest_layer: TileMapLayer = $"ForestLayer"
@onready var _grass_layer: TileMapLayer = $"GrassLayer"
@onready var _water_layer: TileMapLayer = $"WaterLayer"
@onready var _ground_layer: TileMapLayer = $"GroundLayer"
@onready var _virtual_chunks_state: VirtualChunksState = Locator.get_service(VirtualChunksState)

var _state: BiomesLayerState


func _enter_tree() -> void:
	_state = Locator.initialize_service(BiomesLayerState, [self])


func _ready() -> void:
	_virtual_chunks_state.visible_chunks_rect_changed.connect(Callable(self, "_on_visible_chunks_rect_changed"))
	_state.visible_tiles_rect_changed.connect(Callable(self, "_on_visible_tiles_rect_changed"))
	
func _on_visible_chunks_rect_changed(chunks_rect: Rect2i):
	var tiles_rect = Rect2i(chunks_rect.position * tile_size, chunks_rect.size * tile_size)
	_state.set_visible_tiles_rect(tiles_rect)

func _on_visible_tiles_rect_changed(diff: VisibleTilesDiff, _visible_rect: Rect2i):
	for rect in diff.removed:
		_clear_rect(rect)
	for rect in diff.added:
		_rerender_rect(rect)
	for rect in diff.updated:
		_rerender_rect(rect)

func _clear_rect(rect: Rect2i):
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			_clear_tile(Vector2i(x, y))

func _clear_tile(pos: Vector2i):
	_forest_layer.erase_cell(pos)
	_grass_layer.erase_cell(pos)
	_water_layer.erase_cell(pos)
	_ground_layer.erase_cell(pos)

func _rerender_rect(rect: Rect2i):
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			_rerender_tile(Vector2i(x, y))

func _rerender_tile(pos: Vector2i):
	_clear_tile(pos)
	var tile_biomes = _state.get_visible_tile_biomes_fast(pos)
	
	for biome: BiomeEntity in tile_biomes:
		match biome.resource.view_type:
			BiomeResource.BiomeViewType.Water:
							_water_layer.set_cell(pos, 0, Vector2i(0, 0))
			BiomeResource.BiomeViewType.Ground:
							_ground_layer.set_cell(pos, 0, Vector2i(1, 0))
			BiomeResource.BiomeViewType.Forest:
							_forest_layer.set_cell(pos, 0, Vector2i(2, 0))
			BiomeResource.BiomeViewType.Grass:
							_grass_layer.set_cell(pos, 0, Vector2i(3, 0))
