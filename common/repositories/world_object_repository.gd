class_name WorldObjectRepository
extends Injectable

var _db: GameDb
var _resource_db: ResourceDb

func _init(host_node: Node) -> void:
	_db = Injector.inject(GameDb, host_node)
	_resource_db = Injector.inject(ResourceDb, host_node)

func get_by_id(id: int) -> WorldObjectEntity:
	var select_condition = "SELECT 1 FROM your_table WHERE id = %d" % id
	var rows = _db.connection.select_rows("world_object", select_condition, ["id", "x", "y", "end_x", "end_y"])

	if rows.size() == 0:
		return null
	
	return _row_to_entity(rows[0])

func get_all_intersected(rect: Rect2i) -> Array[WorldObjectEntity]:
	var x = rect.position.x
	var y = rect.position.y
	var end_x = rect.end.x
	var end_y = rect.end.y
	var select_condition = """
SELECT *
FROM world_object object
WHERE NOT
	(object.x < %d OR
	object.end_x > %d OR
	object.y < %d OR
	object.end_y > %d);
""" % [x, end_x, y, end_y]
	_db.connection.query(select_condition)
	var rows = _db.connection.query_result
	# Shitty gdscript static typing
	# https://forum.godotengine.org/t/cast-untyped-array-to-typed-array/50135
	# https://github.com/godotengine/godot/issues/72620
	var entities: Array[WorldObjectEntity]
	entities.assign(rows.map(Callable(self, "_row_to_entity")))
	return entities

func has(id: int):
	if id < 0:
		return false
	var select_condition = "SELECT 1 FROM your_table WHERE id = %d" % id
	var rows = _db.connection.select_rows("world_object", select_condition, ["id"])

	return rows.size() > 0

func insert(entity: WorldObjectEntity):
	if has(entity.id): 
		update(entity)
	else:
		create(entity)

func update(entity: WorldObjectEntity):
	var select_condition = "id = %d" % entity.id
	_db.connection.update_rows("world_object", select_condition, _entity_to_row(entity))

func create(entity: WorldObjectEntity) -> int:
	_db.connection.insert_row("world_object", _entity_to_row(entity, true))
	return _db.connection.last_insert_rowid

func delete(id: int):
	var select_condition = "id = %d" % id
	_db.connection.delete_rows("world_object", select_condition)

func _row_to_entity(row: Dictionary) -> WorldObjectEntity:
	var entity = WorldObjectEntity.new()
	entity.id = row.id
	entity.boundary_rect = Rect2i(row.x, row.y, row.end_x - row.x, row.end_y - row.y)
	entity.resource = _resource_db.connection.fetch_data(&"world_objects", entity.id)

	return entity

func _entity_to_row(entity: WorldObjectEntity, without_id = false) -> Dictionary:
	var row = {}
	if not without_id:
		row["id"] = entity.id
	row["x"] = entity.boundary_rect.position.x
	row["y"] = entity.boundary_rect.position.y
	row["end_x"] = entity.boundary_rect.end.x
	row["end_y"] = entity.boundary_rect.end.y
	
	return row
