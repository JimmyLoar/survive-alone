class_name InventorySlot
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
	changed.emit()


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


func append_used(new_used: Array):
	_used.append_array(new_used)
	changed.emit(_index)
