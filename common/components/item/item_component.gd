class_name ItemComponent

var owner: ItemEntity


func apply(entity: ItemEntity) -> ItemEntity:
	owner = entity
	return entity


func serialize() -> Dictionary:
	return {
		"type": get_type(),
		"resource": owner.get_resource_uid(),
	}


func deserialize(data: Dictionary) -> void:
	if get_type() != data.type:
		printerr("Data: %s" % data)
		push_error("Attempt setting wrong data!")


func get_type() -> ItemResource.Components:
	return -1


func get_type_string() -> String:
	return "none"


func _set_data(data, property_name, key):
	if data.has(key):
		set(property_name, data[key])
