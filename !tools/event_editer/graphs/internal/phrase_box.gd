@tool
class_name PhraseBox
extends VBoxContainer

const CHARACTERS_LIST = [
	preload("uid://lo5lkul44sou"),
	preload("uid://k0vu08dr0tmb"),
	preload("uid://blr1yfkg5pohd"),
	preload("uid://b0cjwpa70higj"),
]

@export var character_selecter: OptionButton 
@export var line_edit: LineEdit 
@export var text_edit: TextEdit

var _who:= CHARACTERS_LIST[0]


func _ready() -> void:
	character_selecter.clear()
	character_selecter.add_item("discription")
	for char in CHARACTERS_LIST:
		character_selecter.add_item(char.name)


func set_data(array: Array):
	array.resize(2)
	var char_index = int(CHARACTERS_LIST.find_custom(
		func(char: EventDialogueCharacter):
			return char.name == array[0].name 
	)) if array[0] is EventDialogueCharacter else -1 #return char index or -1
	character_selecter.select(char_index + 1)
	_who = CHARACTERS_LIST[char_index]
	line_edit.text = array[1]
	_on_line_edit_text_changed(array[1])


func get_data() -> Array:
	return [_who, line_edit.text.to_upper()]


func _on_line_edit_text_changed(new_text: String) -> void:
	text_edit.text = TranslationServer.translate(("%s_text_%s" % [EventsGlobal.event_name, new_text]).to_upper())


func _on_character_selecter_item_selected(index: int) -> void:
	_who = CHARACTERS_LIST[index - 1] if index != 0 else null
	printerr("update_character on %s" % _who.name)
