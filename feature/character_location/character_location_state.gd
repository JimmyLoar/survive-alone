class_name CharacterLocationState
 

var _host_node: CharacterLocation
func _init(host_node: CharacterLocation) -> void:
	_host_node = host_node

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
var current_location: Variant: # WorldObjectEntity или BiomesLocation
	get:
		return current_location
	set(value):
		if value != current_location:
			current_location = value
			current_location_changed.emit(value)


func get_location_name():
	if is_instance_of(current_location, WorldObjectEntity) and is_instance_of(current_location._get_node(), WorldLocation):
		return current_location._get_node().location_name

	var biomes := current_location.biomes as Array
	if not biomes or biomes.is_empty():
		return ""
	return TranslationServer.translate("BIOME_%s_NAME" % [biomes.front().name.to_upper()])


func get_location_discription():
	if is_instance_of(current_location, WorldObjectEntity) and is_instance_of(current_location._get_node(), WorldLocation):
		return current_location._get_node().loaction_description
	
	var biomes := current_location.biomes as Array
	if not biomes or biomes.is_empty():
		return ""
	return TranslationServer.translate("BIOME_%s_DISCRIPTION" % [biomes.front().name.to_upper()])


func request_reload():
	_host_node.reload()
