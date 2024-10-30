class_name ItemInfoPanel
extends MarginContainer

signal remove_items(item_list: Array)
signal add_items(item_list: Array)

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var text_label: RichTextLabel = $VBoxContainer/ScrollContainer/VBoxContainer/RichTextLabel
@onready var interactive_container: VBoxContainer = $VBoxContainer/ScrollContainer/VBoxContainer


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
