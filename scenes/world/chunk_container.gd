extends Node2D

var _logger := GodotLogger.with("Chunk Container")
var _content := Dictionary()


#count chanks in world
var world_size: Vector2i = ProjectSettings.get_setting("application/game/size/world", Vector2i.ONE * 16)

#count tiles in chunk 
var chunk_size: int = ProjectSettings.get_setting("application/game/size/chunk", 16) 

#count pixels in tile
var tile_size: int = ProjectSettings.get_setting("application/game/size/tile", 16)  


func _ready() -> void:
	load_region(Vector2.ONE * 2, 3)


func load_region(center_position: Vector2i, radius := 3):
	_logger.info("Start update chunks...")
	#if not _validate_region(radius): 
		#_logger.error("Error update chunks!")
		#return
	
	var size_side: int = radius * 2 - 1
	for x in pow(size_side, 2):
		var _offset = Vector2i(
				fmod(x, size_side) - ceili(size_side / 2), 
				floori(x / size_side) - ceili(size_side / 2)
			)
		_add_chunks(center_position + _offset)
	
	_logger.info("DONE update chunks!")
	

func _validate_region(radius: int) -> bool:
	if fmod(radius, 2) != 0:
		_logger.debug("Need used not even number!")
		return false
	return true


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
