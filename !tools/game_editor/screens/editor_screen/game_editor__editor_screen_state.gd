class_name GameEditor__EditorScreenState
extends Injectable

var _host_node: Node

func _init(node: Node):
	_host_node = node
	
	
enum ToolType {
	Biome = 0,
	Structure = 1
}

signal current_tool_changed(value: ToolType)
var current_tool: ToolType:
	set(value):
		current_tool = value
		current_tool_changed.emit(value)

#
# Hovered Tile
#

const UNHOVERED_BIOME_TILE_POS = Vector2i.MIN # use not attainable value as a flag
signal hovered_biome_tile_pos_changed(value: Vector2i)
var _hovered_biome_tile_pos: Vector2i
var hovered_biome_tile_pos: Vector2i:
	get: return _hovered_biome_tile_pos
	set(value):
		if (_hovered_biome_tile_pos != value):
			_hovered_biome_tile_pos = value
			hovered_biome_tile_pos_changed.emit(value)

func change_hovered_biome_tile_pos(global_mouse_pos: Vector2):
	var _biome_layers_state = Injector.inject(BiomesLayerState, _host_node)
	hovered_biome_tile_pos = _biome_layers_state.global_to_map(global_mouse_pos)
	
func unhover_biome_tile_pos():
	hovered_biome_tile_pos = UNHOVERED_BIOME_TILE_POS
