class_name CharacterLocationState
extends Injectable

var _logger = Log.get_global_logger().with("CharacterLocationState")


class BiomesLocation:
	var biomes: Array
	var tile_pos: Vector2i

	func _init(_tile_pos: Vector2i, _biomes: Array) -> void:
		biomes = _biomes
		tile_pos = _tile_pos


signal current_location_changed(value: Variant)
var current_location: Variant:
	get:
		return current_location
	set(value):
		if value != current_location:
			var to_biome_name = func(biome: BiomeEntity): return biome.name
			var name = (
				value.resource.name_key
				if not is_instance_of(value, BiomesLocation)
				else (
					"Biomes %s: [%s]"
					% [value.tile_pos, Utils.join_to_str(value.biomes.map(to_biome_name), ", ")]
				)
			)
			_logger.debug("Changed curent location:", name)

			current_location = value
			current_location_changed.emit(value)
