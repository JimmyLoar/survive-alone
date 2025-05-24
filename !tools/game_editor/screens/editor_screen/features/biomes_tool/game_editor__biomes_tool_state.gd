class_name GameEditor__BiomesToolState
extends Object

var _biome_repository: BiomeRepository
var _biome_layers_state: BiomesLayerState
var _screen_state: GameEditor__EditorScreenState

func init(node: Node):
	_biome_repository = Locator.get_service(BiomeRepository)
	_biome_layers_state = Locator.get_service(BiomesLayerState)
	_screen_state = Locator.get_service(GameEditor__EditorScreenState)

#
# Biomes list
#
const UNSELECTED_BIOME_ID = -1

signal selected_biome_id_changed(biome: int)
var _selected_biome_id: int = UNSELECTED_BIOME_ID
var selected_biome_id: int:
	set(value):
		if (_selected_biome_id != value):
			_selected_biome_id = value
			selected_biome_id_changed.emit(_selected_biome_id)
	get:
		return _selected_biome_id

signal biomes_changed(biomes: Array[BiomeEntity])
var _biomes: Array[BiomeEntity]:
	set(value):
		_biomes = value
		if Utils.find_index(_biomes, func(biome): return biome.id == _selected_biome_id) < 0:
			_selected_biome_id = -1
		biomes_changed.emit(value)
var biomes: Array[BiomeEntity]:
	get: return _biomes


func create_biome():
	var biome = BiomeEntity.new()
	
	var id = _biome_repository.create(biome)
	reload_all_biomes()
	selected_biome_id = id

func reload_all_biomes():
	_biomes = _biome_repository.get_all()
	
func remove_selected_biome():
	if selected_biome_id == UNSELECTED_BIOME_ID:
		return
	
	var index = Utils.find_index(_biomes, func(biome): return biome.id == selected_biome_id)
	
	_biome_repository.remove(selected_biome_id)
	reload_all_biomes()
	
	if  biomes.size() > 0:
		index = _biomes.size() - 1 if index >= _biomes.size() - 1 else index
		index = 0 if index < 0 else index
		var selected_biome = _biomes[index]
		selected_biome_id = selected_biome.id
		
func update_selected_biome(biome: BiomeEntity):
	var index = Utils.find_index(_biomes, func(biome): return biome.id == selected_biome_id)
	_biomes[0] = biome

	_biome_repository.insert(biome)
	reload_all_biomes()
#
# Placing biome rects
#

class CreateBiomeRectPaintState:
	enum State {
		PlaceRectPosition,
		PlaceRectEnd
	}
	
	var position: Vector2i
	var state: State 
	
class EditBiomeRectPaintState:
	var biome_rect: BiomeRectEntity

signal paint_state_changed(value: Variant)
var _paint_state: Variant # CreateBiomeRectPaintState || EditBiomeRectPaintState || null; BrushPaintBiomeState and other in the future
var paint_state: Variant:
	get: return _paint_state
	set(value):
		_paint_state = value
		paint_state_changed.emit(value)
		
func _place_biome_rect():
		if selected_biome_id == null:
			return
		var position = paint_state.position
		var end = _screen_state.hovered_biome_tile_pos

		if end == _screen_state.UNHOVERED_BIOME_TILE_POS:
			_paint_state = null
			return
		
		if position.x > end.x:
			var temp = position.x
			position.x = end.x
			end.x = temp
		if position.y > end.y:
			var temp = position.y
			position.y = end.y
			end.y = temp
		
		var biome_rect = BiomeRectEntity.new()
		biome_rect.id = -1
		biome_rect.biome_id = selected_biome_id
		biome_rect.rect = Rect2i(position, end - position)
		_biome_layers_state.create_biome_rect(biome_rect)
		paint_state.state = paint_state.State.PlaceRectPosition
		paint_state_changed.emit(paint_state)
