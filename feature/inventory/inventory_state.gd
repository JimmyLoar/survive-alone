class_name InventoryState
extends Injectable

signal changed_inventory_entity(new_entity: InventoryEntity)

var name: String
var inventory_entity: InventoryEntity = InventoryEntity.new(): set = change_entity

var _inventory_repository: InventoryRepository
var _stored_cache: Dictionary = {}
var _logger: Log 


func _init(new_name := "InventoryState") -> void:
	name = new_name
	_logger = Log.get_global_logger().with("Inventory%sState " % new_name)
	changed_inventory_entity.connect(_recount_index_items)


func change_entity(_new_entity: InventoryEntity) -> InventoryEntity:
	var tmp = inventory_entity
	inventory_entity = _new_entity
	
	var _get_names: Callable = func(item: ItemEntity):
		return item.get_resource().name_key 
	
	changed_inventory_entity.emit(_new_entity)
	return tmp


func add_item(data: ItemResource, value := 0, used: Array = []) -> ItemEntity:
	var found_index = find_item(data.name_key)
	if found_index != -1:
		var item = get_item(found_index)
		item.change_amount(value)
		item.append_used(used)
		_logger.debug("Added [color=green]%d (used +%d)[/color] items [color=green]%s[/color] in exist item with index [color=green]%d[/color]" % 
			[value, used.size(), data.name_key, found_index])
		return item
	
	_logger.debug("Added [color=green]%d (used +%d)[/color] items [color=green]%s[/color] in new item, with index [color=green]%s[/color]" % 
		[value, used.size(), data.name_key, inventory_entity.items.size()])
	return _add_in_storage_entity(ItemEntity.new(data, value, used))


func remove_item(data: ItemResource, _amount := 1):
	var amount = _amount
	var index := find_item(data.name_key)
	if index == -1:
		_logger.warn("Failed remove data [color=green]%s (%d)[/color], become inventory have not this data!" % [data.name_key, amount])
		return amount
	
	var item := get_item(index)
	amount = item.remove_used_amount(amount)
	item.change_amount(amount * -1)
	amount = max(amount - item.get_amount(), 0)
	
	if item.get_total_amount() <= 0:
		_remove_from_storage_entity(index)
	_logger.debug("Removed [color=green]%d (reaming %d)[/color] items [color=green]%s (%d)[/color]" % [_amount - amount, amount, data.name_key, item.get_total_amount()])
	return amount


func has_item(data: ItemResource) -> bool:
	return find_item(data.name) != -1


func has_item_amount(data: ItemResource, amount: int = 1) -> bool:
	amount = abs(amount)
	var index := find_item(data.name_key)
	if index != -1:
		return get_item(index).get_total_amount() >= amount
	return false #возвращается если предмета нет в инветоре


func find_item(item_name: StringName) -> int:
	if _stored_cache.has(item_name):
		return _stored_cache[item_name]
	return -1


func get_item(index: int) -> ItemEntity:
	if is_index_validate(index):
		return inventory_entity.items[index]
	return null


func fetch_item(item_name: String):
	return get_item(find_item(item_name))


func is_index_validate(index: int) -> bool:
	return index >= 0 and index < inventory_entity.items.size()


func get_or_create_item(data: ItemResource) -> ItemEntity:
	var index = find_item(data.name_key)
	if index == -1:
		return _add_in_storage_entity(ItemEntity.new(data))
	return get_item(index)


func _add_in_storage_entity(item: ItemEntity) -> ItemEntity:
	var _index: int = inventory_entity.items.size()
	inventory_entity.items.append(item)
	_stored_cache[item.get_resource().name_key] = _index
	changed_inventory_entity.emit(inventory_entity)
	return item


func _remove_from_storage_entity(index: int) -> ItemEntity:
	if is_index_validate(index):
		var item: ItemEntity = inventory_entity.items.pop_at(index)
		item._index = -1
		item._inventory = ""
		_stored_cache.erase(item.get_resource().name_key)
		changed_inventory_entity.emit(inventory_entity)
		return item
	return null


func _recount_index_items(entity: InventoryEntity):
	for i in entity.items.size():
		_stored_cache[entity.items[i].get_resource().name_key] = i


func get_size() -> int: 
	if not inventory_entity: 
		return 0
	return inventory_entity.items.size()


#Todo erise_empty - сайд эфект в функции. Выглядит что нужно убрать и вместо этого в местах вызова get_items явно вызывать публичный аналог _clear_empty
# get функции не должны делать доп работу. Только возвращать что просят
func get_items(erise_empty := false) -> Array[ItemEntity]: 
	if not inventory_entity: 
		return []
	if erise_empty:
		return _clear_empty(inventory_entity.items.duplicate())
	return inventory_entity.items.duplicate()


func _clear_empty(_array: Array[ItemEntity] = inventory_entity.items.duplicate()):
	var new_array: Array[ItemEntity] = [] 
	for i in _array.size():
		if _array[i].is_empty(): continue
		new_array.append(_array[i])
	return new_array
