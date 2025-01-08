class_name BiomeRectRepository
extends Injectable

var _db: GameDb

func _init(host_node: Node) -> void:
	_db = Injector.inject(GameDb, host_node)

func get_by_id(id: int) -> BiomeRectEntity:
	var select_condition = "SELECT 1 FROM your_table WHERE id = %d" % id
	var rows = _db.connection.select_rows("biome_rect", select_condition, ["id", "x", "y", "end_x", "end_y", "biome_id"])

	if rows.size() == 0:
		return null
	
	return _row_to_entity(rows[0])

func get_all_intersected(rect: Rect2i) -> Array[BiomeRectEntity]:
	var x = rect.position.x
	var y = rect.position.y
	var end_x = rect.end.x
	var end_y = rect.end.y
	var select_condition = """
SELECT *
FROM biome_rect rect
WHERE NOT
	(rect.x < %d OR
	rect.end_x > %d OR
	rect.y < %d OR
	rect.end_y > %d);
""" % [x, end_x, y, end_y]
	_db.connection.query(select_condition)
	var rows = _db.connection.query_result
	# Shitty gdscript static typing
	# https://forum.godotengine.org/t/cast-untyped-array-to-typed-array/50135
	# https://github.com/godotengine/godot/issues/72620
	var entities: Array[BiomeRectEntity]
	entities.assign(rows.map(Callable(self, "_row_to_entity")))
	return entities

func has(id: int):
	if id < 0:
		return false
	var select_condition = "SELECT 1 FROM your_table WHERE id = %d" % id
	var rows = _db.connection.select_rows("biome_rect", select_condition, ["id"])

	return rows.size() > 0

func insert(entity: BiomeRectEntity):
	if has(entity.id): 
		update(entity)
	else:
		create(entity)

func update(entity: BiomeRectEntity):
	var select_condition = "id = %d" % entity.id
	_db.connection.update_rows("biome_rect", select_condition, _entity_to_row(entity))

func create(entity: BiomeRectEntity) -> int:
	_db.connection.insert_row("biome_rect", _entity_to_row(entity, true))
	return _db.connection.last_insert_rowid

func delete(id: int):
	var select_condition = "id = %d" % id
	_db.connection.delete_rows("biome_rect", select_condition)

func _row_to_entity(row: Dictionary) -> BiomeRectEntity:
	var entity = BiomeRectEntity.new()
	entity.id = row.id
	entity.rect = Rect2i(row.x, row.y, row.end_x - row.x, row.end_y - row.y)
	entity.biome_id = row.biome_id

	return entity

func _entity_to_row(entity: BiomeRectEntity, without_id = false) -> Dictionary:
	var row = {}
	if not without_id:
		row["id"] = entity.id
	row["x"] = entity.rect.position.x
	row["y"] = entity.rect.position.y
	row["end_x"] = entity.rect.end.x
	row["end_y"] = entity.rect.end.y
	row["biome_id"] =  entity.biome_id
	
	return row
