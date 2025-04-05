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
var currect_stage: int = -1
var _result: Dictionary


func _enter_tree() -> void:
	_state = Injector.provide(EventState, EventState.new(self), self, Injector.ContainerType.CLOSEST)


func _ready() -> void:
	_register_methods()
	action_list.item_selected.connect(_on_action_pressed)
	action_list.action_state = action_state
	%ResultContainer.hide()
	%HintContainer.hide()
	_state.start_event(preload("res://resources/collection/events/dialoge/hungry_man_0.tres").instantiate())
	#self.hide()


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
	
	#var stage: EventStageResource = currect_event.get(stage_index)
	#texture_rect.texture = currect_event.
	rich_text_label.text = currect_event.description
	#action_list.update_actions(stage.actions)
	_display_result(_result)


func _display_actions_hint(stage: EventStageResource):
	for i in stage.actions.size():
		var action := stage.actions[i] as EventActionResource


func _on_action_pressed(pressed_index: int):
	var action := currect_event.get_action(currect_stage, pressed_index) as EventActionResource
	currect_stage = action.next_stage
	
	if await action_state.can_execute(action) :
		_result = action_state.execute(action)
		if not action.showing_result:
			_result = {}
		
		_display_stage(currect_stage)


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




	
