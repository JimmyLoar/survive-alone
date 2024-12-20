@tool
class_name ChangeItemsAction
extends IAction

@export_enum("Require:0", "Receive:1") var mode := 0
@export var items: Array[ItemData] = []:
	set(value):
		items = value
		_update_item_amount()
@export var items_amount: Dictionary = {}

func _update_item_amount():
	for data: ItemData in items:
		if not data: continue
		items_amount[data.name_key] = 0
	notify_property_list_changed()


func set_dependence(objects: Array): #virtual
	_dependence = []
	for i in objects.size():
		var inv: Inventory = objects[i]
		if not inv: continue
		_dependence.append(objects[i])


func execute(): #virtual
	for inv: Inventory in _dependence:
		for item in items:
			var amount = items_amount[item.name_key]
			match mode:
				0: _remove_item(inv, item, amount)
				1: _add_item(inv, item, amount)


func _add_item(inv: Inventory, item_data: ItemData, count: int = 1):
	inv.add_item(item_data, count)



func _remove_item(inv: Inventory, item_data: ItemData, count: int = 1):
	if inv.has_item_amount(item_data, count):
		inv.remove_item(item_data, count)
