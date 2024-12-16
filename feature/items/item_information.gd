class_name ItemInfoPanel
extends MarginContainer

signal remove_items(item_list: Array)
signal add_items(item_list: Array)
signal transfered_items(slot: InventorySlot, count: int)

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var text_label: RichTextLabel = $VBoxContainer/ScrollContainer/VBoxContainer/RichTextLabel
@onready var interactive_container: VBoxContainer = $VBoxContainer/ScrollContainer/VBoxContainer
@onready var pick_up_button: Button = $VBoxContainer/Buttons/PickUpButton


@onready var inventory: Inventory: 
	set = set_inventory

var _last_slot: InventorySlot
var _quantity_selecter: QuantitySelecter

func _ready() -> void:
	update()


func update(slot: InventorySlot = null):
	if not slot or slot.is_empty() or _last_slot == slot:
		_update_in_null()
		return
	
	_last_slot = slot
	_update_display(slot)
	_update_durability_text(slot.get_used())
	
	for i in range(6):
		update_interaction_panel(i, slot.get_data())
	
	pick_up_button.visible = slot.get_data().is_pickable


func _update_in_null():
	_last_slot = null
	hide()


func _update_display(slot: InventorySlot):
	var item: ItemData = slot.get_data()
	name_label.text = "%s" % item.name_key
	text_label.clear()
	text_label.append_text("%s" % item.discription)
	show()


func _update_durability_text(used: Array = []):
	if used.is_empty(): return
	text_label.append_text("Durability: %d" % used.front())


func update_interaction_panel(index: int, item: ItemData):
	var into_range = index < item.actions.size()
	var action = item.actions[index] if into_range else {}
	var types: Array[bool] = item.get_action_types(index) if into_range else Array([], TYPE_BOOL, "", null)
	var panel: PanelContainer = interactive_container.get_node("PanelContainer%d" % [index + 1])
	panel.update(action, types)
	if not panel.reduced_self.is_connected(_on_reduced_self):
		panel.reduced_self.connect(_on_reduced_self)


func set_inventory(new_inv: Inventory):
	inventory = new_inv
	update()


func _on_reduced_self() -> void:
	if not _last_slot.is_empty():
		_last_slot.change_amount(-1)
	
	if _last_slot.is_empty():
		update()


func _on_pick_up_button_pressed() -> void:
	if not _quantity_selecter:
		_quantity_selecter = Game.get_world_screen().get_quantity_selecter()
	_quantity_selecter.canseled.connect(_on_selecter_canseled, CONNECT_ONE_SHOT)
	_quantity_selecter.confirmed_value.connect(_on_selecter_confirmed_value, CONNECT_ONE_SHOT)
	_quantity_selecter.enable(_last_slot.get_total_amount())


func _on_selecter_confirmed_value(value: int):
	_quantity_selecter.canseled.disconnect(_on_selecter_canseled)
	transfered_items.emit(self._last_slot, value)
	if value >= _last_slot.get_total_amount():
		update()


func _on_selecter_canseled():
	_quantity_selecter.confirmed_value.disconnect(_on_selecter_confirmed_value)
