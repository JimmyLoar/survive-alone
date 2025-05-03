@tool
class_name EventActionNode
extends EventGraphNode


@export var line_edit: LineEdit
@export var text_edit: TextEdit

@export var edit_button: Button
@export var special_panel: PanelContainer
@export var condition_panel: PanelContainer
@export var action_panel: PanelContainer

@export var special_panel_title: Label
@export var condition_item_list: ItemList
@export var action_item_list: ItemList

@export var _resource: ActionAggregate


func _ready() -> void:
	super()
	edit_button.pressed.connect(_on_button_pressed)


func _get_model() -> EventNode:
	return EventAction.new()


func _set_model_properties(_node: EventNode) -> void:
	_node.text_key = line_edit.text
	_node.action = _resource


func _get_model_properties(_node: EventNode) -> void:
	line_edit.text = _node.text_key
	if _node.action:
		_resource = _node.action.duplicate(true)
	else:
		_resource = ActionAggregate.new()
	_on_line_edit_text_changed(_node.text_key)


func _on_line_edit_text_changed(new_text: String) -> void:
	text_edit.text = TranslationServer.translate("ACTION_KEY_%s" % new_text.to_upper())


func _on_button_pressed() -> void:
	if not _resource:
		_resource = ActionAggregate.new()
	var inspector = EditorInterface.get_inspector()
	inspector.edit(_resource)
