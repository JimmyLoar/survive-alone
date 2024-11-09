class_name ItemInfoPanel
extends MarginContainer

signal remove_items(item_list: Array)
signal add_items(item_list: Array)
signal transfered_items(inv_name: String, slot: Dictionary, count: int)

@export var transfer_inv_name : String = ""

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var text_label: RichTextLabel = $VBoxContainer/ScrollContainer/VBoxContainer/RichTextLabel
@onready var interactive_container: VBoxContainer = $VBoxContainer/ScrollContainer/VBoxContainer
@onready var pick_up_button: Button = $VBoxContainer/Buttons/PickUpButton


@onready var inventory: Inventory: 
	set = set_inventory

var _last_slot: Dictionary = {}

func _ready() -> void:
	update()


func update(slot: Dictionary = {}):
	if slot.is_empty() or _last_slot == slot or (slot.used.size() + slot.amount == 0):
		self.hide()
		_last_slot = {}
		return
	
	_last_slot = slot
	
	var item: ItemData = _last_slot.item
	name_label.text = "%s" % item.name
	text_label.clear()
	text_label.append_text("%s" % item.discription)
	
	for i in range(6):
		update_interaction_panel(i, item)
	
	if not _last_slot.used.is_empty():
		text_label.append_text("Durability: %d" % _last_slot.used.front())
	
	pick_up_button.visible = item.is_pickable
	self.show()


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
		inventory.add_item_amount(_last_slot.item, -1)
	if inventory.get_item_count(_last_slot.item) <= 0:
		update()


func _on_pick_up_button_pressed() -> void:
	QuantitySelecter.canseled.connect(_on_selecter_canseled, CONNECT_ONE_SHOT)
	QuantitySelecter.confirmed_value.connect(_on_selecter_confirmed_value, CONNECT_ONE_SHOT)
	QuantitySelecter.enable(Inventory.count_slot_size(_last_slot))


func _on_selecter_confirmed_value(value: int):
	QuantitySelecter.canseled.disconnect(_on_selecter_canseled)
	if value >= Inventory.count_slot_size(_last_slot):
		update()
	transfered_items.emit(transfer_inv_name, _last_slot, value)


func _on_selecter_canseled():
	QuantitySelecter.confirmed_value.disconnect(_on_selecter_confirmed_value)
