class_name VButtonsContainer
extends VBoxContainer

enum {
	TEXT,
	TEXTURE,
	CALLABLE,
}


@export var button_size := Vector2i(90, 60)
@export var text_size: int = 26


var _button_group := ButtonGroup.new()


static func create_currect_dictionary(callable: Callable, text: String = '', texture: Texture2D = null) -> Dictionary:
	return {
	TEXT: text,
	TEXTURE: texture,
	CALLABLE: callable,
}


func create_buttons(list: Array[Dictionary]):
	for i in list.size():
		var dir := list[i] as Dictionary
		var button := _create_button()
		
		button.text = dir[TEXT]
		button.pressed.connect(dir[CALLABLE])
		button.icon = dir[TEXTURE]


func _create_button() -> ButtonSound:
	var new_button := ButtonSound.new()
	new_button.button_group = _button_group
	new_button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	add_child(new_button)
	
	new_button.custom_minimum_size = button_size
	new_button.set("theme_override_font_sizes/font_size", text_size)
	return new_button
