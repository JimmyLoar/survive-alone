@tool
class_name SearchDrop
extends MyResource

@export_range(1, 12, 1) var items_count := 4:
	set(value):
		items_count = value
		_items.resize(value)
		_items.map(func(element: Array): element.resize(4); return element)
		notify_property_list_changed()

@export_storage var _items: Array[Array] = [[]]

func _init() -> void:
	super("SEARCH_DROP")


func get_items() -> Array[Array]:
	return _items.duplicate()


enum Value{DATA, REWARD, CHANCE, REDUCTION}
func get_value(index: int, value_type: Value):
	return _get_item_value(_items[index], value_type)


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	for i in items_count:
		properties.append_array(_get_item_properties(i))
	return properties


func _get_item_properties(index: int):
	var properties: Array[Dictionary] = []
	properties.append(PropertyGenerater.take_resource("item_%02d/data" % [index + 1], "ItemData"))
	properties.append(PropertyGenerater.take_float("item_%02d/reward_count" % [index + 1], [1, 3, 0.01, "or_greater"]))
	properties.append(PropertyGenerater.take_float("item_%02d/chance_base" % [index + 1], [0, 1, 0.01, "or_greater"]))
	properties.append(PropertyGenerater.take_float("item_%02d/reduction_rate" % [index + 1], [1, 2, 0.001, "or_greater"]))
	return properties


func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with("item"):
		var index := property.get_slice("/", 0).to_int() - 1
		match property.get_slice('/', 1):
			"data": _set_item_value(_items[index], Value.DATA, value)
			"reward_count": _set_item_value(_items[index], Value.REWARD, value)
			"chance_base": _set_item_value(_items[index], Value.CHANCE, value)
			"reduction_rate": _set_item_value(_items[index], Value.REDUCTION, value)
		return true
	return false


func _set_item_value(item: Array, value_type: Value, value):
	item[value_type] = value


func _get(property: StringName):
	if property.begins_with("item"):
		var index := property.get_slice("/", 0).to_int() - 1
		match property.get_slice('/', 1):
			"data": return _get_item_value(_items[index], Value.DATA)
			"reward_count": return _get_item_value(_items[index], Value.REWARD)
			"chance_base": return _get_item_value(_items[index], Value.CHANCE)
			"reduction_rate": return _get_item_value(_items[index], Value.REDUCTION)
			_: return _items[index]


func _get_item_value(item: Array, value_type: Value):
	return item[value_type]
