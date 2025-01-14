@tool
class_name ChangeItemsAction
extends IAction

@export_custom(PROPERTY_HINT_TYPE_STRING, "24/17:ItemResource", #TYPE_OBJECT/PROPERTY_HINT_RESOURCE_TYPE:"ItemResource"
		PROPERTY_USAGE_DEFAULT - PROPERTY_USAGE_STORAGE
	) var require_items: Array[ItemResource] = []:
	set(value):
		require_items = value
		if value.is_empty(): return
		require_items_amount = _update_items_amount(require_items)
@export var require_items_amount: Dictionary = {}


@export_custom(PROPERTY_HINT_TYPE_STRING, "24/17:ItemResource", #TYPE_OBJECT/PROPERTY_HINT_RESOURCE_TYPE:"ItemResource"
		PROPERTY_USAGE_DEFAULT - PROPERTY_USAGE_STORAGE
	) var receive_items: Array[ItemResource] = []:
	set(value):
		receive_items = value
		if value.is_empty(): return
		receive_items_amount = _update_items_amount(receive_items)
@export var receive_items_amount: Dictionary = {}


var database: Database


func _update_items_amount(items: Array[ItemResource]):
	var dictionary := {}
	for data: ItemResource in items:
		if not data: continue
		dictionary[data.name_key] = 1
	return dictionary


func set_dependence(objects: Array): #virtual
	database = objects[0]
	_dependence = [] as Array[InventoryState]
	for i in objects.size():
		if i == 0: continue
		var inv: InventoryState = objects[i]
		if not inv: continue
		_dependence.append(objects[i])


func execute(): #virtual
	Log.get_global_logger().debug("[color=orangered]ChangeItemAction[/color] | Start execute!")
	if _has_items():
		_remove_items()
		_add_items()
		Log.get_global_logger().debug("succes!")


func _add_items():
	for key in receive_items_amount:
		var data: ItemResource = database.fetch_data_string("items/%s" % key)
		var inv: InventoryState = _dependence[0]
		inv.add_item(data, receive_items_amount[key])


func _remove_items():
	for key in require_items_amount:
		var data: ItemResource = database.fetch_data_string("items/%s" % key)
		var reaming: int = require_items_amount[key]
		for inv: InventoryState in _dependence:
			if reaming <= 0: continue
			reaming = inv.remove_item(data, reaming)


func _has_items() -> bool:
	var result := true
	for key: String in require_items_amount.keys():
		var items := 0
		for inv: InventoryState in _dependence:
			var item: ItemEntity = inv.fetch_item(key)
			if not item: continue
			items += item.get_total_amount()
		result = result and items >= require_items_amount[key]
	return result
