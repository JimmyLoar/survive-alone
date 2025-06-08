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


func append(value: Array[int]):
	_need_sorted = true
	value.map(func(elm): 
		_total_durability += elm
		durabilities.append(clamp(elm, 1, max_durability))
		return elm
	)
	last_change = value.size()
	quantity_changed.emit(last_change)


func has(value: int):
	return _total_durability >= value


func remove(value: int) -> Array[int]:
	var removed := [] as Array[int]
	while value > 0 and _total_durability > 0:
		var durability: int = durabilities.pop_front()
		removed.append(durability)
		value -= durability
	
	if value != 0:
		durabilities.append(abs(value))
	
	last_change = removed.size()
	quantity_changed.emit(last_change)
	return removed


func _get_element():
	if _need_sorted:
		durabilities.sort()
	match remove_mode:
		Mode.LOW_FIRST: 
			return durabilities.front()
		Mode.HIGHT_FIRST:
			return durabilities.back()
		Mode.RANDOM:
			return durabilities.pick_random()
		Mode.LOW_FIRST_SAFE:
			return durabilities.front()
		Mode.HIGHT_FIST_SAFE:
			return durabilities.back()


func serialize() -> Dictionary:
	return {}


func deserialize(data: Dictionary) -> void:
	pass


func get_type_string() -> String:
	return "durability"
