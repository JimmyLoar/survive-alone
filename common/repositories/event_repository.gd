

class_name EventRepository

var TABLE_NAME = "event"
var _save_db: SaveDb

func _init(save_db: SaveDb) -> void:
	_save_db = save_db

func get_by_id(id: int) -> EventResource:
	var select_condition = "id = %d" % id
	var rows = _save_db.connection.select_rows(TABLE_NAME, select_condition, ["id", "data"])
	if rows.size() == 0:
		return null
	return _row_to_resource(rows[0])

func create(resource: EventResource) -> int:
	var resource_path = resource.get_resource_path()
	var id = _path_to_id(resource_path)
	var row = _resource_to_row(resource, id)
	_save_db.connection.insert_row(TABLE_NAME, row)
	return id

func update(resource: EventResource):
	var resource_path = resource.get_resource_path()
	var id = _path_to_id(resource_path)
	var select_condition = "id = %d" % id
	_save_db.connection.update_rows(TABLE_NAME, select_condition, _resource_to_row(resource, id))

func insert(resource: EventResource):
	var resource_path = resource.get_resource_path()
	var id = _path_to_id(resource_path)
	var select_condition = "id = %d" % id
	var rows = _save_db.connection.select_rows(TABLE_NAME, select_condition, ["id"])
	if rows.size() > 0:
		update(resource)
	else:
		create(resource)

func create_batch(resources: Array):
	if resources.is_empty():
		return
	
	var value_placeholders = []
	var bind_values = []
	for resource in resources:
		var resource_path = resource.get_resource_path()
		var id = _path_to_id(resource_path)
		var row = _resource_to_row(resource, id)
		value_placeholders.append("(%d, ?)" % id)
		bind_values.append(row["data"])
	
	var query = """
		INSERT OR IGNORE INTO event 
		(id, data) 
		VALUES %s
	""" % Utils.join_to_str(value_placeholders, ", ")
	
	_save_db.connection.query_with_bindings(query, bind_values)

func _path_to_id(path: String) -> int:
	return Utils.path_to_id(path)

func _resource_to_row(resource: EventResource, id: int) -> Dictionary:
	return {
		"id": id,
		"data": resource.serialize()
	}

func _row_to_resource(row: Dictionary) -> EventResource:
	return EventResource.deserialize(row["data"])
