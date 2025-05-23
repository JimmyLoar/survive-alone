@tool
extends Node
@warning_ignore_start('unused_signal')
signal started_event(event: EventResource)
signal aborted_event(event: EventResource)
signal completed_stage(event_node: EventNode)
signal completed_event(event: EventResource)
@warning_ignore_restore('unused_signal')
var event_name: String = ''


func start_event(event: EventResource):
	Locator.get_service(EventState).start_event(event)
