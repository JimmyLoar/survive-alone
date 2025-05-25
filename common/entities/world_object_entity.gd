class_name WorldObjectEntity

# id - это удвоеный id базы. Нужно пользоваться методами из репозитория для работы с базой!
var id: int
var boundary_rect: Rect2
var packed_scene: PackedScene
var _node_cache: BaseWorldObject

func get_collision_shape_in_global_coords() -> ConcavePolygonShape2D:
	var shape = _get_node().get_collision_shape()
	var offset = get_offset()
	var polygon = ConcavePolygonShape2D.new()
	var segments = []
	for i in range(shape.segments.size()):
		segments.append(shape.segments[i] + offset)
	polygon.segments = segments
	return polygon

func get_collision_polygon_points_in_global_coords() -> PackedVector2Array:
	var shape = _get_node().get_collision_shape()
	var offset = get_offset()
	var polygon = ConcavePolygonShape2D.new()
	var points = []
	for i in range(shape.segments.size()):
		if i % 2 == 0:
			points.append(shape.segments[i] + offset)
	return PackedVector2Array(points)

func _get_node() -> BaseWorldObject:
	if _node_cache == null:
		_node_cache = packed_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)

	return _node_cache

func get_offset() -> Vector2:
	return boundary_rect.position - _get_node().get_collision_shape().get_rect().position


func is_in_save() -> bool:
	return id % 2 == 0


func clone() -> WorldObjectEntity:
	var _clone = WorldObjectEntity.new()
	_clone.id = id
	_clone.boundary_rect = boundary_rect
	_clone.packed_scene = packed_scene
	return _clone
