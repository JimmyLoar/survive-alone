class_name Item
extends RefCounted

signal changed

var _inventory: String = ""
var _index: int = -1

var _data: ItemData
var _amount: int = 0
var _used: Array[int] = []: set = set_used


func _init(new_data: ItemData, new_amount := 0, new_used := []) -> void:
	_data = new_data
	_amount = new_amount
	set_used(new_used)


func set_used(new_used: Array):
	_used = Array(new_used, TYPE_INT, "", null)
	changed.emit(_index)


func get_data() -> ItemData: return _data
func get_amount() -> int: return _amount
func get_used() -> Array: return _used.duplicate()
func get_index() -> int: return _index
func get_inventory_name() -> String: return _inventory


func is_empty():
	return get_total_amount() <= 0


func get_total_amount() -> int:
	return _used.size() + _amount


func change_amount(delta_value: int):
	_amount += delta_value
	changed.emit(_index)


func change_durability(total_value: int):
	var reaming = total_value
	var loopbreak := 120
	GodotLogger.info("%s" % self)
	while reaming > 0 and get_total_amount() > 0 and loopbreak > 0:
		if _used.is_empty():
			_used.append(_data.durability)
			_amount -= 1
		reaming = reaming + _used[0]
		if reaming >= 0:
			_used.remove_at(0)
		else:
			_used[0] = min(abs(reaming), _data.durability)
		loopbreak -= 1
	
	changed.emit(_index)
	GodotLogger.info("%s" % self)


func append_used(new_used: Array):
	for i in new_used:
		if i <= 0: continue
		_used.append(i)
	changed.emit(_index)
