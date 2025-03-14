class_name EventNode
extends PanelContainer

@onready var texture_rect: TextureRect = %TextureRect
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var action_list: ItemList = %ActionList
@onready var action_state := Injector.inject(ActionState, self) as ActionState
@onready var result_list: ItemList = %ResultList
@onready var hint_container: VBoxContainer = %HintContainer



var _state: EventState

var currect_event: EventResource
var currect_stage: int = -1
var _result: ActionResource

func _enter_tree() -> void:
	_state = Injector.provide(EventState, EventState.new(self), self, Injector.ContainerType.CLOSEST)


func _ready() -> void:
	action_list.item_selected.connect(_on_action_pressed)
	action_list.action_state = action_state
	%ResultContainer.hide()
	%HintContainer.hide()
	self.hide()
	_register_methods()


func display(event: EventResource):
	if not event or currect_event == event:
		currect_event = null
		currect_stage = -1
		self.hide()
		return
	
	currect_event = event
	currect_stage = 0
	_display_stage(currect_stage)
	self.show()


func _display_stage(stage_index: int):
	if stage_index == -1:
		return
	
	var stage: EventStageResource = currect_event.get_stage(stage_index)
	texture_rect.texture = stage.texture
	rich_text_label.text = TranslationServer.translate(stage.text)
	action_list.update_actions(stage.actions)


func _display_actions_hint(stage: EventStageResource):
	for i in stage.actions.size():
		var action := stage.actions[i] as EventActionResource
	


func _on_action_pressed(pressed_index: int):
	var action := currect_event.get_action(currect_stage, pressed_index) as EventActionResource
	currect_stage = action.next_stage
	if action.next_stage == -1 and not action.effects.any(func(effect: ExecuteKeeperResource): return effect.name.contains("activate event")):
		self.hide()

	else:
		_display_stage(currect_stage)
	
	var result := {}
	if await action_state.can_execute(action):
		result = action_state.execute(action)
	
	if not action.showing_result:
		result = {}
	_display_result(result)
	


func _display_result(result: Dictionary):
	if result.is_empty():
		%ResultContainer.hide()
		return
	
	%ResultList.clear()
	for data in result.values():
		if data is not Dictionary: 
			continue
		%ResultList.add_item(str(data.change_value), data.resource.texture as Texture2D)
	
	%ResultContainer.show()



func _register_methods():
	var execute_keeper := Injector.inject(ExecuteKeeperState, self) as ExecuteKeeperState
	var db_resource := Injector.inject(ResourceDb, self) as ResourceDb
	var _activate_event = func(event_name: String):
		var event: EventResource = db_resource.connection.fetch_data("event", StringName(event_name))
		_state.activate_event(event)
	
	var _activate_event_list = func(list_name: String):
		var list: EventList = db_resource.connection.fetch_data("event_list", StringName(list_name))
		var event: EventResource = list.get_event()
		_state.activate_event(event)
	
	execute_keeper.register(ExecuteKeeperState.TYPE_EFFECT, "activate event", _activate_event,
		["enum/String/%s" % [",".join(db_resource.connection.get_data_string_ids("event"))]], 
		[""],
	)
	execute_keeper.register(ExecuteKeeperState.TYPE_EFFECT, "activate event from list", _activate_event_list,
		["enum/String/%s" % [",".join(db_resource.connection.get_data_string_ids("event_list"))]],
		[""]
	)
	
