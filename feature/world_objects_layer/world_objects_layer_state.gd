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

var _visible_rect: Rect2
var visible_rect: Rect2:
	get: return _visible_rect
	set(value):
		if _visible_rect != value:
			_visible_rect = value
			
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
