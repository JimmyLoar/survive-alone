extends Node2D

#count chanks in world
var world_size: Vector2i = ProjectSettings.get_setting("application/game/size/world", Vector2i.ONE * 16)

#count tiles in chunk 
var chunk_size: int = ProjectSettings.get_setting("application/game/size/chunk", 16) 

#count pixels in tile
var tile_size: int = ProjectSettings.get_setting("application/game/size/tile", 16)  


var chunks := {
	Vector2(0, 0) : ChunkData.new(),
	Vector2(1, 1) : ChunkData.new(),
	Vector2(2, 0) : ChunkData.new(),
	Vector2(2, 2) : ChunkData.new(),
}

var chunck_objects_groups := {}

@onready var objects: Node2D = $ChunkContainer

func _ready() -> void:
	for chunk_pos in chunks.keys():
		update_chunck(chunk_pos)


func update_chunck(chunk_position: Vector2):
	var canvas: CanvasGroup
	if chunck_objects_groups.has(chunk_position):
		canvas = chunck_objects_groups[chunk_position]
	
	else:
		canvas = CanvasGroup.new()
		objects.add_child(canvas)
		canvas.name = "Chunk %s" % chunk_position
		chunck_objects_groups[chunk_position] = canvas
	
	var chunk := chunks[chunk_position] as ChunkData
	
	for object_key in chunk.objects:
		create_object_in_world(object_key, chunk_position)


func create_object_in_world(object_pos: Vector2, chunk_pos: Vector2, object_type := 0):
	var new_object : WorldObject = preload("res://scenes/world/world_object.tscn").instantiate()
	var canvas = chunck_objects_groups[chunk_pos]
	canvas.add_child(new_object)
	new_object.position = object_pos + chunk_pos * chunk_size * tile_size
	
