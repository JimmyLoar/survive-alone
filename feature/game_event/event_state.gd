class_name EventState
extends Injectable

signal started_event(event: EventResource)
signal finished_stage(event_node: EventNode)
signal finished_event(event: EventResource)


var _node: EventDisplay
var _events: Array[EventResource] = []


func _init(_new_node: EventDisplay) -> void:
	_node = _new_node


func start_event(event: EventResource):
	_node.display(event)
	event.start()
	started_event.emit(event)


func clear():
	_events.clear()


func set_events(events: Array[EventResource]) -> void:
	clear()
	_events.assign(_events)


func get_events() -> Array[EventResource]:
	return _events


func serialize() -> Array:
	var result := []
	for event in _events:
		result.append({
			path = event.get_resource_path(),
			data = event.serialize(),
		})
	return result


func deserialize(data: Array) -> void:
	clear()
	for serialized_event in data:
		var event := load(serialized_event.path) as EventResource
		var instance := event.instantiate()
		instance.deserialize(serialized_event.data)
		_events.append(instance)
