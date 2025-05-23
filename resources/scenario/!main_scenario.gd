var quests := Questify
var events := EventsGlobal

const scenarios := [
	preload("res://resources/scenario/prologue.gd"),
]


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


func _on_condition_query_requested(type: String, key: String, value: Variant, requester: QuestCondition):
	pass


func _on_quest_started(quest: QuestResource):
	pass


func _on_quest_objective_added(quest: QuestResource, objective: QuestObjective):
	pass


func _on_quest_objective_completed(quest: QuestResource, objective: QuestObjective):
	pass


func _on_quest_completed(quest: QuestResource):
	pass




func _on_started_event(event: EventResource):
	pass


func _on_aborted_event():
	pass


func _on_completed_event():
	pass


func _on_completed_stage():
	pass
