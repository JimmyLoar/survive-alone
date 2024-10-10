class_name Inventory
extends RefCounted

signal changed(inv: Inventory)

const SLOT = {
			"used": [],
			"item": null,
			"new_amount": 0,
		}

var _items := Dictionary()


func _init(items_list: Array[ItemData] = []) -> void:
	for item in items_list:
		add_item(item, item.durability)


func get_size() -> int:
	return _items.keys().size()


func add_item(item: ItemData, durability := -1):
	var slot: Dictionary = {}
	var key: String = item.name.to_lower()
	if not _items.has(key):
		slot = SLOT.duplicate()
		slot.item = item
	
	else:
		slot = _items[key]
	
	if durability != item.durability or durability != -1:
		slot.used = [item]
	
	else: 
		slot.new_amount += 1
	 
	_items[key] = slot
	changed.emit(self)


func add_any_items(items: Array[ItemData]):
	for _item in items:
		add_item(_item)


func remove_item(key: StringName, index: int = 0):
	pass


func get_item(key: StringName) -> ItemData:
	if _items.has(key):
		var slot: Dictionary = _items[key]
		if not slot.used.is_empty():
			return slot.used.front()
		return slot.item
	return null


func get_items() -> Dictionary:
	return _items


func get_item_count(key: StringName):
	if _items.has(key):
		var slot: Dictionary = _items[key]
		return slot.used.size() + slot.new_amount
	return -1
