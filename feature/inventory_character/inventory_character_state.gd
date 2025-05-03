class_name InventoryCharacterState
extends InventoryState

signal item_removed(item_name: String)
signal item_added(item_name: String)


func remove_item(_name: String, _amount := 1):
	var res = super(_name, _amount)
	item_removed.emit(name)
	return res


func add_item(data: ItemResource, value := 0, used: Array = []) -> ItemEntity:
	var res = super(data, value, used)
	item_added.emit(data.code_name)
	return res
