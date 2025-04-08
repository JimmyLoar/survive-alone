class_name BiomeRepository
extends Injectable

var _db: GameDb


func _init(host_node: Node) -> void:
	_db = Injector.inject(GameDb, host_node)


func get_by_id(id: int) -> BiomeEntity:
	var select_condition = "id = %d" % id
	var row = _db.connection.select_rows(
		"biome", select_condition, ["id", "name", "resource"]
	)
	if row.size() == 0:
		return null
	return _row_to_entity(row[0]) as BiomeEntity


func get_all() -> Array[BiomeEntity]:
	_db.connection.query("SELECT * FROM biome;")
	var rows = _db.connection.query_result

	# Shitty gdscript static typing
	# https://forum.godotengine.org/t/cast-untyped-array-to-typed-array/50135
	# https://github.com/godotengine/godot/issues/72620
	var entities: Array[BiomeEntity]
	entities.assign(rows.map(Callable(self, "_row_to_entity")))
	return entities


func has(id: int):
	var select_condition = "id = %d" % id
	var row = _db.connection.select_rows("biome", select_condition, ["id"])
	return row.size() > 0


func update(entity: BiomeEntity):
	var select_condition = "id = %d" % entity.id
	_db.connection.update_rows("biome", select_condition, _entity_to_row(entity, true))


func create(entity: BiomeEntity) -> int:
	_db.connection.insert_row("biome", _entity_to_row(entity, true))
	return _db.connection.last_insert_rowid


func insert(entity: BiomeEntity):
	if has(entity.id):
		update(entity)
	else:
		create(entity)


func remove(id: int):
	var select_condition = "id = %d" % id
	_db.connection.delete_rows("biome", select_condition)


func _row_to_entity(row: Dictionary) -> BiomeEntity:
	var entity = BiomeEntity.new()

	entity.id = row["id"]
	entity.name = row["name"]
	entity.resource = load(ResourceUID.get_id_path(ResourceUID.text_to_id(row["resource"])))

	return entity


func _entity_to_row(entity: BiomeEntity, without_id: bool = false) -> Dictionary:
	var row = {}
	if not without_id:
		row["id"] = entity.id
	row["name"] = entity.name
	row["resource"] = ResourceUID.id_to_text(ResourceLoader.get_resource_uid(entity.resource.resource_path))

	return row
