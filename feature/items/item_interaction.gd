extends PanelContainer

signal reduced_self

@onready var property_container: HBoxContainer = $MarginContainer/VBoxContainer/PropertyContainer
@onready var items_container: HBoxContainer = $MarginContainer/VBoxContainer/ItemsContainer
@onready var slider: HSlider = $MarginContainer/VBoxContainer/HSlider
@onready var button: Button = $MarginContainer/VBoxContainer/Button

var interaction: ItemIntaractionData
var item: ItemData 

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
		var _key = action.get_class_name()
		_callibles_display[_key].call(action)


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


@onready var _dependences = {
	"AddProppertyAction"		: [Game.get_world_screen().get_player_properties()],
	"ChangeDurabilityAction"	: [],
	"ChangeItemsAction"			: [],
	"UseTimerAction"			: [],
}
func _on_button_pressed() -> void:
	for action in interaction.actions: 
		var _key = action.get_class_name()
		action.set_dependence(_dependences[_key])
		action.execute()
	
	if interaction.reduced_when_used:
		reduced_self.emit()

func get_item():
	return $"../../../.."._last_slot
