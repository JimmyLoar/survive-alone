class_name EventSelecter
extends Resource

enum Type{
	linear,
	random,
	random_weight,
}

@export var select_type := Type.random
@export var events_list: Array[EventResource] = []
@export_range(0.001, 1.0, 0.001) var chance_get_event := 1.0

var _weights: PackedInt32Array = []
var _last_index := 0


func get_event() -> EventResource:
	if randf() > chance_get_event:
		return null
	
	match select_type:
		Type.linear: 
			_last_index = wrapi(_last_index + 1, 0, events_list.size())
		
		Type.random: 
			_last_index = randi_range(0, events_list.size() - 1)
		
		Type.random_weight: 
			_last_index = 0
		
	return events_list[_last_index]


func get_last_event() -> EventResource:
	if _last_index < 0:
		return null
	return events_list[_last_index]


func _get_weight():
	_last_index
	return
