class_name EventList
extends Resource

var rng := RandomNumberGenerator.new() as RandomNumberGenerator


var events: Array[EventResource] = []: set = set_events


func set_events(value):
	events = value


func get_event() -> EventResource:
	return events[rng.randi_range(0, events.size() - 1)]
