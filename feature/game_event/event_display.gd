class_name EventDisplay
extends PanelContainer

@onready var texture_rect: TextureRect = %TextureRect
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var action_list: ItemList = %ActionList
@onready var result_list: ItemList = %ResultList
@onready var hint_container: VBoxContainer = %HintContainer

@onready var resource_db := Locator.get_service(ResourceDb) as ResourceDb


var _state: EventState

var currect_event: EventResource
var currect_stages: Array[EventNode]
var _result: Dictionary


func _enter_tree() -> void:
	_state = Locator.initialize_service(EventState, [self]) as EventState


func _ready() -> void:
	Questify.condition_query_requested.connect(_on_condition_query_requested)
	action_list.item_selected.connect(_on_action_pressed)
	%ResultContainer.hide()
	%HintContainer.hide()
	if true: ## TODO Change on condition "new_game"
		_state.start_event(preload("res://resources/collection/events/prologue/event_prologue_1.tres").instantiate())
	
	else:
		self.hide()	


func display(event: EventResource):
	if event.completed:
		close()
		return
	
	currect_event = event
	currect_stages = currect_event.get_active_nodes().filter(
		func(node: EventNode):
			return node is not EventStart 
	)
	_display_stage(currect_stages.front())
	self.show()


func close():
	currect_event = null
	currect_stages = []
	hide()


var actions: Array[EventAction]
func _display_stage(stage: EventNode):
	if stage is EventMonologue:
		_update_monologue(stage)
	
	elif  stage is EventDialogue:
		_update_dialogue(stage)
	
	else:
		rich_text_label.text = currect_event.description
	
	actions = currect_event.get_next_actions(stage)
	action_list.update_actions(_validate_action(actions))
	_display_result(_result)


func _validate_action(_actions: Array[EventAction]) -> Array[EventAction]:
	var new_actions: Array[EventAction] = []
	for action: EventAction in actions:
		var _visible = true
		if action.action:
			_visible = action.action.is_meet_conditions()
		
		action.set_meta("disabled", not _visible)
		if not (action.is_hidden and not _visible):
			new_actions.append(action)
	return new_actions


func _update_monologue(stage: EventMonologue):
	rich_text_label.text = TranslationServer.translate(
		("%s_MONOLOGUE_%s" % [currect_event.name_key.to_upper(), stage.text]).to_upper()
	)

func _update_dialogue(stage: EventDialogue):
	var text = ''
	for paragraph in stage.dialogues:
		text += "[b]%s[/b]:\n" % [
			TranslationServer.translate("DIALOGUE_CHARACTER_%s_NAME" % [paragraph[0].name.to_upper()])
		]
		text += "%s\n\n" % [
			TranslationServer.translate("%s_DIALOGUE_%s" % [currect_event.name_key.to_upper(), paragraph[1].to_upper()])
		]
	rich_text_label.text = text


func _on_action_pressed(pressed_index: int):
	var action := actions[pressed_index] as EventAction
	currect_event.action_press(action)
	
	var _next = currect_event.get_next_nodes(action, EventEdge.EdgeType.ACTION)
	if _next.any(func(a): return a is EventAbort or a is EventEnd):
		close()
		#EventsGlobal.aborted_event.emit(currect_event)
		return
	
	for stage in currect_stages:
		if not stage is EventStage:
			continue
		currect_event.complete_stage(stage)
	display(currect_event)



func _display_result(result: Dictionary):
	if result.is_empty():
		%ResultContainer.hide()
		return
	
	#TODO переделать отображение наград
	%ResultList.clear()
	#for data: String in result.keys():
		#var collection := ""
		#if data.name.contains("item"):
			#collection = "items"
		#
		#elif  data.name.contains("property"):
			#collection = "properties"
		#
		#else:
			#continue
		#
		#var _name: String = "%d" % data.args_data[1]
		#var icon: Texture2D = resource_db.connection.fetch_data(collection, StringName(data.args_data[0])).texture
		#var index = %ResultList.add_item("%s" % result[data], icon)
		#%ResultList.set_item_tooltip(index, data.args_data[0])
	
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
