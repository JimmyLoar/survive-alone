class_name ChunkFilesGenerater
extends RefCounted

const PATH = "res://content/world/chunks/"

var world_size: Vector2i = ProjectSettings.get_setting("application/game/size/world", Vector2i.ONE * 16)

func generate():
	for x in world_size.x:
		for y in world_size.y:
			create_file(Vector2i(x, y))


func check_file(chunk_pos: Vector2i):
	pass


func create_file(chunk_pos: Vector2i):
	var chunk = ChunkData.new()
	chunk.position = chunk_pos
	chunk.structure_image = load("res://assets/sprite/map_chunks/chunk_%d.jpg" % [chunk_pos.x + chunk_pos.y * world_size.x + 1])
	ResourceSaver.save(chunk, get_chunk_path(chunk_pos))


func get_chunk_path(pos: Vector2i):
	return PATH + "/" + "%02d%02d.tres" % [pos.x, pos.y]
