@tool
class_name GraphBoxItem
extends Container

signal request_to_remove


func update():
	pass


func _on_remove_button_pressed() -> void:
	request_to_remove.emit(self)


func _set_data(array: Variant):
	pass


func _get_data() -> Variant:
	return null
