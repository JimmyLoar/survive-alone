class_name CharacterLocationState
extends Injectable


class BiomesLocation:
	var biomes: Array
	var _tile_pos: Vector2i

	func _init(__tile_pos: Vector2i, _biomes: Array) -> void:
		biomes = _biomes
		_tile_pos = __tile_pos

	func is_equal_biomes(other: CharacterLocationState.BiomesLocation):
		if biomes.size() != other.biomes.size():
			return false

		biomes.sort_custom(func(left, right): return left.id > right.id)
		other.biomes.sort_custom(func(left, right): return left.id > right.id)

		for i in range(0, biomes.size()):
			if biomes[i].id != other.biomes[i].id:
				return false
		return true


signal current_location_changed(value: Variant)
var current_location: Variant:
	get:
		return current_location
	set(value):
		if value != current_location:
			current_location = value
			current_location_changed.emit(value)
