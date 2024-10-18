extends PanelContainer

signal action_pressed

enum Mode{
	USAGE_PROPERTY = 1,
	USAGE_SLIDER = 2,
	USAGE_ITEMS = 4,
}
@export_flags("Property", "Slider", "Items") var usage_mode: int = Mode.USAGE_PROPERTY

@onready var property_container: HBoxContainer = $MarginContainer/VBoxContainer/PropertyContainer
@onready var items_container: HBoxContainer = $MarginContainer/VBoxContainer/ItemsContainer
@onready var slider: HSlider = $MarginContainer/VBoxContainer/HSlider

var _item: ItemData

func _ready() -> void:
	_update_usage()


func update(item: ItemData):
	_item = item
	if not item: return
	_update_usage()
	if item.is_used_property():
		for i in item.action1_property_names.size():
			var display = property_container.get_child(i)
			var property: GameProperty = PlayerProperty.get_property(
				item.action1_property_names[i])
			display.update(property.texture, item.action1_property_value[i])


func _update_usage():
	if usage_mode == 0:
		self.hide()
		return
	
	property_container.hide()
	items_container.hide()
	slider.hide()
	
	if is_mode(Mode.USAGE_PROPERTY):
		property_container.show()
	
	if is_mode(Mode.USAGE_SLIDER):
		slider.show()
	
	if is_mode(Mode.USAGE_ITEMS):
		items_container.show()
	


func is_mode(mode: Mode):
	return fmod(usage_mode, mode * 2) >= mode


func _on_button_pressed() -> void:
	if _item.is_used_property():
		for i in _item.action1_property_names.size():
			var p_key = _item.action1_property_names[i]
			var value = PlayerProperty.get_value(p_key) + _item.action1_property_value[i]
			PlayerProperty.set_value(p_key, value)
