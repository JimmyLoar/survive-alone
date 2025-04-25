class_name SummedInventory
 


var _inventories: Array[InventoryState] = []
var _state := InventoryState.new("Summary")


func add_inventory(inv: InventoryState):
	_inventories.append(inv)


func has_item(name: String, value: int):
	return get_items_amount(name) >= value


func remove_item(name: String, value: int):
	assert(not _inventories.is_empty(), "inventories is empty")
	var _tmp = value
	for inv in _inventories:
		value = inv.remove_item(name, value)
	return value - _tmp


func get_items_amount(name: String):
	assert(not _inventories.is_empty(), "inventories is empty")
	var amount = 0
	for inv in _inventories:
		amount += inv.find_and_get_amount(name)
	return amount
