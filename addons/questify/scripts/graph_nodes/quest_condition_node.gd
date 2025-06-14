@tool
class_name QuestConditionNode extends QuestGraphNode


var type: QuestCondition.TypeVariants
var key: String
var value: Variant


@export var type_option: OptionButton
@export var key_input: LineEdit
@export var key_option: OptionButton
@export var meta_input: VariantInput


func _ready() -> void:
	_update_types()


func _get_model() -> QuestNode:
	return QuestCondition.new()


func _set_model_properties(node: QuestNode) -> void:
	node.type = type
	node.key = key
	node.set_meta("value", value)


func _get_model_properties(node: QuestNode) -> void:
	_on_option_button_item_selected(node.type)
	type_option.select(node.type)
	key = node.key
	key_input.text = node.key
	value = node.get_meta("value", false)
	meta_input.set_value(value)



func _on_key_text_changed(new_text: String) -> void:
	key = new_text


func _on_metadata_input_value_changed(new_value: Variant) -> void:
	value = new_value


func _on_option_button_item_selected(index: int) -> void:
	type = index
	$Key.visible = type != QuestCondition.TypeVariants.none
	$Value.visible = type != QuestCondition.TypeVariants.none
	key_option.clear()
	for i in QuestCondition.KEYS[type]:
		key_option.add_item(i) 


func _update_types():
	type_option.clear()
	for i in QuestCondition.TypeVariants.keys():
		type_option.add_item(i, QuestCondition.TypeVariants.get(i))


func _on_key_option_button_item_selected(index: int) -> void:
	pass
