class_name Inventory
extends RefCounted

signal changed()

var database = load(ProjectSettings.get_setting("resource_databases/main_base_path", "res://database.gddb"))
var name: String

var _storage: Array[InventorySlot] = []
var _stored_cache: Dictionary = {}
var _logger: Log


func _init(new_name := "Inventory") -> void:
	name = new_name
	changed.connect(_recount_index_slots)
	_logger = GodotLogger.with("Inventory [color=green]%s[/color]" % self.name)


func add_item(data: ItemData, value := 0, used: Array = []) -> InventorySlot:
	var found_index = find_slot(data.name)
	if found_index != -1:
		var slot = get_slot(found_index)
		slot.change_amount(value)
		slot.append_used(used)
		_logger.debug("Added [color=green]%d[/color] items [color=green]%s[/color] in exist slot [color=green]%d[/color]" % [value, data.name, found_index])
		return slot
	
	_logger.debug("Added [color=green]%d[/color] items [color=green]%s[/color] in new slot" % [value, data.name])
	return _add_in_storage(InventorySlot.new(data, value))


func has_item(item: ItemData) -> bool:
	return find_slot(item.name) != -1


func find_slot(item_name: StringName) -> int:
	if _stored_cache.has(item_name):
		return _stored_cache[item_name]
	return -1


func get_slot(index: int) -> InventorySlot:
	if is_index_validate(index):
		return _storage[index]
	return null


func is_index_validate(index: int) -> bool:
	return index >= 0 and index < _storage.size()


func get_or_create_slot(item: ItemData) -> InventorySlot:
	var index = find_slot(item.name)
	if index == -1:
		return _add_in_storage(InventorySlot.new(item))
	return get_slot(index)


func _add_in_storage(slot: InventorySlot) -> InventorySlot:
	slot._index = _storage.size()
	slot._inventory = self.name
	_storage.append(slot)
	_stored_cache[slot.get_data().name] = slot._index
	call_deferred("emit_signal", "changed")
	_logger.debug("Added slot [color=green]%s[/color] with [color=green]%s[/color] index" % [slot.get_data().name, slot._index])
	return slot


func _remove_from_storage(index: int) -> InventorySlot:
	if is_index_validate(index):
		var slot: InventorySlot = _storage.pop_at(index)
		slot._index = -1
		slot._inventory = ""
		_stored_cache.erase(slot.get_data().name)
		call_deferred("emit_signal", "changed")
		return slot
	return null


func _recount_index_slots():
	for i in _storage.size():
		_storage[i]._index = i
		_stored_cache[_storage[i]._data.name] = i


func get_slots() -> Array[InventorySlot]: return _storage.duplicate()
func get_size() -> int: return _storage.size()
