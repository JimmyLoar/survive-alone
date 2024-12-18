extends PanelContainer

signal reduced_self

@onready var property_container: HBoxContainer = $MarginContainer/VBoxContainer/PropertyContainer
@onready var items_container: HBoxContainer = $MarginContainer/VBoxContainer/ItemsContainer
@onready var slider: HSlider = $MarginContainer/VBoxContainer/HSlider
@onready var button: Button = $MarginContainer/VBoxContainer/Button

var interaction: ItemIntaractionData
var type_map: Array[bool]

func update(_interaction: ItemIntaractionData):
	interaction = _interaction
	if not interaction:
		visible = false
		return
	
	visible = true
	button.text = interaction.visible_name
	display_actions()
	property_container.visible = interaction.has_change_properties()
	items_container.visible =  interaction.has_change_items()
	slider.visible = interaction.can_stacable


var _callibles_display = {
	"AddProppertyAction"		: _display_properties,
	"ChangeDurabilityAction"	: print,
	"ReceiveItemsAction"		: print,
	"RequireItemsAction"		: print,
	"UseTimerAction"			: print,
}
func display_actions():
	for action in interaction.actions:
		var _scripte_name = action.get_script().get_global_name()
		_callibles_display[_scripte_name].call(action)


func _display_properties(action: AddProppertyAction):
	var properties := Game.get_world_screen().get_player_properties()
	for i in property_container.get_child_count():
		var display: MarginContainer = property_container.get_child(i)
		if action.count_properties <= i:
			display.update(null, 0)
			continue
		
		var _name = action._properties[i].name
		var value = action._properties[i].value
		display.update(properties.get_property(_name), value)
	

var _callibles_on_pressed = {
	"AddProppertyAction"		: _on_pressed_properties,
	"ChangeDurabilityAction"	: print,
	"ReceiveItemsAction"		: print,
	"RequireItemsAction"		: print,
	"UseTimerAction"			: print,
}
func _on_button_pressed() -> void:
	for action in interaction.actions: 
		var _scripte_name = action.get_script().get_global_name()
		_callibles_on_pressed[_scripte_name].call(action)
	

func _on_pressed_properties(action: AddProppertyAction):
	var properties := Game.get_world_screen().get_player_properties()
	for i in action.count_properties:
		var _name = action._properties[i].name
		var value = action._properties[i].value + properties.get_value(_name)
		properties.set_value(_name, value)
	
	reduced_self.emit()
