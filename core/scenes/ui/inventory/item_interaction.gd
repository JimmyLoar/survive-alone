extends PanelContainer

signal reduced_self

@onready var property_container: HBoxContainer = $MarginContainer/VBoxContainer/PropertyContainer
@onready var items_container: HBoxContainer = $MarginContainer/VBoxContainer/ItemsContainer
@onready var slider: HSlider = $MarginContainer/VBoxContainer/HSlider
@onready var button: Button = $MarginContainer/VBoxContainer/Button

var action: Dictionary
var type_map: Array[bool]

func update(_action: Dictionary, _type_map: Array[bool] = []):
	action = _action
	type_map = _type_map
	visible = not action.is_empty()
	if not visible:
		return
	
	button.text = action.name
	
	if type_map[0]: #CHANGE_PROPERTY
		update_properties(action)
	
	if type_map[1]: #CHANGE_DURABILITY
		pass
	if type_map[2]: #REQUIRE_ITEMS
		pass
	if type_map[3]: #RECEIVE_ITEMS
		pass
	if type_map[4]: #CAN_STACABLE
		pass
	if type_map[5]: #USE_TIMER
		pass
	
	property_container.visible = _type_map[0]
	items_container.visible =  type_map[2] || type_map[3]
	slider.visible = _type_map[4]


func update_properties(action: Dictionary):
	for i in property_container.get_child_count():
		var display: MarginContainer = property_container.get_child(i)
		var _name = ""
		var value = 0
		if action.has("property_%d_name" % i):
			_name = action["property_%d_name" % i]
			value = action["property_%d_value" % i]
		display.update(_name, value)


func _on_button_pressed() -> void:
	if type_map[0]: #CHANGE_PROPERTY
		_on_pressed_properties()
	
	if type_map[1]: #CHANGE_DURABILITY
		pass
	if type_map[2]: #REQUIRE_ITEMS
		pass
	if type_map[3]: #RECEIVE_ITEMS
		pass
	if type_map[4]: #CAN_STACABLE
		pass
	if type_map[5]: #USE_TIMER
		pass

func _on_pressed_properties():
	for i in property_container.get_child_count():
		var display: MarginContainer = property_container.get_child(i)
		if action.has("property_%d_name" % i):
			var _name = action["property_%d_name" % i]
			var value = PlayerProperty.get_value(_name) + action["property_%d_value" % i]
			PlayerProperty.set_value(_name, value)
		
	if action.reduced_self:
		reduced_self.emit()
