class_name QuantitySelector
extends CanvasLayer

var on_confirm: Callable = func():;
var on_cancel: Callable = func():;

@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var value_label: Label = $Panel/MarginContainer/VBoxContainer/QuantityContainer/ValueLabel
@onready var slider: HSlider = $Panel/MarginContainer/VBoxContainer/HSlider

func _enter_tree() -> void:
	Injector.provide(QuantitySelectorState, QuantitySelectorState.new(self), self, Injector.ContainerType.CLOSEST)


func open(max_value: int, _title: String, _on_confirm: Callable, _on_cancel: Callable):
	title_label.text = _title
	slider.max_value = max_value
	slider.value = 1
	on_confirm = _on_confirm
	on_cancel = _on_cancel
	show()

var is_opened:
	get: return self.visible

func _on_h_slider_value_changed(value: float) -> void:
	value_label.text = "%d" % value


func _on_confirm_button_pressed() -> void:
	hide()
	on_confirm.callv([slider.value])


func _on_cansel_button_pressed() -> void:
	hide()
	on_cancel.call()


func _on_change_value_pressed(value: int) -> void:
	slider.value += value
