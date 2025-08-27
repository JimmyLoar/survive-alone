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


var time := GameTimeEntity.new(GameTimeEntity.date_to_time(STARTED_TIME))
var decrease_by_step: int = 30:
	set(value):
		assert(value != 0, "'decrease_by_step' cannot be zero!")
		decrease_by_step = abs(value)

var _remiang_value: int = 0
var _node: Node


func _init(node: Node) -> void:
	_node = node


func timeskip(skipped_time: int, for_real_sec: float = 1.0, with_progress_screen := false, _callback: Callable = func():pass):
	decrease_by_step = ceil(float(skipped_time) / Engine.physics_ticks_per_second / for_real_sec)
	if with_progress_screen:
		_node.open()
	start_skip(skipped_time)


func start_skip(value: int):
	started_skip.emit(value)
	_remiang_value = value
	while _remiang_value > 0:
		do_step(decrease_by_step)
		if not _node.get_tree():
			do_step(_remiang_value)
			_remiang_value = 0
			break
		await _node.get_tree().physics_frame
		_remiang_value -= decrease_by_step
	finish_skip()
	return true


func do_step(delta: int):
	time._value += delta
	finished_step.emit(delta)


func finish_skip():
	finished_skip.emit(_remiang_value)
	_remiang_value = 0


func is_process():
	return _remiang_value != 0
