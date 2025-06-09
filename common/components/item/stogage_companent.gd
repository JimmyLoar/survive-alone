class_name StorageComponent
extends ItemComponent

signal quantity_changed(value: int)
signal request_to_delete(owner: ItemEntity)

var last_changed_quantity: int


func serialize() -> Dictionary:
	var data = super()
	data.merge({
		"amount": get_amount()
	})
	return data


func deserialize(data: Dictionary) -> void:
	super(data)


func get_amount() -> int:
	return 0


func append(value):
	pass


func has(value):
	return false


func remove(value):
	return value


func get_type_string() -> String:
	return "storage"
