class_name BiomeSearchUI
extends PanelContainer


const DEFUALT_EVENT = preload("res://feature/biom_search_event/internal/defualt_event.tres")

var _state: BiomeSearchState

@onready var texture_rect: TextureRect = %TextureRect
@onready var texture_progress_bar: TextureProgressBar = $HBoxContainer/PanelContainer/TextureProgressBar
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var item_list: ItemList = %ItemList
@onready var event_action_state: ActionState



func _enter_tree() -> void:
	_state = Injector.provide(BiomeSearchState, BiomeSearchState.new(self), self, Injector.ContainerType.CLOSEST)


func _ready() -> void:
	item_list.item_selected.connect(_action_pressed)
	self.hide()


func open():
	display_stage(DEFUALT_EVENT, 0)


func close():
	self.hide()
	_state.currect_event = null


func display_stage(event: BiomeSearchEventResource, stage: int):
	if event._stages.is_empty():
		event.add_stage("start", "none")
		var action_resource: ActionResource = preload("res://feature/biom_search_event/internal/0_search_action.tres")
		event.add_action(0, "search", -1, false, null, action_resource)
		event.add_action(0, "end", -1)
	
	texture_rect.texture = event.get_stage_texture(stage)
	rich_text_label.text = event.get_stage_text(stage)
	
	item_list.clear()
	var action_size: int = event.get_stage_actions(stage).size()
	item_list.max_text_lines = 2 if action_size > 3 else 1
	
	for i in action_size:
		var brackets: String = '"%s"' if event.get_action_is_said(stage, i) else "[%s]"
		item_list.add_item(
			brackets % event.get_action_text(stage, i),
			event.get_action_icon(stage, i),
		)
	self.show()


func _action_pressed(action_index: int):
	# TODO Переделать в действий
	if not _state.currect_event or _state.currect_event.get_instance_id() == DEFUALT_EVENT.get_instance_id():
		if action_index == item_list.item_count - 1:
			# close if defualt event and pressed last action
			close()
			return
		
		display_stage(_state.select_event(), 0)
		return
	
	_state.go_to(_state.currect_event.get_action_next_stage(_state.currect_stage, action_index))
	#event_action_state.execute(_state.currect_event.get_action(_state., _state.currect_stage))
	if _state.currect_stage == -1:
		_state.currect_event = null
		display_stage(DEFUALT_EVENT, 0)
		return
	
	display_stage(_state.currect_event, _state.currect_stage)
	return
