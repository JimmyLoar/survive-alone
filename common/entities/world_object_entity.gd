class_name WorldObjectEntity

# id - это удвоеный id базы. Нужно пользоваться методами из репозитория для работы с базой!
var id: int
var boundary_rect: Rect2
var resource: WorldObjectResource


func get_collision_shape_in_global_coords() -> ConvexPolygonShape2D:
	var offset = get_offset()
	var points = resource.collision_shape.points.duplicate()
	for i in range(points.size()):
		points[i] += offset
	var polygon = ConvexPolygonShape2D.new()
	polygon.set_point_cloud(points)
	return polygon


func get_offset() -> Vector2:
	return boundary_rect.position - resource.collision_shape.get_rect().position


func is_in_save() -> bool:
	return id % 2 == 0


func clone() -> WorldObjectEntity:
	var clone = WorldObjectEntity.new()
	clone.id = id
	clone.boundary_rect = boundary_rect
	clone.resource = resource
	return clone
