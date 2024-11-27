@tool
class_name SearchDrop
extends MyResource

@export_range(1, 12, 1) var items_count := 4:
	set(value):
		items_count = value
		_items.resize(value)
		_items.map(func(element: Array): element.resize(3); return element)
		notify_property_list_changed()

@export_storage var _items: Array[Array] = [[]]

func _init() -> void:
	_resource_type = "SEARCH_DROP"

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	for i in items_count:
		properties.append_array(_get_item_properties(i))
	return properties


func _get_item_properties(index: int):
	var properties: Array[Dictionary] = []
	properties.append(PropertyGenerater.take_resource("item_%02d/data" % [index + 1], "ItemData"))
	properties.append(PropertyGenerater.take_float("item_%02d/chance_base" % [index + 1], [0, 1, 0.01, "or_greater"]))
	properties.append(PropertyGenerater.take_float("item_%02d/reduction_rate" % [index + 1], [1, 2, 0.001, "or_greater"]))
	return properties


func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with("item"):
		var index := property.get_slice("/", 0).to_int() - 1
		match property.get_slice('/', 1):
			"data": 
				_items[index][0] = value
				_items.push_back([])
				notify_property_list_changed()
			"chance_base": _items[index][1] = value
			"reduction_rate": _items[index][2] = value
		return true
	return false


func _get(property: StringName):
	if property.begins_with("item"):
		var index := property.get_slice("/", 0).to_int() - 1
		match property.get_slice('/', 1):
			"data": return _items[index][0]
			"chance_base": return _items[index][1]
			"reduction_rate": return _items[index][2]
			_: return _items[index]
