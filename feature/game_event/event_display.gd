class_name EventDisplay
extends PanelContainer

@onready var texture_rect: TextureRect = %TextureRect
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var action_list: ItemList = %ActionList
@onready var result_list: ItemList = %ResultList
@onready var hint_container: VBoxContainer = %HintContainer

@onready var action_state := Locator.get_service(ActionState) as ActionState
@onready var resource_db := Locator.get_service(ResourceDb) as ResourceDb


var _state: EventState
var _execute_keeper: ExecuteKeeperState

var currect_event: EventResource
var currect_stages: Array[EventNode]
var _result: Dictionary


func _enter_tree() -> void:
	_state = Locator.initialize_service(EventState, [self]) as EventState
	_execute_keeper = Locator.get_service(ExecuteKeeperState)


func _ready() -> void:
	Questify.condition_query_requested.connect(_on_condition_query_requested)
	action_list.item_selected.connect(_on_action_pressed)
	action_list.action_state = action_state
	%ResultContainer.hide()
	%HintContainer.hide()
	if true: ## TODO Change on condition "new_game"
		_state.start_event(preload("res://resources/collection/events/prologue/event_prologue_1.tres").instantiate())
	
	else:
		self.hide()	




func display(event: EventResource):
	if event.completed:
		hide()
		return
	
	currect_event = event
	currect_stages = currect_event.get_active_nodes()
	_display_stage(currect_stages.back())
	self.show()


var actions: Array[EventAction]
func _display_stage(stage: EventNode):
	#print("displayed stage '%s'" % stage.id)
	if stage is EventMonologue:
		_update_monologue(stage)
	
	elif  stage is EventDialogue:
		_update_dialogue(stage)
	
	else:
		rich_text_label.text = currect_event.description
	
	actions = currect_event.get_next_actions(stage)
	action_list.update_actions(_validate_action(actions))
	_display_result(_result)


func _validate_action(actions: Array[EventAction]) -> Array[EventAction]:
	var new_actions: Array[EventAction] = []
	for action in actions:
		var _p = action.previous
		var condition = action.previous.filter(func(e): return e is EventCondition)
		var _valide = _valide_conditions(condition)
		action.set_meta("disabled", not _valide)
		if not (action.is_hidden and not _valide):
			new_actions.append(action)
	return new_actions


func _valide_conditions(array: Array) -> bool:
	var result = true
	for x: EventCondition in array:
		for xx in x.conditions:
			var _r = _execute_keeper.execute(xx)
			result = result && _r
	return result


func _update_monologue(stage: EventMonologue):
	rich_text_label.text = TranslationServer.translate("EVENT_MONOLOGUE_" + stage.text.to_upper())
	

func _update_dialogue(stage: EventDialogue):
	var text = ''
	for paragraph in stage.dialogues:
		text += "[b]DIALOGUE_CHARACTER_%s_NAME[/b]:\n" % [paragraph[0].name.to_upper()]
		text += "EVENT_DIALOGUE_%s\n\n" % [paragraph[1].to_upper()]
	rich_text_label.text = text


func _on_action_pressed(pressed_index: int):
	var action := actions[pressed_index] as EventAction
	currect_event.action_press(action)
	
	var effects = action._graph.get_previous_nodes(action, 1).filter(func(e): return e is EventEffect)
	_result = _apply_effect(effects)
	
	var _next = currect_event.get_next_nodes(action, EventEdge.EdgeType.ACTION)
	if _next.any(func(a): return a is EventAbort):
		hide()
		EventsGlobal.aborted_event.emit(currect_event)
		return
	
	for stage in currect_stages:
		if not stage is EventStage:
			continue
		currect_event.complete_stage(stage)
	display(currect_event)


func _apply_effect(array: Array) -> Dictionary:
	var result = {}
	for effect: EventEffect in array:
		for eff: ExecuteKeeperResource in effect.effects:
			result[eff] = _execute_keeper.execute(eff)
	return result


func _display_result(result: Dictionary):
	if result.is_empty():
		%ResultContainer.hide()
		return
	
	%ResultList.clear()
	for data: ExecuteKeeperResource in result.keys():
		var collection := ""
		if data.name.contains("item"):
			collection = "items"
		
		elif  data.name.contains("property"):
			collection = "properties"
		
		else:
			continue
		
		var _name: String = "%d" % data.args_data[1]
		var icon: Texture2D = resource_db.connection.fetch_data(collection, StringName(data.args_data[0])).texture
		var index = %ResultList.add_item("%s" % result[data], icon)
		%ResultList.set_item_tooltip(index, data.args_data[0])
	
	%ResultContainer.show()


func _on_condition_query_requested(type: String, key: String, value: Variant, requester: QuestCondition):
	if type != "event":
		return
	
	var result = false
	match key:
		"finished": 
			var _value = _state.get_completed_events().find_custom(
				func(event: EventResource): return event.name == value
			)
			result = _value != -1
	requester.set_completed(result)
