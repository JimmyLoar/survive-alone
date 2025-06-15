class_name SummedInventory
 

var _inventories: Array[InventoryState] = []


func _init():
	Questify.condition_query_requested.connect(_on_quest_condition_query_requested)


func add_inventory(inv: InventoryState) -> void:
	if _inventories.has(inv):
		return
	_inventories.append(inv)


func has_item(name: String, value: int) -> bool:
	return get_items_amount(name) >= value


func remove_item(name: String, value: int) -> int:
	assert(not _inventories.is_empty(), "inventories is empty")
	var _tmp = value
	for inv in _inventories:
		if value <= 0: 
			break
		value = inv.remove_item(name, value)
	return value - _tmp


func get_items_amount(name: String) -> int:
	assert(not _inventories.is_empty(), "inventories is empty")
	var amount = 0
	for inv in _inventories:
		amount += inv.find_and_get_amount(name)
	return amount


func _on_quest_condition_query_requested(type: QuestCondition.TypeVariants, key: String, value: Variant, requester: QuestCondition):
	var result = false
	if type == QuestCondition.TypeVariants.inventory_has:
		match key:
			&"item": 
				result = has_item(value, 1)
			
			&"item_amount": 
				result = has_item(value.get_slice(":", 0), int(value.get_slice(":", 1)))
	
	elif type == QuestCondition.TypeVariants.inventory_add:
		pass
	
	requester.set_completed(result)
	return
