class_name EventDisplay
extends PanelContainer

@onready var texture_rect: TextureRect = %TextureRect
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var action_list: ItemList = %ActionList
@onready var result_list: ItemList = %ResultList
@onready var hint_container: VBoxContainer = %HintContainer

@onready var action_state := Injector.inject(ActionState, self) as ActionState
@onready var resource_db := Injector.inject(ResourceDb, self) as ResourceDb


var _state: EventState

var currect_event: EventResource
var currect_stage: EventNode
var _result: Dictionary


func _enter_tree() -> void:
	#_state = Injector.provide(EventState, EventState.new(self), self, Injector.ContainerType.ROOT) as EventState
	EventState._node = self
	_state = EventState


func _ready() -> void:
	_register_methods()
	action_list.item_selected.connect(_on_action_pressed)
	action_list.action_state = action_state
	%ResultContainer.hide()
	%HintContainer.hide()
	#_state.start_event(preload("res://resources/collection/events/dialoge/hungry_man_0.tres").instantiate())
	self.hide()	


func _register_methods():
	var execute_keeper := Injector.inject(ExecuteKeeperState, self) as ExecuteKeeperState
	var db_resource := Injector.inject(ResourceDb, self) as ResourceDb
	
	var _activate_event = func(event_name: String):
		var event: EventResource = db_resource.connection.fetch_data("event", StringName(event_name))
		_state.activate_event(event)
	
	execute_keeper.register(
		ExecuteKeeperState.TYPE_EFFECT, "activate event", _activate_event,
		["enum/String/%s" % [",".join(db_resource.connection.get_data_string_ids("event"))]], 
		["event name"],
		[""],
	)
	
	var _activate_event_list = func(list_name: String):
		var list: EventList = db_resource.connection.fetch_data("event_list", StringName(list_name))
		var event: EventResource = list.get_event()
		_state.activate_event(event)
	
	execute_keeper.register(
		ExecuteKeeperState.TYPE_EFFECT, "activate event from list", _activate_event_list,
		["enum/String/%s" % [",".join(db_resource.connection.get_data_string_ids("event_list"))]],
		["events list"],
		[""]
	)
	return


func display(event: EventResource):
	currect_event = event
	for stage in currect_event.get_active_nodes():
		_display_stage(stage)
	self.show()

var actions: Array[EventAction]
func _display_stage(stage: EventNode):
	print("displayed stage '%s'" % stage.id)
	if stage is EventMonologue:
		_update_monologue(stage)
	
	elif  stage is EventDialogue:
		_update_dialogue(stage)
	
	else:
		rich_text_label.text = currect_event.description
	
	actions = currect_event.get_next_actions(stage)
	action_list.update_actions(actions)
	_display_result(_result)


func _update_monologue(stage: EventMonologue):
	rich_text_label.text = TranslationServer.translate("EVENT_MONOLOGUE_" + stage.text.to_upper())
	

func _update_dialogue(stage: EventDialogue):
	pass


func _display_actions_hint(stage: EventStageResource):
	for i in stage.actions.size():
		var action := stage.actions[i] as EventActionResource


func _on_action_pressed(pressed_index: int):
	var action := actions[pressed_index] as EventAction
	currect_event.action_press(action)
	var _next = currect_event.get_next_nodes(action, EventEdge.EdgeType.ACTION)
	if _next.any(func(a): return a is EventAbort):
		hide()
		return
	
	print("pressed action '%s' (index %d)" % [action.id, pressed_index])
	display(currect_event)


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
		%ResultList.add_item(_name, icon)
	
	%ResultContainer.show()




	
