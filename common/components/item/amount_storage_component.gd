class_name AmountStorageComponent
extends StorageComponent

var _amount: int = 0:
	set(value):
		last_changed_quantity = value - _amount 
		_amount = value
		quantity_changed.emit(_amount)
		if _amount <= 0:
			request_to_delete.emit(owner)
		
		print_stack()
		print_debug("amount: %d" % _amount)
		print()


func apply(entity: ItemEntity) -> ItemEntity:
	return super(entity)


func get_amount() -> int:
	return _amount


func append(value: int):
	_amount += abs(value)


func has(value: int):
	return false


func remove(value: int) -> int:
	_amount = max(_amount - abs(value), 0)
	if _amount <= 0:
		request_to_delete.emit(owner)
	return last_changed_quantity


func serialize() -> Dictionary:
	var data = super()
	data.merge({
		"amount": _amount,
	}, true)
	return data


func deserialize(data: Dictionary) -> void:
	super(data)
	_set_data(data, "_amount", "amount")


func get_type_string() -> String:
	return "durability"
