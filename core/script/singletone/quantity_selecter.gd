class_name QuantitySelecter
extends CanvasLayer

signal confirmed_value(value: int)
signal canseled

@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var value_label: Label = $Panel/MarginContainer/VBoxContainer/QuantityContainer/ValueLabel
@onready var slider: HSlider = $Panel/MarginContainer/VBoxContainer/HSlider


func _ready() -> void:
	hide()


func enable(max_value: int):
	slider.max_value = max_value
	slider.value = 1
	show()


func _on_h_slider_value_changed(value: float) -> void:
	value_label.text = "%d" % value


func _on_confirm_button_pressed() -> void:
	hide()
	confirmed_value.emit(slider.value)


func _on_cansel_button_pressed() -> void:
	hide()
	canseled.emit()


func _on_change_value_pressed(value: int) -> void:
	slider.value += value
