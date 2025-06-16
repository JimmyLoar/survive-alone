class_name InventoryCharacterState
extends Inventory

signal item_removed(item_name: String)
signal item_added(item_name: String)


func remove_item(_name: String, _amount := 1):
	var res = super(_name, _amount)
	item_removed.emit(name)
	return res


func add_item(uid: String, value: Variant = 0) -> ItemEntity:
	var res = super(uid, value) as ItemEntity
	item_added.emit(load(uid).code_name)
	return res
