class_name Inventory
extends RefCounted

signal changed(inv: Inventory)
signal change_size(new_size: int)

##TODO перерисать инвентарь на монер списка

const SLOT = {
			"used": [],
			"item": null,
			"amount": 0,
		}

var _slots: Array[Dictionary] = []
var _validate_index = func(index: int): 
	return index >= 0 and index < _slots.size()


func _init(items_list: Array[ItemData] = []) -> void:
	for item in items_list:
		add_item(item, item.durability)


func get_size() -> int:
	return _slots.size()


func add_item(item: ItemData, durability := -1, count := 1):
	var slot: Dictionary = {}
	var exist_index = find_item(item.name)
	if exist_index == -1:
		slot = SLOT.duplicate()
		slot.item = item
		_slots.insert(_slots.size(), slot)
	
	else:
		slot = _slots[exist_index]
	
	if durability != item.durability or durability != -1:
		slot.used = [item]
	
	else: 
		slot.amount += count
	
	changed.emit(self)
	change_size.emit(get_size())


func find_item(item_name: StringName) -> int:
	for i in _slots.size():
		if _slots[i].item.name != item_name:
			continue
		return i
	return -1


func remove_item(item: ItemData, first_used := true):
	var exist_index := find_item(item.name)
	if exist_index == -1: return
	var slot = _slots[exist_index]
	
	if slot.amount > 0:
		slot.amount -= 1
	
	elif slot.used.size() > 0:
		slot.used.remove_at(0)
	
	if slot.used.size() + slot.amount <= 0:
		_slots.erase(slot)
	
	change_size.emit(get_size())


func get_slot(index: int) -> Dictionary:
	if not _validate_index.call(index):
		breakpoint
		return {}
	
	return _slots[index]


func get_slots() -> Array:
	return _slots


func get_item_count(index: int):
	if _validate_index.call(index):
		var slot: Dictionary = _slots[index]
		return slot.used.size() + slot.amount
	return -1
