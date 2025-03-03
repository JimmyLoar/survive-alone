class_name EventList
extends Resource

var rng := RandomNumberGenerator.new() as RandomNumberGenerator


@export var tags_list: Dictionary = {}
@export var events: Array[EventResource] = []: set = set_events


var _weights: PackedInt32Array
var _amount_weight := 0


func set_events(value):
	events = value


func get_event() -> EventResource:
	if events.is_empty():
		push_error("Events list is empty")
		return null
	return events[rng.randi_range(0, events.size() - 1)]
