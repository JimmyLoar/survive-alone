@tool
class_name GraphBoxItem
extends MarginContainer

signal request_to_remove



func update():
	pass


func _on_remove_button_pressed() -> void:
	request_to_remove.emit(self)


func _set_data(array: Array):
	pass


func _get_data() -> Array:
	return []
