class_name RestScreenState
extends Injectable

var _node


func _init(node) -> void:
	_node = node


var _delta_thirst = 0
var _delta_hunger = 0
var _delta_exhaustion = 0
var _delta_fatigue = 0

var _selected_time = 60


func open() -> void:
	_node.open()
