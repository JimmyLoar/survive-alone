class_name  StorageComponent
extends ItemComponent

signal quantity_changed(value: int)


var last_change


func get_amount() -> int:
	return 0


func append(value):
	pass


func has(value):
	return false


func remove(value):
	pass


func get_type_string() -> String:
	return "storage"
