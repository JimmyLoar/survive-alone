class_name ItemInfoPanel
extends MarginContainer

signal remove_items(item_list: Array)
signal add_items(item_list: Array)
signal transfered_items(item: ItemEntity, count: int)

@onready var name_label: Label = %NameLabel
@onready var text_label: RichTextLabel = $VBoxContainer/ScrollContainer/VBoxContainer/RichTextLabel
@onready var interactive_container: VBoxContainer = $VBoxContainer/ScrollContainer/VBoxContainer
@onready var pick_up_button: Button = $VBoxContainer/Buttons/PickUpButton


@onready var inventory: InventoryState: 
	set = set_inventory

var _last_item: ItemEntity
var _quantity_selecter: QuantitySelecter

func _ready() -> void:
	update()


func update(item: ItemEntity = null):
	if not item or item.is_empty() or _last_item == item:
		_update_in_null()
		return
	
	_last_item = item
	_update_display(item)
	_update_durability_text(item)
	
	for i in range(6):
		update_interaction_panel(i, item.get_data())
	
	pick_up_button.visible = item.get_data().is_pickable


func _update_in_null():
	_last_item = null
	hide()


func _update_display(item: ItemEntity):
	var data: ItemResource = item.get_data()
	name_label.text = "%s" % data.name_key
	text_label.clear()
	text_label.append_text("%s" % data.discription)
	show()


func _update_durability_text(item: ItemEntity):
	text_label.newline()
	var value := item.get_resource().durability
	if not item.get_used().is_empty(): 
		value = item.get_used().front()
	if value <= 0: return
	text_label.append_text("Durability: %d" % value)


func update_interaction_panel(index: int, item: ItemResource):
	var into_range = index < item.actions.size()
	var action: ItemIntaractionData = item.actions[index] if into_range else null
	var panel: PanelContainer = interactive_container.get_node("PanelContainer%d" % [index + 1])
	panel.update(action)
	if not panel.reduced_self.is_connected(_on_reduced_self):
		panel.reduced_self.connect(_on_reduced_self)


func set_inventory(new_inv: InventoryState):
	inventory = new_inv
	update()


func _on_reduced_self() -> void:
	if not _last_item.is_empty():
		_last_item.change_amount(-1)
	
	if _last_item.is_empty():
		update()


func _on_pick_up_button_pressed() -> void:
	return
	#if not _quantity_selecter:
		#_quantity_selecter = #Game.get_world_screen().get_quantity_selecter()
	#_quantity_selecter.canseled.connect(_on_selecter_canseled, CONNECT_ONE_SHOT)
	#_quantity_selecter.confirmed_value.connect(_on_selecter_confirmed_value, CONNECT_ONE_SHOT)
	#_quantity_selecter.enable(_last_item.get_total_amount())


func _on_selecter_confirmed_value(value: int):
	_quantity_selecter.canseled.disconnect(_on_selecter_canseled)
	transfered_items.emit(self._last_item, value)
	if value >= _last_item.get_total_amount():
		update()


func _on_selecter_canseled():
	_quantity_selecter.confirmed_value.disconnect(_on_selecter_confirmed_value)
