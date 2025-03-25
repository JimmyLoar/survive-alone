class_name CharacterPropertyRepository
extends Injectable

var TABLE_NAME = "character_prop"
var _save_db: SaveDb

func init(save_db: SaveDb) -> void:
	_save_db = save_db

func get_by_name(name: StringName) -> CharacterPropertyEntity:
	var select_condition = "name = %s" % name
	var row = _save_db.connection.select_rows(
		TABLE_NAME, select_condition, ["name", "resource"]
	)
	if row.size() == 0:
		return null
	return _row_to_resource(row[0])

func has(name: StringName) -> bool:
	var select_condition = "name = %s" % name
	var row = _save_db.connection.select_rows(TABLE_NAME, select_condition, ["name"])
	return row.size() > 0

func has_batch(names: Array) -> Array:
	var names_condition = names.map(func(name: String): return "'%s'" % name)
	var select_condition = "name in (%s)" % Utils.join_to_str(names_condition, ", ")
	var rows = _save_db.connection.select_rows(TABLE_NAME, select_condition, ["name"])
	return rows.map(func(row): return row["name"])

func update(res: CharacterPropertyEntity):
	var select_condition = "name = %s" % res.code_name
	_save_db.connection.update_rows(TABLE_NAME, select_condition, _resource_to_row(res))


func create(res: CharacterPropertyEntity) -> int:
	_save_db.connection.insert_row(TABLE_NAME, _resource_to_row(res))
	return _save_db.connection.last_insert_rowid


func insert(res: CharacterPropertyEntity):
	if has(res.code_name):
		update(res)
	else:
		create(res)

func insert_batch(resources: Array):
	_save_db.connection.query("BEGIN TRANSACTION")

	for res in resources:
		var row = _resource_to_row(res)
		var query = """
			INSERT OR REPLACE INTO character_prop 
			(name, resource) 
			VALUES (?, ?)
		"""
		
		_save_db.connection.query_with_bindings(query, [row["name"], row["resource"]])

	_save_db.connection.query("COMMIT")

func update_batch(resources: Array):
	_save_db.connection.query("BEGIN TRANSACTION")

	for res in resources:
		var row = _resource_to_row(res)
		var query = """
			REPLACE INTO character_prop 
			(name, resource) 
			VALUES (?, ?)
		"""
		
		_save_db.connection.query_with_bindings(query, [row["name"], row["resource"]])

	_save_db.connection.query("COMMIT")

func create_batch(resources: Array):
	_save_db.connection.query("BEGIN TRANSACTION")

	for res in resources:
		var row = _resource_to_row(res)
		var query = """
			INSERT OR IGNORE INTO character_prop 
			(name, resource) 
			VALUES (?, ?)
		"""
		
		_save_db.connection.query_with_bindings(query, [row["name"], row["resource"]])
	

	_save_db.connection.query("COMMIT")


func get_all() -> Array:
	_save_db.connection.query("SELECT * FROM %s;" % TABLE_NAME)
	var rows = _save_db.connection.query_result
	return rows.map(_row_to_resource)


func _resource_to_row(res: CharacterPropertyEntity):
	return {"name": str(res.data_name), "resource": res.serialize()}


func _row_to_resource(row: Dictionary) -> CharacterPropertyEntity:
	return CharacterPropertyEntity.deserialize(row["resource"])
