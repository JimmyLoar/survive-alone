class_name EventState
 

var _node: EventDisplay
var _events: Array[EventResource] = []
var global := EventsGlobal


func _init(_new_node: EventDisplay = null) -> void:
	_node = _new_node


func start_event(event_resource: EventResource) -> void:
	event_resource.start()
	_events.append(event_resource)
	_node.display.call_deferred(event_resource)
	EventsGlobal.started_event.emit(event_resource)


func update_events():
	for event in _events:
		event.update()


func clear() -> void:
	_events.clear()


func get_active_events() -> Array[EventResource]:
	var result: Array[EventResource] = []
	result.assign(_events.filter(
		func(event: EventResource):
			return event.started and not event.completed
	))
	return result


func get_completed_events() -> Array[EventResource]:
	var result: Array[EventResource] = []
	result.assign(_events.filter(
		func(event: EventResource):
			return event.completed
	))
	return result


func set_events(events: Array[EventResource]) -> void:
	clear()
	_events.assign(events)


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
