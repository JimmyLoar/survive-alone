class_name GameTimeState
extends Node

const STARTED_TIME = {
	"year": 2001,
	"month": 6, 
	"day": 4,
	"hour": 11,
	"minut": 23,
}

signal started_skip(value: int)
signal finished_step(delta: int)
signal finished_skip(remiang: int)


var decrease_by_step: int = 30:
	set(value):
		decrease_by_step = abs(value)
		assert(decrease_by_step == 0, "'decrease_by_step' cannot be zero!")


var _time := GameTimeEntity.new(GameTimeEntity.date_to_time(STARTED_TIME))
var _remiang_value: int = 0
var _node: Node


func _init(node: Node) -> void:
	_node = node


func start_skip(value: int):
	started_skip.emit(value)
	_remiang_value = value
	while _remiang_value > 0:
		do_step(decrease_by_step)
		await _node.get_tree().physics_frame
		_remiang_value -= decrease_by_step
	finish_skip(value)
	return true


func do_step(delta: int):
	_time._value += delta
	finished_step.emit(delta)


func finish_skip(_value: int = 0):
	_remiang_value = 0
	finished_skip.emit(_remiang_value)


func open():
	_node.open()
