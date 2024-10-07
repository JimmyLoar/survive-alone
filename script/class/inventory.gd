class_name Inventory
extends RefCounted

signal changed

const SLOT = {
			"used": [],
			"item": null,
			"new_amount": 0,
		}

var _items := Dictionary()


func add_new_item():
	pass


func add_item(item: Item):
	var slot: Dictionary = {}
	var key: String = item.name.to_lower()
	if not _items.has(key):
		slot = SLOT.duplicate()
		slot.item = Item.get_new_item(item)
	
	else:
		slot = _items[key]
	
	if item.is_used():
		slot.used = [item]
	
	else: 
		slot.new_amount += 1
	 
	_items[key] = slot
	changed.emit(self)


func add_any_items(items: Array[Item]):
	for _item in items:
		add_item(_item)


func remove_item(key: StringName, index: int = 0):
	pass


func get_item(key: StringName) -> Item:
	if _items.has(key):
		var slot: Dictionary = _items[key]
		if not slot.used.is_empty():
			return slot.used.front()
		return slot.item
	return null


func get_item_count(key: StringName):
	if _items.has(key):
		var slot: Dictionary = _items[key]
		return slot.used.size() + slot.new_amount - 1
	return -1
