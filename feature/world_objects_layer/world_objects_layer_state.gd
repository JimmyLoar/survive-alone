class_name WorldObjectsLayerState
extends Injectable

var _world_object_repository: WorldObjectRepository
var _host_node: Node

class VisibleObjectsDiff:
	var removed: Array[int] # Array of ids
	var added: Array[int]
	
	var is_empty:
		get:
			return removed.size() == 0 and added.size() == 0

var _visible_objects: Dictionary
signal visible_objects_changed(diff: VisibleObjectsDiff, value: Dictionary)
var visible_objects:
	get: return _visible_objects

var visible_rect: Rect2

func set_visible_rect(value: Rect2, force: bool = false):
	if visible_rect != value or force:
		visible_rect = value
		
		var intersected_objects = _world_object_repository.get_all_intersected(value)
		var diff = VisibleObjectsDiff.new()
		for object in intersected_objects:
			if not _visible_objects.has(object.id):
				_visible_objects[object.id] = object
				diff.added.push_back(object.id)
		for object in _visible_objects.values():
			if Utils.find_index(intersected_objects, func(intersected_object): return intersected_object.id == object.id) < 0:
				_visible_objects.erase(object.id)
				diff.removed.push_back(object.id)
		
		if not diff.is_empty:
			visible_objects_changed.emit(diff, _visible_objects)


func get_object_by_position_fast(pos: Vector2) -> WorldObjectEntity:
	var intersect_polygon_with_pos = func (entity: WorldObjectEntity):
		return Geometry2D.is_point_in_polygon(pos - entity.get_offset(), entity.resource.collision_shape.points)

	var intersected_visible_world_objects = _visible_objects.values().filter(intersect_polygon_with_pos)

	if intersected_visible_world_objects.size() > 0:
		return intersected_visible_world_objects[0]
	
	var visible_world_objects = _world_object_repository.get_all_intersected(Rect2(pos, Vector2.ZERO))

	if visible_world_objects.size() > 0:
		return visible_world_objects[0]
	
	return null

func request_rerender() -> void:
	set_visible_rect(visible_rect, true)
