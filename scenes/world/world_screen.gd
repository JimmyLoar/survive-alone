@tool
extends Node2D

@export var _draw_chunks := false
@export_range(4, 256) var world_size := 16 #count chanks in world
@export_range(4, 256) var chank_size := 16 #count tiles in chank
@export_range(4, 256) var tile_size := 16  #count pixels in tile

@onready var _pixel_chank_size = tile_size * chank_size 
@onready var _pixel_world_size = _pixel_chank_size * world_size

func _draw() -> void:
	if not _draw_chunks: return
	
	for x in world_size:
		draw_line(
			Vector2(x * _pixel_chank_size, 0), 
			Vector2(x * _pixel_chank_size, _pixel_world_size), 
			Color.GREEN, 2
		)
	
	for y in world_size:
		draw_line(
			Vector2(0, y * _pixel_chank_size), 
			Vector2(_pixel_world_size, y * _pixel_chank_size), 
			Color.GREEN, 2
		)
	
	for x in world_size:
		for y in world_size:
			draw_string(
				ThemeDB.fallback_font, 
				Vector2(x, y) * _pixel_chank_size - Vector2(-16, -32),
				"X:%s  Y:%s" % [x, y]
			)
