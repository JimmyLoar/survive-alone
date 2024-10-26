class_name ItemInfoPanel
extends MarginContainer

@export var _item: ItemData

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var text_label: RichTextLabel = $VBoxContainer/ScrollContainer/VBoxContainer/RichTextLabel
@onready var interactive_container: VBoxContainer = $VBoxContainer/ScrollContainer/VBoxContainer


@onready var inventory: Inventory = InventoriesController.get_inventory("player"): 
	set = set_inventory


func _ready() -> void:
	update()


func update(slot: Dictionary = {}):
	self.visible = not slot.is_empty()
	if not self.visible:
		return
	
	_item = slot.item
	name_label.text = "%s" % _item.name
	text_label.clear()
	text_label.append_text("%s" % _item.discription)
	for i in range(6):
		var into_range = i < _item.actions.size()
		var action = _item.actions[i] if into_range else {}
		var types: Array[bool] = _item.get_action_types(i) if into_range else Array([], TYPE_BOOL, "", null)
		var panel: PanelContainer = interactive_container.get_node("PanelContainer%d" % [i + 1])
		panel.update(action, types)
		panel.reduced_self.connect(_on_reduced_self)
	
	if not slot.used.is_empty():
		text_label.append_text("Durability: %d" % slot.used.front())


func set_inventory(new_inv: Inventory):
	inventory = new_inv
	update(inventory.get_slot(0))


func _on_reduced_self() -> void:
	inventory.add_item_amount(_item, -1)
