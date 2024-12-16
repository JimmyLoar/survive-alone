class_name Character
extends Node2D

signal changed_chunk(new_chunk: Vector2i)

@export var controller: CharacterController


#region CunckProperty
#count tiles in chunk 
var chunk_size: int = ProjectSettings.get_setting("application/game/size/chunk", 16) 
#count pixels in tile
var tile_size: int = ProjectSettings.get_setting("application/game/size/tile", 16)  
var _chunk_pixel_size: int = chunk_size * tile_size
var _last_visit_chunk := Vector2i.ZERO
#endregion


func _ready() -> void:
	_last_visit_chunk = get_chunk_position()
	controller.set_actor(self)


func _physics_process(delta: float) -> void:
	if not controller.is_moving(): return
	var _currect_chunk: Vector2i = get_chunk_position()
	if _currect_chunk != _last_visit_chunk:
		changed_chunk.emit(_currect_chunk)
		_last_visit_chunk = _currect_chunk


func get_chunk_position() -> Vector2i:
	return global_position / _chunk_pixel_size


func _on_area_2d_body_entered(body: TileMapLayer) -> void:
	var pos: Vector2i = Vector2i(global_position) / tile_size - get_chunk_position() * chunk_size
	var data = body.get_cell_tile_data(pos)
	if not data: 
		printerr(pos)
		return
	print("player enter biom %s" % data.get_custom_data("biome"))


func _on_area_2d_area_entered(area: Node2D) -> void:
	print("player enter biom %s (area)" % area)
