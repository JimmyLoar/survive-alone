class_name Character
extends Node2D

signal changed_chunk(new_chunk: Vector2i)

#region CunckProperty
#count tiles in chunk 
var chunk_size: int = ProjectSettings.get_setting("application/game/size/chunk", 16) 
#count pixels in tile
var tile_size: int = ProjectSettings.get_setting("application/game/size/tile", 16)  
var _chunk_pixel_size: int = chunk_size * tile_size
var _last_visit_chunk := Vector2i.ZERO
#endregion

@onready var controller: Node2D = $Controller

func _ready() -> void:
	_last_visit_chunk = get_chunk_position()
	controller.target = self


func _physics_process(delta: float) -> void:
	if not controller.is_moving(): return
	var _currect_chunk: Vector2i = get_chunk_position()
	if _currect_chunk != _last_visit_chunk:
		emit_signal('changed_chunk', _currect_chunk)
		_last_visit_chunk = _currect_chunk


func get_chunk_position() -> Vector2i:
	return global_position / _chunk_pixel_size
