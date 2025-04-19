@tool
extends Node2D
class_name BaseWorldObject

@export var show_collision_shape = false

const COLLISION_POLYGON_NODE_PATH = "CollisionShape"
const COLLISION_POLYGON_NODE_FOUND_ERROR = "Не определен шейп колизии (Polygon2D с именем '%s')" % COLLISION_POLYGON_NODE_PATH
const COLLISION_POLYGON_NODE_TYPE_ERROR = "Нода шейпа колизии ('%s') дожна иметь тип Polygon2D" % COLLISION_POLYGON_NODE_PATH
const COLLISION_POLYGON_NODE_HIDDEN_ERROR = "Нода шейпа колизии ('%s') дожна по умолчанию быть скрыта" % COLLISION_POLYGON_NODE_PATH

func _ready() -> void:
	if OS.has_feature("debug") and show_collision_shape:
		var line = Line2D.new()
		var shape = get_collision_shape()
		
		for i in range(shape.segments.size()):
			if i % 2 == 1:
				line.add_point(shape.segments[i])
		line.closed = true
		line.width = 2
		line.default_color = Color.RED
		add_child(line)

var _collision_shape_cache: ConcavePolygonShape2D = null
func get_collision_shape() -> ConcavePolygonShape2D:
	if _collision_shape_cache != null:
		return _collision_shape_cache

	var polygon_node = _get_collision_polygon()
	var shape = ConcavePolygonShape2D.new()
	
	var prev_point = polygon_node.polygon[polygon_node.polygon.size() - 1]
	var segments = [] as Array[Vector2]
	for point in polygon_node.polygon:
		segments.append(prev_point + polygon_node.position)
		segments.append(point + polygon_node.position)
		prev_point = point

	shape.segments = PackedVector2Array(segments)
	_collision_shape_cache = shape
	return shape

func _get_configuration_warnings():
	var result = []
	var polygon_node = _get_collision_polygon()

	if polygon_node == null:
		result.append(COLLISION_POLYGON_NODE_FOUND_ERROR)

	if polygon_node != null and not is_instance_of(polygon_node, Polygon2D):
		result.append(COLLISION_POLYGON_NODE_TYPE_ERROR)

	if polygon_node != null and polygon_node.visible:
		result.append(COLLISION_POLYGON_NODE_HIDDEN_ERROR)

	return result

func _get_collision_polygon() -> Polygon2D:
	var node = get_node(COLLISION_POLYGON_NODE_PATH)

	if node == null:
		push_error(COLLISION_POLYGON_NODE_FOUND_ERROR)

	if node != null and not is_instance_of(node, Polygon2D):
		push_error(COLLISION_POLYGON_NODE_TYPE_ERROR)

	if node != null and (node as Polygon2D).visible:
		push_error(COLLISION_POLYGON_NODE_HIDDEN_ERROR)

	return node
