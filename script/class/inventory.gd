class_name Inventory
extends RefCounted

signal changed()
signal change_size(new_size: int)


const SLOT = {
			"used": [],
			"item": null,
			"amount": 0,
		}


var _slots: Array[Dictionary] = []
var validate_index = func(index: int): 
	return index >= 0 and index < _slots.size()


func create_slot(item: ItemData, used = [], amount = 1) -> int:
	var slot = {
		"item": item,
		"used": used,
		"amount": amount,
	}
	return add_slot(slot)


func get_slot_and_create_if_not(item: ItemData, used = [], amount = 0) -> Dictionary:
	var index = find_slot(item.name)
	if index == -1:
		index = create_slot(item, used, amount)
	return get_slot(index)


func add_slot(new_slot: Dictionary) -> int:
	var index = find_slot(new_slot.item.name)
	if index != -1:
		append_to_slot(new_slot)
		call_deferred("emit_signal", "changed")
		return index
	
	_slots.push_back(new_slot)
	call_deferred("emit_signal", "change_size", get_size())
	call_deferred("emit_signal", "changed")
	return _slots.size() - 1

func append_to_slot(slot: Dictionary):
	add_item_amount(slot.item, slot.amount)
	append_used_items(slot.item, slot.used)


func remove_slot(index: int) -> Dictionary:
	if not validate_index.call(index):
		breakpoint
	call_deferred("emit_signal", "changed")
	call_deferred("emit_signal", "change_size", get_size())
	return _slots.pop_at(index)


func get_slot(index: int) -> Dictionary:
	if not validate_index.call(index):
		return {}
	return _slots[index]


func get_slots_list() -> Array[Dictionary]:
	return _slots.duplicate()


func get_slot_for_item(item: ItemData) -> Dictionary:
	var slot_index = find_slot(item.name)
	if slot_index == -1:
		slot_index = create_slot(item)
	return _slots[slot_index]


func find_slot(item_name: StringName) -> int:
	for i in _slots.size():
		if _slots[i].item.name != item_name:
			continue
		return i
	return -1


func add_miscellaneous_items(items: Array[ItemData]) -> void:
	for i in items:
		var slot = get_slot_for_item(i)
		slot.amount += 1


func append_used_items(item: ItemData, used : Array = []) -> void:
	var slot = get_slot_for_item(item)
	slot.used.append_array(used)
	changed.emit()


func add_used_value(item: ItemData, value: int = 1, is_carried := false) -> void:
	var slot = get_slot_for_item(item)
	var used: Array = slot.used
	used[0] = min(used[0] + value, item.durability)
	if used[0] >= item.durability and is_carried:
		used.remove_at(0)
		slot.amount += 1
	changed.emit()


func remove_used_value(item: ItemData, value: int = 1) -> void:
	var slot = get_slot_for_item(item)
	var value_min = fmod(value, item.durability)
	value -= value_min
	if value_min > slot.used[0]:
		value_min -= slot.used[0]
		slot.used.remove_at(0)
	
	slot.used[0] -= value_min
	slot.amount -= value
	changed.emit()


func set_item_amount(item: ItemData, new_amount: int = 1) -> void:
	var slot = get_slot_for_item(item)
	slot.amount = new_amount
	changed.emit()


func add_item_amount(item: ItemData, delta_amount: int = 1) -> void:
	var slot = get_slot_for_item(item)
	slot.amount = slot.amount + delta_amount
	if slot.amount <= 0:
		_slots.erase(slot)
		changed.emit()
		change_size.emit(get_size())
	
	GodotLogger.debug("change inventory slot '%s' amount on '%s' (%d)" %\
		[item.name, delta_amount, slot.amount])
	changed.emit()


func get_item_count(item: ItemData) -> int:
	var slot = get_slot_for_item(item)
	return slot.used.size() + slot.amount


func get_slot_size(index: int) -> int:
	var slot = get_slot(index)
	return slot.used.size() + slot.amount


func get_size() -> int:
	return _slots.size()


static func count_slot_size(slot: Dictionary) -> int:
	slot.merge(SLOT)
	return slot.used.size() + slot.amount
