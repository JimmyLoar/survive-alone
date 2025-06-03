@tool
extends Node
@warning_ignore_start('unused_signal')
signal started_event(event: EventResource)
signal aborted_event(event: EventResource)
signal completed_stage(event_node: EventNode)
signal completed_event(event: EventResource)
@warning_ignore_restore('unused_signal')
var event_name: String = ''


func _ready() -> void:
	(func():
		Questify.quest_completed.connect(activate_next)
		self.completed_event.connect(activate_next)
	).call_deferred()


func start_event(event: EventResource):
	Locator.get_service(EventState).start_event(event)


func activate_next(resource):
	var next: Array = resource.get_next()
	_start_next(next[0], next[1])


func _start_next(type: EventEnd.Next, name: String):
	var resource = null
	match type:
		EventEnd.Next.QUEST: 
			resource = ResourceCollector.find(ResourceCollector.Collection.QUESTS, name).instantiate() as QuestResource
			GodotLogger.debug("start new quest: ", resource.name_key)
			Questify.start_quest(resource)
			Questify.update_quests.call_deferred()
		
		EventEnd.Next.EVENT: 
			resource = ResourceCollector.find(ResourceCollector.Collection.EVENTS, name).instantiate() as EventResource
			GodotLogger.debug("start new event: ", resource.name_key)
			self.start_event(resource)
