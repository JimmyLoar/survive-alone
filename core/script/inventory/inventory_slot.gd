class_name InventorySlot
extends RefCounted

signal changed

var _data: ItemData
var _amount: int = 0
var _used: Array[int] = []
var _index: int = -1


func _init(new_data: ItemData, new_amount := 0, new_used := []) -> void:
	_data = new_data
	_amount = new_amount
	_used = Array(new_used, TYPE_INT, "", null)


func get_data(): return _data
func get_amount(): return _amount
func get_used(): return _used.duplicate()

func is_empty():
	return get_total_amount() <= 0


func get_total_amount() -> int:
	return _used.size() + _amount


func change_amount(delta_value: int):
	_amount += delta_value
	changed.emit(_index)


func append_used(new_used: Array):
	_used.append_array(new_used)
	changed.emit(_index)
