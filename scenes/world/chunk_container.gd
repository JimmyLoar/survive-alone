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
	
	for dir in ChunkHeighbor.size():
		var chunk_position = center_position + ChunkHeighbor[dir]
	
	_logger.info("DONE update chunks!")


func _add_chunks(chunk_position: Vector2i):
	if _content.has(chunk_position): 
		return
	
	var new_canvas := CanvasGroup.new()
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