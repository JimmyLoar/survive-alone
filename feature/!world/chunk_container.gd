extends Node2D

var _logger := GodotLogger.with("Chunk Container")
var _loaded := Dictionary()

var database: Database = load("res://content/database.gddb")
#count chanks in world
var world_size: Vector2i = ProjectSettings.get_setting("application/game/size/world", Vector2i.ONE * 16)

#count tiles in chunk 
var chunk_size: int = ProjectSettings.get_setting("application/game/size/chunk", 16) 

#count pixels in tile
var tile_size: int = ProjectSettings.get_setting("application/game/size/tile", 16)  

const ChunkHeighbor = [
	Vector2i(-1, -1), Vector2i.UP, Vector2i(1, -1),
	Vector2i.LEFT, Vector2i.ZERO, Vector2i.RIGHT,
	Vector2i(-1, 1), Vector2i.DOWN, Vector2i(1, 1),
]


func update_region(center_position: Vector2i):
	var list = ChunkHeighbor.duplicate().map(
		func (element: Vector2i): return element + center_position)
	_logger.info("Start update chunks: [color=purple]\n	%s\n	%s\n	%s" % [list.slice(0, 3), list.slice(3, 6), list.slice(6, 9)])
	
	var new_loading := _get_new_loading_list(center_position)
	_remove_old_loaded_chunk(new_loading)
	_loaded = new_loading
	_logger.call_deferred("info", "DONE update chunks!")


func _get_new_loading_list(center: Vector2i) -> Dictionary:
	var new_loading := Dictionary()
	for dir in ChunkHeighbor:
		var chunk_position = center + dir
		if _loaded.has(chunk_position): 
			new_loading[chunk_position] = _loaded[chunk_position]
			continue
		
		new_loading[chunk_position] = _add_chunk(chunk_position)
	return new_loading


func _add_chunk(chunk_position: Vector2i):
	var chunk: ChunkNode = _get_chunk(chunk_position)
	add_child(chunk)
	return chunk


func _remove_old_loaded_chunk(new_loading: Dictionary):
	for key in _loaded.keys():
		if new_loading.has(key): continue
		var chunk: Node2D = _loaded[key]
		remove_child(chunk)


func _create_chunk(chunk_pos := Vector2i.ZERO):
	var chunk := Node2D.new()
	var bg_texture:= Sprite2D.new()
	
	bg_texture.centered = false
	bg_texture.scale = Vector2.ONE * 10
	
	chunk.add_child(bg_texture)
	return chunk


func _remove_chunk(chunk_position: Vector2i):
	if not _loaded.has(chunk_position): 
		return
	
	_loaded.erase(chunk_position)


func get_loaded_chunk(_position_in_world: Vector2i):
	if _loaded.has(_position_in_world):
		return _loaded[_position_in_world]
	
	_logger.warn("Cannot getting chunk [color=purple]%s[/color], not be loaded! Use [color=green]get_chunk[/color]!." % _position_in_world)
	return _get_chunk(_position_in_world)


const CHUNK_NODE_PACKED: PackedScene = preload("res://feature/!world/chunk_node.tscn")
func _get_chunk(chunk_pos: Vector2i) -> ChunkNode:
	var chunk: ChunkNode = CHUNK_NODE_PACKED.instantiate()
	chunk.data = get_chunk_data(chunk_pos)
	chunk.position = chunk_pos * chunk_size * tile_size
	chunk.name = "chunk %s" % chunk_pos
	return chunk


func get_chunk_data(pos: Vector2i) -> ChunkData:
	return database.fetch_data_string("chunk/%02d%02d" % [pos.x, pos.y])
