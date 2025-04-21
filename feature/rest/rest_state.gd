class_name RestScreenState
 


var _node
var _delta_amount := PackedInt32Array([0, 0, 0, 0])


func _init(node) -> void:
	_node = node


func open() -> void:
	_node.open()


func reset():
	_delta_amount.fill(0)


func append_delta(index: int, value: int):
	printerr("%s) %d+%d=%d" % [index, _delta_amount[index], value, _delta_amount[index]+value])
	_delta_amount[index] += value


func get_delta(index: int, time: float) -> float:
	return get_amount_delta(index) / time


func get_amount_delta(index: int):
	return _delta_amount[index]
