class_name BiomesLayerState
 

var _biome_rect_repository: BiomeRectRepository
var _biome_repository: BiomeRepository
var _host_node: BiomesLayer


func _init(host_node: BiomesLayer) -> void:
	_host_node = host_node
	_biome_rect_repository = Locator.get_service(BiomeRectRepository)
	_biome_repository = Locator.get_service(BiomeRepository)


func global_to_map(global: Vector2) -> Vector2i:
	var local = _host_node._grass_layer.to_local(global)
	return _host_node._grass_layer.local_to_map(local)


func map_to_global(map: Vector2i) -> Vector2:
	var local = (
		_host_node._grass_layer.map_to_local(map)
		- Vector2(_host_node._grass_layer.tile_set.tile_size / 2)
	)
	return _host_node._grass_layer.to_global(local)


var _visible_biome_rects: Dictionary  #Dictionary<int, BiomeRectRepository>
signal visible_biome_rects_chaged(value: Dictionary)
var visible_biome_rects: Dictionary:
	get:
		return _visible_biome_rects

var _visible_biomes: Dictionary = {}
var _visible_biomes_ref_count: Dictionary = {}
var visible_biomes: Dictionary:
	get:
		return _visible_biomes

signal visible_tiles_rect_changed(diff: VisibleTilesDiff, rect: Rect2i)
var _visible_tiles_rect: Rect2i = Rect2i(0, 0, 0, 0)
var visible_tiles_rect: Rect2i:
	get:
		return _visible_tiles_rect

func set_visible_tiles_rect(value: Rect2i, force = false):
	if force or _visible_tiles_rect != value:
		var diff = VisibleTilesDiff.from_rect_diff(_visible_tiles_rect, value)
		var _is_visible_biome_rects_changed = false
		for visible_biome_rect_id in _visible_biome_rects.keys():
			var visible_biome_rect: BiomeRectEntity = _visible_biome_rects[visible_biome_rect_id]
			if not value.intersects(visible_biome_rect.rect):
				_visible_biome_rects.erase(visible_biome_rect_id)
				_decrease_biome_counter(visible_biome_rect.biome_id)
				_is_visible_biome_rects_changed = true

		var db_biome_rects = _biome_rect_repository.get_all_intersected(value)
		for db_biome_rect in db_biome_rects:
			if not _visible_biome_rects.has(db_biome_rect.id):
				_visible_biome_rects[db_biome_rect.id] = db_biome_rect
				_increase_biome_counter(db_biome_rect.biome_id)
				_is_visible_biome_rects_changed = true
		_visible_tiles_rect = value
		visible_tiles_rect_changed.emit(diff, _visible_tiles_rect)
		if _is_visible_biome_rects_changed:
			visible_biome_rects_chaged.emit(_visible_biome_rects)

func _decrease_biome_counter(biome_id: int):
	_visible_biomes_ref_count[biome_id] -= 1
	if _visible_biomes_ref_count[biome_id] == 0:
		_visible_biomes_ref_count.erase(biome_id)
		_visible_biomes.erase(biome_id)


func _increase_biome_counter(biome_id: int):
	if not _visible_biomes_ref_count.has(biome_id):
		_visible_biomes_ref_count[biome_id] = 0
		_visible_biomes[biome_id] = _biome_repository.get_by_id(biome_id)
	_visible_biomes_ref_count[biome_id] += 1


func get_visible_tile_biomes_fast(pos: Vector2i) -> Array:
	var biome_ids = []
	for biome_rect: BiomeRectEntity in visible_biome_rects.values():
		if biome_rect.rect.has_point(pos) and not biome_ids.has(biome_rect.biome_id):
			biome_ids.push_back(biome_rect.biome_id)

	# TODO добавить подгрузку биома из базы если не найден в кэше. Кэш обновлять не нужно
	return biome_ids.map(func(biome_id): return _visible_biomes.get(biome_id, null)).filter(
		func(biome): return biome != null
	)


func create_biome_rect(biome_rect: BiomeRectEntity):
	biome_rect.id = _biome_rect_repository.create(biome_rect)

	if _visible_tiles_rect.intersects(biome_rect.rect):
		_visible_biome_rects[biome_rect.id] = biome_rect
		_increase_biome_counter(biome_rect.biome_id)
		visible_biome_rects_chaged.emit(_visible_biome_rects)
		var diff = VisibleTilesDiff.new()
		diff.updated.push_back(biome_rect.rect)
		visible_tiles_rect_changed.emit(diff, _visible_tiles_rect)


func delete_biome_rect(id: int):
	_biome_rect_repository.delete(id)

	if _visible_biome_rects.has(id):
		var biome_rect: BiomeRectEntity = _visible_biome_rects[id]
		_visible_biome_rects.erase(id)
		_decrease_biome_counter(biome_rect.biome_id)
		visible_biome_rects_chaged.emit(_visible_biome_rects)
		var diff = VisibleTilesDiff.new()
		diff.updated.push_back(biome_rect.rect)
		visible_tiles_rect_changed.emit(diff, _visible_tiles_rect)

func refresh_visible_biome(biome_id: int):
	if not _visible_biomes.has(biome_id):
		return
	
	var new_biome = _biome_repository.get_by_id(biome_id)
	
	if new_biome == null:
		return
	
	_visible_biomes[biome_id] = new_biome
	visible_biome_rects_chaged.emit(_visible_biome_rects)
	var diff = VisibleTilesDiff.new()
	var updated_rects = visible_biome_rects.values().filter(func(biome_rect: BiomeRectEntity): return biome_rect.biome_id == new_biome.id).map(func(biome_rect: BiomeRectEntity): return biome_rect.rect)
	diff.updated.append_array(updated_rects)
	visible_tiles_rect_changed.emit(diff, _visible_tiles_rect)
