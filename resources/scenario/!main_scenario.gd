class_name Scenario


const scenarios := {
	"prologue": preload("res://resources/scenario/prologue.gd"),
}


var quests := Questify
var events := EventsGlobal
var collector := ResourceCollector


func _init() -> void:
	quests.condition_query_requested.connect(_on_condition_query_requested)
	quests.quest_started.connect(_on_quest_started)
	quests.quest_objective_added.connect(_on_quest_objective_added)
	quests.quest_objective_completed.connect(_on_quest_objective_completed)
	quests.quest_completed.connect(_on_quest_completed)
	
	events.started_event.connect(_on_started_event)
	events.aborted_event.connect(_on_aborted_event)
	events.completed_event.connect(_on_completed_event)
	events.completed_stage.connect(_on_completed_stage)


func _on_quest_started(quest: QuestResource):
	pass


func _on_quest_objective_added(quest: QuestResource, objective: QuestObjective):
	pass


func _on_quest_objective_completed(quest: QuestResource, objective: QuestObjective):
	pass


func _on_quest_completed(quest: QuestResource):
	pass


func _on_condition_query_requested(type: String, key: String, value: Variant, requester: QuestCondition):
	match type:
		"change_location":
			Locator.get_service(CharacterLocationState).current_location_changed.connect(_on_changed_location.bind(key, value, requester))


func _on_changed_location(location, key: String, value: Variant, requester: QuestCondition):
	var result := true
	match key:
		"any": result = true
		"structure":
			if not is_instance_of(location, WorldObjectEntity):
				result = false
			else:
				result = location.id == value
		"biome":
			if is_instance_of(location, CharacterLocationState.BiomesLocation):
				pass
	
	requester.set_completed(result)
	if result:
		Locator.get_service(CharacterLocationState).current_location_changed.disconnect(_on_changed_location.bind(key, value, requester))




func _on_started_event(event: EventResource):
	pass


func _on_aborted_event(event: EventResource):
	pass


func _on_completed_event(event: EventResource):
	var next: Array
	for scen in scenarios.values():
		if not scen.has_event(event.name_key):
			continue
		
		next = scen.get_next("event", event.name_key)
		break
	
	for x in next:
		_start_next(x[0], x[1])


func _on_completed_stage(event_node: EventNode):
	pass



func _start_next(type: String, name: String):
	var resource = null
	match type:
		"quest": 
			resource = collector.find(ResourceCollector.Collection.QUESTS, name)
			quests.start_quest(resource.instantiate())
			quests.update_quests.call_deferred()
		"event": 
			resource = collector.find(ResourceCollector.Collection.EVENTS, name)
			events.start_quest(resource.instantiate())

	
































 
