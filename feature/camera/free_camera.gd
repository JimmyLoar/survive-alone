extends Camera2D

@export var camera_controller: CameraController

var world_size: Vector2i = ProjectSettings.get_setting("application/game/size/world", Vector2i.ONE) 
var chunk_size: int = ProjectSettings.get_setting("application/game/size/chunk", 16) 

#count pixels in tile
var tile_size: int = ProjectSettings.get_setting("application/game/size/tile", 16)  
var _chunk_pixel_size: int = chunk_size * tile_size


func _ready() -> void:
	if camera_controller:
		camera_controller.set_actor(self)


func update_limits(_position: Vector2i) -> void:
	# обновляем лимиты по чанкам
	limit_right  = clamp(_position.x + 2, 0, world_size.x) * _chunk_pixel_size
	limit_bottom = clamp(_position.y + 2, 0, world_size.y) * _chunk_pixel_size
	limit_left   = clamp(_position.x - 1, 0, world_size.x) * _chunk_pixel_size
	limit_top    = clamp(_position.y - 1, 0, world_size.y) * _chunk_pixel_size


func _on_character_changed_chunk(new_chunk):
	update_limits(new_chunk)
