extends Node

var logger := GodotLogger.with("InventoryController")

var _inventories: Dictionary = {}


func create_inventory(name_inv: String) -> Inventory:
	if _inventories.has(name_inv):
		logger.debug("Attempt to create an inventory with an existing name '%s'. Return existed inv." % [name_inv])
		return _inventories[name_inv]
	
	var new_inventory := Inventory.new()
	_inventories[name_inv] = new_inventory
	return new_inventory


func get_inventory(name_inv: String) -> Inventory:
	if _inventories.has(name_inv):
		return _inventories[name_inv]
	
	logger.debug("Attempt to getting an inventory with a non-existent name '%s'. Created new inv." % [name_inv])
	return create_inventory(name_inv)


func move_item_in_inventories(inv_name_A: String, inv_name_B: String, slot_index: int, count := -1):
	var inv_A := get_inventory(inv_name_A)
	var inv_B := get_inventory(inv_name_B)
	if not _move_item_validate(inv_A, inv_B, slot_index): 
		logger.error("Cannot moving item between invetories? become found error.")
		return false
	
	var _amount = inv_A.get_slot_size(slot_index)
	if count >= _amount:
		logger.warn("Attempt to move more than it is | count = %d; amount = %d" % [count, _amount])
		count = -1
	
	if count <= -1:
		var slot = inv_A.remove_slot(slot_index)
		inv_B.add_slot(slot)
		logger.debug("Moved all (%d) items '%s' from '%s' to '%s' inventory" %[_amount, slot.item.name, inv_name_A, inv_name_B])
		return true
	
	var slot = inv_A.get_slot(slot_index)
	var used: Array = slot.used
	
	if used.size() > count and not used.is_empty():
		slot.used = used.slice(count, -1)
		used = used.slice(0, count)
	
	var reaming = count - used.size()
	slot.amount -= reaming
	
	var new_slot: Dictionary = inv_B.get_slot_and_create_if_not(slot.item)
	new_slot.used.append_array(used)
	new_slot.amount += reaming
	logger.debug("Moved items '%s' %d (amount %d/ used %d) from '%s' to '%s' inventory" %
		[slot.item.name, count, reaming, used.size(), inv_name_A, inv_name_B])
	inv_A.changed.emit()
	inv_B.changed.emit()
	return true




func _move_item_validate(inv_A: Inventory, inv_B: Inventory, index: int):
	if inv_A == inv_B: 
		logger.warn("Attempting to move an item into the same inventory")
		return false
	
	if not inv_A.is_index_validate(index):
		logger.warn("Not validate index (%d) to inventory '%s' | min: 0 | max: %d |" % [index, inv_A, inv_A.get_size()])
		return false
	
	return true
