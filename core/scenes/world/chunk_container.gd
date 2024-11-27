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
	Vector2i.ZERO,
	Vector2i.RIGHT,
	Vector2i(1, 1),
	Vector2i.DOWN,
	Vector2i(-1, 1),
	Vector2i.LEFT,
	Vector2i(-1, -1),
	Vector2i.UP,
	Vector2i(1, -1),
]


func update_region(center_position: Vector2i):
	_logger.info("Start update chunks, center is %s" % [center_position])
	
	var new_loading := Dictionary()
	for dir in ChunkHeighbor.size():
		var chunk_position = center_position + ChunkHeighbor[dir]
		if _loaded.has(chunk_position): 
			new_loading[chunk_position] = _loaded[chunk_position]
			continue
		
		var chunk: ChunkNode = _get_chunk(chunk_position)
		new_loading[chunk_position] = chunk
		add_child(chunk)
	
	for key in _loaded.keys():
		if new_loading.has(key): continue
		var chunk: Node2D = _loaded[key]
		remove_child(chunk)
	
	_loaded = new_loading
	_logger.info("DONE update chunks!")


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
	
	_logger.warn("Cannot getting chunk '%s', not be loaded! Use 'get_chunk'!." % _position_in_world)
	return _get_chunk(_position_in_world)


func _get_chunk(chunk_pos: Vector2i) -> ChunkNode:
	var chunk: ChunkNode = preload("res://core/scenes/world/chunk_node.tscn").instantiate()
	chunk.data = get_chunk_data(chunk_pos)
	chunk.position = chunk_pos * chunk_size * tile_size
	chunk.name = "chunk %s" % chunk_pos
	return chunk


func get_chunk_data(pos: Vector2i) -> ChunkData:
	return database.fetch_data_string("chunk/%02d%02d" % [pos.x, pos.y])
