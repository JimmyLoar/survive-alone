class_name CharacterPropertyRepository
extends Injectable

var COLECTION_NAME = &"properties"
var _db: ResourceDb

func _init(host_node: Node) -> void:
	_db = Injector.inject(ResourceDb, host_node)

func get_by_string_id(id: StringName) -> CharacterPropertyResource:
	return _db.connection.fetch_data(COLECTION_NAME, id)

func get_all() -> Array:
	return _db.connection.fetch_collection_data(COLECTION_NAME).values()
