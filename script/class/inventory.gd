class_name Inventory
extends RefCounted

signal changed(inv: Inventory)

const SLOT = {
			"used": [],
			"item": null,
			"amount": 0,
		}

var _slots := Dictionary()


func _init(items_list: Array[ItemData] = []) -> void:
	for item in items_list:
		add_item(item, item.durability)


func get_size() -> int:
	return _slots.keys().size()


func add_item(item: ItemData, durability := -1):
	var slot: Dictionary = {}
	var key: String = item.name.to_lower()
	if not _slots.has(key):
		slot = SLOT.duplicate()
		slot.item = item
	
	else:
		slot = _slots[key]
	
	if durability != item.durability or durability != -1:
		slot.used = [item]
	
	else: 
		slot.amount += 1
	 
	_slots[key] = slot
	changed.emit(self)


func add_any_items(items: Array[ItemData]):
	for _item in items:
		add_item(_item)


func remove_item(key: StringName, index: int = 0):
	pass


func get_item(key: StringName) -> ItemData:
	if _slots.has(key):
		var slot: Dictionary = _slots[key]
		if not slot.used.is_empty():
			return slot.used.front()
		return slot.item
	return null


func get_slots() -> Dictionary:
	return _slots


func get_slots_list() -> Array:
	return _slots.values()


func get_item_count(key: StringName):
	if _slots.has(key):
		var slot: Dictionary = _slots[key]
		return slot.used.size() + slot.amount
	return -1
