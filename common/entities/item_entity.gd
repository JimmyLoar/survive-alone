class_name ItemEntity
extends RefCounted

signal changed_amount(amount_value: int)
signal changed_durability(currect_durability: int)


var _resource: ItemResource
var _not_used_amount: int = 0
var _used: Array[int] = []: set = set_used


func _init(new_resource: ItemResource, new_amount := 0, new_used := []) -> void:
	_resource = new_resource
	_not_used_amount = new_amount
	set_used(new_used)


func set_used(new_used: Array):
	_used = Array(new_used, TYPE_INT, "", null)
	changed_amount.emit(get_total_amount())


func get_resource() -> ItemResource: return _resource
func get_not_used_amount() -> int: return _not_used_amount
func get_used() -> Array: return _used.duplicate()


func is_empty():
	return get_total_amount() <= 0


func get_total_amount() -> int:
	return _used.size() + _not_used_amount


func change_amount(delta_value: int):
	_not_used_amount += delta_value
	changed_amount.emit(get_total_amount())
	return _not_used_amount


func change_durability(total_value: int):
	var start_amount := get_total_amount()
	var reaming = total_value
	var loopbreak := 120
	while reaming > 0 and get_total_amount() > 0 and loopbreak > 0:
		if _used.is_empty():
			_used.append(_resource.durability)
			_not_used_amount -= 1
		reaming = reaming + _used[0]
		if reaming >= 0:
			_used.remove_at(0)
		else:
			_used[0] = min(abs(reaming), _resource.durability)
		loopbreak -= 1
	
	if start_amount != get_total_amount():
		changed_amount.emit(get_total_amount())
	
	changed_durability.emit(_used.front())


func append_used(new_used: Array):
	for i in new_used:
		if i <= 0: continue
		_used.append(i)
	changed_amount.emit(get_total_amount())


func remove_used_amount(amount: int) -> int:
	amount = max(amount - _used.size(), 0)
	_used = _used.slice(amount, _used.size(), 1)
	changed_amount.emit(get_total_amount())
	return amount
