class_name DurabilityStorageComponent
extends StorageComponent

enum Mode{
	LOW_FIRST,
	HIGHT_FIRST,
	RANDOM,
	LOW_FIRST_SAFE,
	HIGHT_FIST_SAFE,
}

@export var remove_mode: Mode

var max_durability := -1
var durabilities: Array[int] = []
var _total_durability: int = 0
var _need_sorted := false


func apply(entity: ItemEntity) -> ItemEntity:
	var res := entity.get_resource() as ItemResource
	max_durability = res.durability_max
	remove_mode = res.durability_mode
	return super(entity)


func get_amount() -> int:
	return durabilities.size()


func append(value: Variant):
	if typeof(value) == TYPE_INT:
		append_durability(value)
		return
	
	_need_sorted = true
	value.map(func(elm): 
		elm = abs(elm)
		_total_durability += elm
		durabilities.append(clamp(elm, 1, max_durability))
		return 0
	)
	durabilities.sort()
	last_changed_quantity = value.size()
	quantity_changed.emit(last_changed_quantity)


func has(value: int):
	return _total_durability >= value


func remove(quantity: int) -> Array[int]:
	quantity = abs(quantity)
	var removed := durabilities.slice(0, quantity) as Array[int]
	durabilities = durabilities.slice(quantity)
	last_changed_quantity = -quantity
	quantity_changed.emit(last_changed_quantity)
	if durabilities.size() <= 0:
		request_to_delete.emit(owner)
	return removed


func append_durability(value: int, base: float = 0.5, offset: float = 0.25) -> Array[int]:
	var appended = _generate_array(abs(value), base, offset, max_durability) as Array[int]
	durabilities.append_array(appended)
	durabilities.sort()
	last_changed_quantity = appended.size()
	quantity_changed.emit(last_changed_quantity)
	return appended


static func _generate_array(value: int, base: float = 0.5, offset: float = 0.25, max_durability := 1) -> Array[int]:
	var appended = [] as Array[int]
	while value > 0:
		var _min = max(floor(max_durability * clampf(base - offset, 0, 1)), 1)
		var _max = max(ceil(max_durability * clampf(base + offset, 0, 1)), _min + 1)
		var item: int = min(randi_range(_min, _max), value)
		value -= item
		appended.append(item)
	return appended
	 


func remove_durability(value: int) -> Array[int]:
	var removed := [] as Array[int]
	while value > 0 and _total_durability > 0:
		var durability: int = durabilities.pop_front()
		removed.append(durability)
		value -= durability
	
	if value != 0:
		durabilities.append(abs(value))
	
	last_changed_quantity = -removed.size()
	quantity_changed.emit(last_changed_quantity)
	if durabilities.size() <= 0:
		request_to_delete.emit(owner)
	return removed


func serialize() -> Dictionary:
	var data = super()
	data.merge({
		"array": durabilities,
		"total": _total_durability,
	}, true)
	return data


func deserialize(data: Dictionary) -> void:
	super(data)
	_set_data(data, "durabilities", "array")
	_set_data(data, "_total_durability", "total")


func get_type_string() -> String:
	return "durability"
