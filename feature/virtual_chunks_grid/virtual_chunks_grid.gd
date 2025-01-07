@tool
extends Node2D

@export var _draw_chunks := false
@export var color := Color.RED
#count chanks in world
var world_size: Vector2i = ProjectSettings.get_setting("application/game/size/world", Vector2i.ONE * 16)

#count tiles in chunk 
var chunk_size: int = ProjectSettings.get_setting("application/game/size/chunk", 16) 

#count pixels in tile
var tile_size: int = ProjectSettings.get_setting("application/game/size/tile", 16)  


@onready var _pixel_chunk_size: int = tile_size * chunk_size 
@onready var _pixel_world_size: Vector2i = _pixel_chunk_size * world_size

# TODO Draw only visible chuks not all world
func _draw() -> void:
	if not _draw_chunks: return
	
	for x in world_size.x:
		draw_line(
			Vector2(x * _pixel_chunk_size, 0), 
			Vector2(x * _pixel_chunk_size, _pixel_world_size.y), 
			color, 4
		)
	
	for y in world_size.y:
		draw_line(
			Vector2(0, y * _pixel_chunk_size), 
			Vector2(_pixel_world_size.x, y * _pixel_chunk_size), 
			color, 4
		)
	
	for x in world_size.x:
		for y in world_size.y:
			draw_string(
				ThemeDB.fallback_font, 
				Vector2(x, y) * _pixel_chunk_size - Vector2(-16, -32),
				"X:%s  Y:%s" % [x, y], HORIZONTAL_ALIGNMENT_CENTER,
				-1, 24, color
			)
