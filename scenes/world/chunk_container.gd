extends Node2D

var _logger := GodotLogger.with("Chunk Container")
var _content := Dictionary()


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


#TODO переделать на подгрузку чанков 3*3
func update_region(center_position: Vector2i):
	_logger.info("Start update chunks, center is %s" % [center_position])
	
	var new_content := Dictionary()
	for dir in ChunkHeighbor.size():
		var chunk_position = center_position + ChunkHeighbor[dir]
		if _content.has(chunk_position): 
			new_content[chunk_position] = _content[chunk_position]
			continue
		
		var chunk = _create_chunk(chunk_position)
		new_content[chunk_position] = chunk
		add_child(chunk)
	
	for key in _content.keys():
		if new_content.has(key): continue
		var chunk: Node2D = _content[key]
		remove_child(chunk)
	
	_content = new_content
	_logger.info("DONE update chunks!")


func _create_chunk(chunk_pos := Vector2i.ZERO):
	var chunk := Node2D.new()
	var bg_texture:= Sprite2D.new()
	
	bg_texture.centered = false
	bg_texture.texture = load("res://assets/sprite/map_chunks/chunk_%d.jpg" % [chunk_pos.x + chunk_pos.y * world_size.x + 1])
	bg_texture.scale = Vector2.ONE * 10
	
	chunk.add_child(bg_texture)
	chunk.position = chunk_pos * chunk_size * tile_size
	chunk.name = "chunk %s" % chunk_pos
	return chunk


func _add_chunks(chunk_position: Vector2i):
	if _content.has(chunk_position): 
		return
	
	var new_canvas := Node2D.new()
	add_child(new_canvas)
	_content[chunk_position] = new_canvas
	new_canvas.position = chunk_position * chunk_size * tile_size
	new_canvas.name = "Chunk %s" % chunk_position


func _remove_chunk(chunk_position: Vector2i):
	if not _content.has(chunk_position): 
		return
	
	_content.erase(chunk_position)





func get_loaded_chunk(_position_in_world: Vector2i):
	if _content.has(_position_in_world):
		return _content[_position_in_world]
	
	_logger.warn("Cannot getting chunk '%s', not be loaded! Use 'get_chunk'!." % _position_in_world)
	return get_chunk(_position_in_world)


func get_chunk(_position_in_world: Vector2i):
	return ChunkData.new


func add_object_in_position(object: Node, object_pos: Vector2, chunk_pos: Vector2) -> void:
	pass
