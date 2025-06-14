extends Node


signal condition_query_requested(type: QuestCondition.TypeVariants, key: String, value: Variant, requester: QuestCondition)
signal quest_started(quest: QuestResource)
signal quest_objective_added(quest: QuestResource, objective: QuestObjective)
signal quest_objective_completed(quest: QuestResource, objective: QuestObjective)
signal quest_completed(quest: QuestResource)


var _quests: Array[QuestResource] = []
var _quest_update_timer: Timer
var _logger := Log.get_global_logger().with("Questify")


func _ready() -> void:
	if QuestifySettings.polling_enabled:
		_add_timer()
		_quest_update_timer.timeout.connect(update_quests)
	
	for quest in _quests:
		quest.start()
	
	condition_query_requested.connect(_on_condition_query_requested)


func start_quest(quest_resource: QuestResource) -> void:
	if not _quests.filter(func(quest): 
		return quest_resource.name_key == quest.name_key
	).is_empty():
		return
	
	_quests.append(quest_resource)
	quest_resource.start()
	_logger.debug("'%s' | started quest" % quest_resource.name)


func update_quests():
	for quest in _quests:
		quest.update()


func clear() -> void:
	_quests.clear()


func get_quests() -> Array[QuestResource]:
	return _quests


func get_active_quests() -> Array[QuestResource]:
	var result: Array[QuestResource] = []
	result.assign(_quests.filter(
		func(quest: QuestResource):
			return quest.started and not quest.completed
	))
	return result


func get_completed_quests() -> Array[QuestResource]:
	var result: Array[QuestResource] = []
	result.assign(_quests.filter(
		func(quest: QuestResource):
			return quest.completed
	))
	return result


func set_quests(quests: Array[QuestResource]) -> void:
	clear()
	_quests.assign(quests)


func serialize() -> Array:
	var result := []
	for quest in _quests:
		result.append({
			path = quest.get_resource_path(),
			data = quest.serialize(),
		})
	return result


func deserialize(data: Array) -> void:
	clear()
	for serialized_quest in data:
		var quest := load(serialized_quest.path) as QuestResource
		var instance := quest.instantiate()
		instance.deserialize(serialized_quest.data)
		_quests.append(instance)


func toggle_update_polling(value: bool) -> void:
	if QuestifySettings.polling_enabled:
		_quest_update_timer.paused = not value


func _add_timer() -> void:
	_quest_update_timer = Timer.new()
	_quest_update_timer.autostart = true
	_quest_update_timer.wait_time = QuestifySettings.polling_interval
	add_child(_quest_update_timer)


func _on_condition_query_requested(type: QuestCondition.TypeVariants, key: String, value: Variant, requester: QuestCondition):
	if type == QuestCondition.TypeVariants.none:
		requester.set_completed(true)
