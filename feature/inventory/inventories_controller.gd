class_name InventoriesController

var logger := GodotLogger.with("InventoryController")

var _inventories: Dictionary = {}
var _location_inventory: String = "tmp"


func _init() -> void:
	create_inventory("player")
	create_inventory("tmp")


func create_inventory(name_inv: String) -> Inventory:
	if _inventories.has(name_inv):
		logger.debug("Attempt to create an inventory with an existing name [color=yellow]%s[/color]. Return existed inv." % [name_inv])
		return _inventories[name_inv]
	
	var new_inventory := Inventory.new(name_inv)
	_inventories[name_inv] = new_inventory
	return new_inventory


func get_inventory(name_inv: String) -> Inventory:
	if _inventories.has(name_inv):
		return _inventories[name_inv]
	
	logger.debug("Attempt to getting an inventory with a non-existent name [color=yellow]%s[/color]. Created new inv." % [name_inv])
	return create_inventory(name_inv)


func get_player_inventory() -> Inventory:
	return get_inventory("player")


func set_local_inventory_name(_name: String):
	_location_inventory = _name
	logger.debug("Set new local inventory name [color=green]%s[/color]" % _name)


func get_location_inventory() -> Inventory:
	return get_inventory(_location_inventory)


func move_item_in_inventories(item: Item, count := -1, player_to_local: bool = true):
	var inventories = [get_location_inventory(), get_player_inventory()]
	if player_to_local: inventories.reverse()
	var transfer := ItemTransfer.new(inventories[0], inventories[1])
	return transfer.transfer(item, count)


class ItemTransfer:
	var from_inventory: Inventory
	var to_inventory: Inventory
	
	func _init(_from: Inventory, _to: Inventory) -> void:
		if _from == _to:
			GodotLogger.warn("ItemTransfer | Attempt to create transfer the same inventory")
			self.free()
		
		from_inventory = _from
		to_inventory = _to
	
	
	func transfer(item: Item, count: int = -1):
		GodotLogger.debug("ItemTransfer | start transfer for item '%s'" % [item.get_index()])
		if count >= item.get_total_amount() or count == -1:
			return _transfer_full_item(item)
		
		var reaming = _transfer_used(item, count)
		_transfer_amount(item, reaming)
		GodotLogger.debug("Done transfer [color=green]%d %s[/color] from [color=green]%s[/color] to [color=green]%s[/color]" % 
			[count, item.get_data().name_key, from_inventory.name, to_inventory.name])
		return false
	
	
	func _transfer_full_item(item: Item):
		from_inventory._remove_from_storage(item.get_index())
		to_inventory.add_item(item.get_data(), item.get_amount(), item.get_used())
		GodotLogger.debug("Done transfer all [color=green]%s[/color] from [color=green]%s[/color] to [color=green]%s[/color]" % 
			[item.get_data().name_key, from_inventory.name, to_inventory.name])
		return true
	
	
	func _transfer_used(item_a: Item, count: int = 0):
		var item_b = to_inventory.get_or_create_item(item_a.get_data())
		var used_array = item_a.get_used()
		item_b.append_used(used_array.slice(0, count))
		item_a.set_used(used_array.slice(count, -1))
		GodotLogger.debug("ItemTransfer | transfered used items [color=green]%s[/color]" %
			[used_array.slice(0, count)])
		return count - used_array.slice(0, count).size()


	func _transfer_amount(item_a: Item, count: int = 0):
		var item_b = to_inventory.get_or_create_item(item_a.get_data())
		item_a.change_amount(count * -1)
		item_b.change_amount(count)
		return true
