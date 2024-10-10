extends PanelContainer

signal button_pressed(index: int)
@onready var buttons_container: VBoxContainer = $MarginContainer/VBoxContainer

var _last_pressed := 0

func _on_pressed(current_pressed: int) -> void:
	if _last_pressed != current_pressed:
		_last_pressed = current_pressed
	
	else:
		buttons_container.get_node("Button%s" % _last_pressed).button_pressed = false
		_last_pressed = -1
	
	button_pressed.emit(_last_pressed)
