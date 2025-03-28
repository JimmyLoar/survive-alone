class_name InventoryState
extends Injectable

signal changed_inventory_entity(new_entity: InventoryEntity)

var name: String
var inventory_entity: InventoryEntity = InventoryEntity.new(): set = change_entity

var _stored_cache: Dictionary = {}
var _logger: Log 


func _init(new_name := "InventoryState") -> void:
	name = new_name
	_logger = Log.get_global_logger().with("Inventory%sState " % new_name)
	changed_inventory_entity.connect(_recount_index_items)


func change_entity(_new_entity: InventoryEntity) -> InventoryEntity:
	var tmp = inventory_entity
	inventory_entity = _new_entity
	
	var get_names: Callable = func(item: ItemEntity):
		return item.get_resource().code_name 
	
	changed_inventory_entity.emit(_new_entity)
	return tmp


func is_empty() -> bool:
	return inventory_entity.items.size() == 0

func add_item(data: ItemResource, value := 0, used: Array = []) -> ItemEntity:
	var found_index = find_item(data.code_name)
	if found_index != -1:
		var item = get_item(found_index)
		item.increase_total_amount(value)
		item.append_used(used)
		_logger.debug("Added [color=green]%d (used +%d)[/color] items [color=green]%s[/color] in exist item with index [color=green]%d[/color]" % 
			[value, used.size(), data.code_name, found_index])
		return item
	
	_logger.debug("Added [color=green]%d (used +%d)[/color] items [color=green]%s[/color] in new item, with index [color=green]%s[/color]" % 
		[value, used.size(), data.code_name, inventory_entity.items.size()])
	return _add_in_storage_entity(ItemEntity.new(data, value, used))


func remove_item(name: String, _amount := 1):
	if _amount <= 0: 
		return 0
	
	var remaining = _amount
	var index := find_item(name)
	if index == -1:
		_logger.warn("Failed remove data [color=green]%s (%d)[/color], become inventory have not this data!" % [name, remaining])
		return remaining
	
	var item := get_item(index) as ItemEntity
	remaining = item.remove_used_amount(_amount)
	item.decrease_total_amount(remaining)
	remaining = max(remaining - item.get_total_amount(), 0)
	
	if item.get_total_amount() <= 0:
		_remove_from_storage_entity(index)
	_logger.debug("Removed [color=green]%d (remaing %d)[/color] items [color=green]%s (%d)[/color]" % [_amount, remaining, name, item.get_total_amount()])
	return remaining


func has_data(name: String):
	return find_item(name) != -1


func has_item_amount(name: String, amount: int = 1) -> bool:
	amount = abs(amount)
	var index := find_item(name)
	if index != -1:
		return get_item(index).get_total_amount() >= amount
	return false #возвращается если предмета нет в инветоре


func find_item(item_name: String) -> int:
	if _stored_cache.has(item_name):
		return _stored_cache[item_name]
	return -1


func find_and_get_amount(item_name: String) -> int:
	var index = find_item(item_name)
	if index == -1:
		return 0
	return get_item(index).get_total_amount()


func get_item(index: int) -> ItemEntity:
	if is_index_validate(index):
		return inventory_entity.items[index]
	return null


func fetch_item(item_name: StringName) -> ItemEntity:
	return get_item(find_item(item_name))


func fetch_item_data(item_name: StringName) -> ItemResource:
	return fetch_item(item_name).get_resource()


func is_index_validate(index: int) -> bool:
	return index >= 0 and index < inventory_entity.items.size()


func get_or_create_item(data: ItemResource) -> ItemEntity:
	var index = find_item(data.code_name)
	if index == -1:
		return _add_in_storage_entity(ItemEntity.new(data))
	return get_item(index)


func _add_in_storage_entity(item: ItemEntity) -> ItemEntity:
	var _index: int = inventory_entity.items.size()
	inventory_entity.items.append(item)
	changed_inventory_entity.emit(inventory_entity)
	_stored_cache[item.get_resource().code_name] = _index
	item.changed_amount.connect(_on_changed_value.bind(item.get_resource().code_name))
	return item


func _remove_from_storage_entity(index: int) -> ItemEntity:
	if is_index_validate(index):
		var item: ItemEntity = inventory_entity.items.pop_at(index)
		_stored_cache.erase(item.get_resource().code_name)
		changed_inventory_entity.emit(inventory_entity)
		item.changed_amount.disconnect(_on_changed_value)
		return item
	return null


func _on_changed_value(value: int, index: String):
	if value <= 0:
		_remove_from_storage_entity(find_item(index))


func _recount_index_items(entity: InventoryEntity):
	for i in entity.items.size():
		_stored_cache[entity.items[i].get_resource().code_name] = i


func get_size() -> int: 
	if not inventory_entity: 
		return 0
	return inventory_entity.items.size()


func get_items() -> Array[ItemEntity]: 
	if not inventory_entity: 
		return []
	return inventory_entity.items.duplicate()


func clear_empty():
	if not inventory_entity:
		return
	var new_array: Array[ItemEntity] = []
	for i in inventory_entity.items.size():
		if inventory_entity.items[i].is_empty(): continue
		new_array.append(inventory_entity.items[i])
	return new_array
