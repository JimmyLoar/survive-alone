class_name CharacterLocationState
 
var _logger := Log.get_global_logger().with("CharacterLocation")

var tile_size: int = ProjectSettings.get_setting("application/game/size/tile", 16) 
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
			_logger.debug("character change location, new '%s' (%s)" % [get_location_name(), current_location.get_script().get_global_name()])
			current_location_changed.emit(value)
			

var current_tile_pos = Vector2i.MAX

var world_objects_cache = []
var biomes_cache = {}

func update_cache(tile_pos: Vector2i):
	var from_tile = tile_pos - Vector2i.ONE
	var to_tile = tile_pos + 2 * Vector2i.ONE
	var rect = Rect2i(from_tile * tile_size, (to_tile - from_tile) * tile_size)
	var tiles_rect = Rect2i(from_tile, to_tile - from_tile)
	var world_objects_repository: WorldObjectRepository = Locator.get_service(WorldObjectRepository)
	var biomes_rect_repository: BiomeRectRepository = Locator.get_service(BiomeRectRepository)
	var biomes_repository: BiomeRepository = Locator.get_service(BiomeRepository)

	var biome_rects = biomes_rect_repository.get_all_intersected(tiles_rect)

	world_objects_cache = world_objects_repository.get_all_intersected(rect)
	biomes_cache = {}
	for x in range(from_tile.x, to_tile.x):
		for y in range(from_tile.y, to_tile.y):
			var pos = Vector2i(x, y)

			for biome_rect in biome_rects:
				if biome_rect.rect.intersects(Rect2i(pos, Vector2i.ONE)):
					if not biomes_cache.has(pos):
						biomes_cache[pos] = []
					if Utils.find_index(biomes_cache[pos], func(biome: BiomeEntity): return biome.id == biome_rect.biome_id) == -1:
						var biome = biomes_repository.get_by_id(biome_rect.biome_id)
						biomes_cache[pos].push_back(biome)


func get_world_object(pos: Vector2):
	for world_object in world_objects_cache:
		if Geometry2D.is_point_in_polygon(pos, world_object.get_collision_polygon_points_in_global_coords()):
			return world_object
	return null


func get_biomes(pos: Vector2i):
	return biomes_cache.get(pos, [])


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


func _on_quest_started(quest: QuestResource):
	for objective in quest.get_active_objectives():
		_on_add_objective(quest, objective)


func _on_add_objective(quest: QuestResource, objective: QuestObjective):
	for condition: QuestCondition in objective.conditions:
		if condition.type != QuestCondition.TypeVariants.location_change or current_location_changed.is_connected(_on_changed_location.bind(quest, condition)):
			continue
		
		current_location_changed.connect(_on_changed_location.bind(quest, condition))


func _on_changed_location(location, quest: QuestResource, objective: QuestCondition):
	if objective.completed:
		return
	
	var result := true
	if typeof(objective.value) == TYPE_INT:
		result = location.id == int(objective.value)
	
	objective.set_completed(result)
	if result:
		quest.update()
		current_location_changed.disconnect(_on_changed_location.bind(quest, objective))
	
