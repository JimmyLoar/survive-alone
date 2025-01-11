class_name InventoryState
extends RefCounted

signal changed()

var database = load(ProjectSettings.get_setting("resource_databases/main_base_path", "res://database.gddb"))
var name: String

var _storage: Array[ItemEntity] = []
var _stored_cache: Dictionary = {}
var _logger: Log


func _init(new_name := "InventoryState") -> void:
	name = new_name
	changed.connect(_recount_index_items)
	_logger = Log.get_global_logger().with("InventoryState [color=green]%s[/color]" % self.name)


func add_item(data: ItemResource, value := 0, used: Array = []) -> ItemEntity:
	var found_index = find_item(data.name_key)
	if found_index != -1:
		var item = get_item(found_index)
		item.change_amount(value)
		item.append_used(used)
		_logger.debug("Added [color=green]%d (+%d)[/color] items [color=green]%s[/color] in exist item [color=green]%d[/color]" % [value, used.size(), data.name_key, found_index])
		return item
	
	_logger.debug("Added [color=green]%d (+%d)[/color] items [color=green]%s[/color] in new item" % [value, used.size(), data.name_key])
	return _add_in_storage(ItemEntity.new(data, value, used))


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
		_remove_from_storage(index)
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
		return _storage[index]
	return null


func fetch_item(item_name: String):
	return get_item(find_item(item_name))


func is_index_validate(index: int) -> bool:
	return index >= 0 and index < _storage.size()


func get_or_create_item(data: ItemResource) -> ItemEntity:
	var index = find_item(data.name_key)
	if index == -1:
		return _add_in_storage(ItemEntity.new(data))
	return get_item(index)


func _add_in_storage(item: ItemEntity) -> ItemEntity:
	item._index = _storage.size()
	item._inventory = self.name
	_storage.append(item)
	_stored_cache[item.get_data().name_key] = item._index
	call_deferred("emit_signal", "changed")
	_logger.debug("Added item [color=green]%s[/color] with [color=green]%s[/color] index" % [item.get_data().name_key, item._index])
	return item


func _remove_from_storage(index: int) -> ItemEntity:
	if is_index_validate(index):
		var item: ItemEntity = _storage.pop_at(index)
		item._index = -1
		item._inventory = ""
		_stored_cache.erase(item.get_data().name_key)
		call_deferred("emit_signal", "changed")
		return item
	return null


func _recount_index_items():
	for i in _storage.size():
		_storage[i]._index = i
		_stored_cache[_storage[i]._data.name_key] = i


func get_size() -> int: return _storage.size()
func get_items(erise_empty := false) -> Array[ItemEntity]: 
	if erise_empty:
		return _clear_empty(_storage.duplicate())
	return _storage.duplicate()


func _clear_empty(_array: Array[ItemEntity] = _storage.duplicate()):
	var new_array: Array[ItemEntity] = [] 
	for i in _array.size():
		if _array[i].is_empty(): continue
		new_array.append(_array[i])
	return new_array
