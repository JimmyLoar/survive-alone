class_name ItemComponent

var owner: ItemEntity


func apply(entity: ItemEntity) -> ItemEntity:
	owner = entity
	return entity


func serialize() -> Dictionary:
	return {}


func deserialize(data: Dictionary) -> void:
	pass


func get_type() -> ItemResource.Components:
	return -1


func get_type_string() -> String:
	return "none"
