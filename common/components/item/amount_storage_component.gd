class_name AmountStorageComponent
extends StorageComponent


func apply(entity: ItemEntity) -> ItemEntity:
	return super(entity)


func get_amount() -> int:
	return 0


func append(value):
	pass


func has(value):
	return false


func remove(value):
	pass


func serialize() -> Dictionary:
	return {}


func deserialize(data: Dictionary) -> void:
	pass


func get_type_string() -> String:
	return "durability"
