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


func move_item_in_inventories(inv_name_A: String, inv_name_B: String, item_index: int):
	var inv_A := get_inventory(inv_name_A)
	var inv_B := get_inventory(inv_name_B)
	
	if inv_A == inv_B: 
		logger.error("Attempting to move an item into the same inventory")
		return false
	
	var slot = inv_A.remove_slot(item_index)
	inv_B.add_slot(slot)
	logger.debug("Moved item '%s' from '%s' to '%s' inventory" %[slot.item.name, inv_name_A, inv_name_B])
	return true
