@tool
class_name SearchDropResource
extends NamedResource

@export_range(0, 12, 1) var items_count := 4:
	set(value):
		items_count = value
		_items.resize(value)
		_items.map(func(element: Array): element.resize(4) ; return element)
		notify_property_list_changed()

@export_storage var _items: Array[Array] = [[]]


func _init() -> void:
	super("SEARCH_DROP")


func get_items() -> Array[Array]:
	var items: Array[Array] = _items.duplicate()
	items.resize(items_count)
	return items


enum Value { DATA, REWARD, CHANCE, REDUCTION }


func get_value(index: int, value_type: Value):
	return _get_item_value(_items[index], value_type)


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	for i in items_count:
		properties.append_array(_get_item_properties(i))
	return properties


func _get_item_properties(index: int):
	var properties: Array[Dictionary] = []
	properties.append(
		PropertyGenerater.convert_to_enum(
			PropertyGenerater.take_string("item_%02d/data" % [index + 1]),
			",".join(ResourceCollector.items.keys())
		)
	)

	var _property := PropertyGenerater.take_float("item_%02d/reward_count" % [index + 1])
	properties.append(PropertyGenerater.convent_to_range(_property, 1, 3, 0.01, "or_greater"))

	_property = PropertyGenerater.take_float("item_%02d/chance_base" % [index + 1])
	properties.append(PropertyGenerater.convent_to_range(_property, 0, 1, 0.01, "or_greater"))

	_property = PropertyGenerater.take_float("item_%02d/reduction_rate" % [index + 1])
	properties.append(PropertyGenerater.convent_to_range(_property, 1, 2, 0.001, "or_greater"))
	return properties


func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with("item"):
		var index := property.get_slice("/", 0).to_int() - 1
		match property.get_slice("/", 1):
			"data":
				_set_item_value(_items[index], Value.DATA, value)
			"reward_count":
				_set_item_value(_items[index], Value.REWARD, value)
			"chance_base":
				_set_item_value(_items[index], Value.CHANCE, value)
			"reduction_rate":
				_set_item_value(_items[index], Value.REDUCTION, value)
		return true
	return false


func _set_item_value(item: Array, value_type: Value, value):
	item[value_type] = value


func _get(property: StringName):
	if property.begins_with("item"):
		var index := property.get_slice("/", 0).to_int() - 1
		match property.get_slice("/", 1):
			"data":
				return _get_item_value(_items[index], Value.DATA)
			"reward_count":
				return _get_item_value(_items[index], Value.REWARD)
			"chance_base":
				return _get_item_value(_items[index], Value.CHANCE)
			"reduction_rate":
				return _get_item_value(_items[index], Value.REDUCTION)
			_:
				return _items[index]


func _get_item_value(item: Array, value_type: Value):
	return item[value_type]


static var NONE_UID = ResourceUID.text_to_id("uid://56f1qivn2r5c")


static func get_none():
	return load(ResourceUID.get_id_path(NONE_UID))


static func merge(serch_drops: Array) -> SearchDropResource:
	var result = SearchDropResource.new()

	var items = []

	for serch_drop in serch_drops:
		for search_drop_item in serch_drop._items:
			items.push_back(search_drop_item)

	result.items_count = items.size()
	result.items = items
	return result
