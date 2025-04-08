@tool
class_name ParagraphBox
extends VBoxContainer

signal request_to_remove(paragraph: ParagraphBox)

const CHARACTERS_LIST = EventDialogueNode.CHARACTERS_LIST

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
	text_edit.text = TranslationServer.translate(("event_dialogue_%s" % line_edit.text).to_upper())


func set_data(array: Array):
	array.resize(2)
	var char_index = int(CHARACTERS_LIST.find_custom(
		func(char: EventDialogueCharacter):
			return char.name == array[0].name
	))
	character_selecter.select(char_index)
	_who = CHARACTERS_LIST[char_index]
	line_edit.text = array[1]
	_on_line_edit_text_changed(array[1])


func get_data() -> Array:
	return [_who, line_edit.text.to_lower()]


func _on_character_selecter_item_selected(index: int) -> void:
	_who = CHARACTERS_LIST[index]
	#printerr("update_character on %s" % _who.name)
