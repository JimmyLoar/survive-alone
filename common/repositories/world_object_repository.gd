class_name WorldObjectRepository
 

var _game_db: GameDb
var _save_db: SaveDb


func _init() -> void:
	_game_db = Locator.get_service(GameDb, _set_db)
	_save_db = Locator.get_service(SaveDb, _set_db)


func _set_db(db):
	if db is GameDb:
		_game_db = db
	if db is SaveDb:
		_save_db = db


func is_save_id(id: int) -> bool:
	return id % 2 == 0


func entity_to_game_db_id(id: int) -> int:
	return floor(id / 2.)


func entity_to_save_db_id(id: int) -> int:
	return ceil(id / 2.)


func game_db_to_entity_id(id: int) -> int:
	return id * 2 + 1


func save_to_entity_id(id: int) -> int:
	return id * 2


func get_by_id(id: int) -> WorldObjectEntity:
	if is_save_id(id):
		return get_by_id_from_save(id)
	else:
		return get_by_id_from_game_db(id)


func get_by_id_from_game_db(id: int) -> WorldObjectEntity:
	var select_condition = "id = %d" % entity_to_game_db_id(id)
	
	var rows = _game_db.connection.select_rows("world_object", select_condition, ["id", "x", "y", "end_x", "end_y", "uid"])

	if rows.size() == 0:
		return null
	
	var entity = _row_to_entity(rows[0])
	entity.id = game_db_to_entity_id(entity.id)
	return entity


func get_by_id_from_save(id: int) -> WorldObjectEntity:
	var select_condition = "id = %d" % entity_to_save_db_id(id)
	
	var rows = _save_db.connection.select_rows("world_object", select_condition, ["id", "x", "y", "end_x", "end_y", "uid"])

	if rows.size() == 0:
		return null
	
	var entity = _row_to_entity(rows[0])
	entity.id = save_to_entity_id(entity.id)
	return entity


func get_all_intersected(rect: Rect2i) -> Array[WorldObjectEntity]:
	var x = rect.position.x
	var y = rect.position.y
	var end_x = rect.end.x
	var end_y = rect.end.y
	var select_condition = """
SELECT *
FROM world_object
WHERE 
	end_x > %d
	AND x < %d
	AND end_y > %d
	AND y < %d;
""" % [x, end_x, y, end_y]

	_game_db.connection.query(select_condition)
	var _game_rows = _game_db.connection.query_result
	_save_db.connection.query(select_condition)
	var _save_rows = _save_db.connection.query_result

	# Shitty gdscript static typing
	# https://forum.godotengine.org/t/cast-untyped-array-to-typed-array/50135
	# https://github.com/godotengine/godot/issues/72620
	var entities: Array[WorldObjectEntity]
	var game_entities = _game_rows.map(_row_to_entity).map(func(e: WorldObjectEntity): 
		e.id = game_db_to_entity_id(e.id)
		return e
	)
	var save_entities = _save_rows.map(_row_to_entity).map(func(e: WorldObjectEntity): 
		e.id = save_to_entity_id(e.id)
		return e
	)
	entities.append_array(game_entities)
	entities.append_array(save_entities)
	return entities


func has(id: int):
	var mappedID
	var db;

	if is_save_id(id):
		db = _save_db
		mappedID = entity_to_save_db_id(id)
	else:
		db = _game_db
		mappedID = entity_to_game_db_id(id)

	if id < 0:
		return false
	var select_condition = "id = %d" % mappedID
	var rows = db.connection.select_rows("world_object", select_condition, ["id"])

	return rows.size() > 0


func insert(entity: WorldObjectEntity, to_game_db: bool):
	if has(entity.id): 
		update(entity)
	else:
		create(entity, to_game_db)


func update(entity: WorldObjectEntity):
	var mappedID
	var db;

	if is_save_id(entity.id):
		db = _save_db
		mappedID = entity_to_save_db_id(entity.id)
	else:
		db = _game_db
		mappedID = entity_to_game_db_id(entity.id)

	var select_condition = "id = %d" % mappedID
	var mapped_entity = entity.clone()
	mapped_entity.id = mappedID
	db.connection.update_rows("world_object", select_condition, _entity_to_row(mapped_entity))


func create(entity: WorldObjectEntity, to_game_db: bool) -> int:
	var db;

	if to_game_db:
		db = _game_db
	else:
		db = _save_db

	db.connection.insert_row("world_object", _entity_to_row(entity, true))
	var db_id = db.connection.last_insert_rowid
	if to_game_db:
		entity.id = game_db_to_entity_id(db_id)
	else:
		entity.id = save_to_entity_id(db_id)
	
	return entity.id


func delete(id: int):
	var mappedID
	var db;

	if is_save_id(id):
		db = _save_db
		mappedID = entity_to_save_db_id(id)
	else:
		db = _game_db
		mappedID = entity_to_game_db_id(id)

	var select_condition = "id = %d" % mappedID
	db.connection.delete_rows("world_object", select_condition)


func _row_to_entity(row: Dictionary) -> WorldObjectEntity:
	var entity = WorldObjectEntity.new()
	entity.id = row.id
	entity.boundary_rect = Rect2i(row.x, row.y, row.end_x - row.x, row.end_y - row.y)
	entity.packed_scene = load(ResourceUID.get_id_path(ResourceUID.text_to_id(row.uid)))

	return entity


func _entity_to_row(entity: WorldObjectEntity, without_id = false) -> Dictionary:
	var row = {}
	if not without_id:
		row["id"] = entity.id
	row["x"] = entity.boundary_rect.position.x
	row["y"] = entity.boundary_rect.position.y
	row["end_x"] = entity.boundary_rect.end.x
	row["end_y"] = entity.boundary_rect.end.y
	row["uid"] = ResourceUID.id_to_text(ResourceLoader.get_resource_uid(entity.packed_scene.resource_path))
	
	return row
