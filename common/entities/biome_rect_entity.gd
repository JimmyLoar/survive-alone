class_name BiomeRectEntity
extends Object

var id: int
var rect: Rect2i
var biome_id: int

func _init():
	id = -1
	rect = Rect2i(Vector2i.ZERO, Vector2i.ZERO)
	biome_id = 0

func duplicate() -> BiomeRectEntity:
	var result = BiomeRectEntity.new()
	result.rect = rect
	result.biome_id = biome_id
	
	return result
