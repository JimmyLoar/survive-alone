class_name BiomeSerchUI
extends PanelContainer


const DEFUALT_EVENT = preload("res://feature/biom_search_event/internal/defualt_event.tres")

var _state: BiomeSearchState


@onready var texture_rect: TextureRect = %TextureRect
@onready var texture_progress_bar: TextureProgressBar = $HBoxContainer/PanelContainer/TextureProgressBar
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var item_list: ItemList = %ItemList



func _init() -> void:
	pass


func _enter_tree() -> void:
	_state = Injector.provide(BiomeSearchState, BiomeSearchState.new(self), self, Injector.ContainerType.CLOSEST)


func _ready() -> void:
	open()
	pass


func test(): 
	var event = _state.select_event()
	print(event.get_stage_text(0))
	event = _state.select_event()
	print(event.get_stage_text(0))
	event = _state.select_event()
	print(event.get_stage_text(0))
	event = _state.select_event()
	print(event.get_stage_text(0))


func open():
	display_stage(DEFUALT_EVENT, 0)


func display_stage(event: BiomeSerchEventResource, stage: int):
	if event._stages.is_empty():
		event.add_stage("start", "none")
		var action_resource: EventActionResource = preload("res://feature/biom_search_event/internal/0_search_action.tres")
		event.add_action(0, "search", -1, false, null, action_resource)
		event.add_action(0, "end", -1)
	
	texture_rect.texture = event.get_stage_texture(stage)
	rich_text_label.text = event.get_stage_text(stage)
	
	item_list.clear()
	for i in event.get_stage_actions(stage).size():
		item_list.add_item(
			event.get_action_text(stage, i),
			event.get_action_icon(stage, i),
		)
	self.show()
