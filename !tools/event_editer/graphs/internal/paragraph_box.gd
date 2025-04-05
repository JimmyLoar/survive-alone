@tool
class_name ParagrathBox
extends VBoxContainer

signal request_to_remove(paragraph: ParagrathBox)

const CHARACTERS_LIST = DialogeEventGraphNode.CHARACTERS_LIST

@export var character_selecter: OptionButton 
@export var line_edit: LineEdit 
@export var text_edit: TextEdit

var _who:= CHARACTERS_LIST[0]

func _ready() -> void:
	update()
	character_selecter.clear()
	for char in CHARACTERS_LIST:
		character_selecter.add_item(char.name)


func update():
	$Label.text = "Paragraph № %s" % get_index()


func _on_remove_button_pressed() -> void:
	request_to_remove.emit(self)


func _on_line_edit_text_changed(new_text: String) -> void:
	text_edit.text = TranslationServer.translate(("event_dialoge_%s" % line_edit.text).to_upper())


func set_data(array: Array):
	array.resize(2)
	character_selecter.select(int(CHARACTERS_LIST.find(array[0])))
	line_edit.text = array[1]
	_on_line_edit_text_changed(array[1])


func get_data() -> Array:
	return [_who, line_edit.text]


func _on_character_selecter_item_selected(index: int) -> void:
	_who = CHARACTERS_LIST[index]
