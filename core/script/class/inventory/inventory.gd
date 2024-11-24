class_name Inventory
extends RefCounted

signal changed()
signal change_size(new_size: int)

var database = load(ProjectSettings.get_setting("resource_databases/main_base_path", "res://database.gddb"))
var name: String

var _storage: Array[InventorySlot] = []
var _stored_cache: Dictionary = {}
var _logger: Log


func _init(new_name := "Inventory") -> void:
	name = new_name
	_logger = GodotLogger.with(self.name)


func add_item(data: ItemData, value := 0) -> InventorySlot:
	var found_index = find_slot(data.name)
	if found_index != -1:
		var slot = get_slot(found_index)
		slot.change_amount(value)
		return slot
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


func _add_in_storage(slot: InventorySlot) -> InventorySlot:
	slot._index = _storage.size()
	_storage.append(slot)
	_stored_cache[slot.get_data().name] = slot._index
	_logger.debug("Added slot with '%s' item" % slot.get_data().name)
	return slot


func _remove_from_storage(index: int) -> InventorySlot:
	if is_index_validate(index):
		var slot: InventorySlot = _storage.pop_at(index)
		return slot
	return null
 

func get_slots() -> Array[InventorySlot]: return _storage.duplicate()
func get_size() -> int: return _storage.size()
