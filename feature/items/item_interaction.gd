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
	"ChangeDurabilityAction"	: _display_durability,
	"ChangeItemsAction"			: _display_items,
	"UseTimerAction"			: _display_timer,
}
func display_actions():
	for action in interaction.actions:
		var _key = action.get_class_name()
		_callibles_display[_key].call(action)


func _display_properties(action: AddProppertyAction):
	#var properties := #Game.get_world_screen().get_player_properties()
	for i in property_container.get_child_count():
		var display: MarginContainer = property_container.get_child(i)
		if action.count_properties <= i:
			display.update(null, 0)
			continue
		
		var _name = action._properties[i].name
		var value = action._properties[i].value
		#display.update(properties.get_property(_name), value)


func _display_durability(action: ChangeDurabilityAction):
	pass


func _display_items(action: ChangeItemsAction):
	pass


func _display_timer(action: UseTimerAction):
	pass


#@onready var _dependences = {
	#"AddProppertyAction"		: [#Game.get_world_screen().get_player_properties()],
	#"ChangeDurabilityAction"	: [],
	#"ChangeItemsAction"			: [],
	#"UseTimerAction"			: [],
#}
#func _update_dependence():
	#var inventories: InventoriesController = #Game.get_world_screen().get_inventories_controller()
	#_dependences.merge({
		#"ChangeDurabilityAction"	: [get_item()],
		#"ChangeItemsAction"			: [load("res://content/database.gddb"), inventories.get_player_inventory(), inventories.get_location_inventory()],
		#"UseTimerAction": [#Game.get_world_screen().get_game_time()],
	#}, true)

func _on_button_pressed() -> void:
	#_update_dependence()
	for action in interaction.actions: 
		var _key = action.get_class_name()
		#action.set_dependence(_dependences[_key])
		action.execute()
	
	if interaction.reduced_when_used:
		reduced_self.emit()


func get_item():
	return $"../../../.."._last_item
