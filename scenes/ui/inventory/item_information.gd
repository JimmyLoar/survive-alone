class_name ItemInfoPanel
extends MarginContainer

@export var _item: ItemData

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var text_label: RichTextLabel = $VBoxContainer/ScrollContainer/VBoxContainer/RichTextLabel


@onready var inventory: Inventory = InventoriesController.get_inventory("player"): 
	set = set_inventory


func update(slot: Dictionary = {}):
	_item = slot.item
	name_label.text = "%s" % _item.name
	text_label.clear()
	text_label.append_text("%s" % _item.discription)
	$VBoxContainer/ScrollContainer/VBoxContainer/PanelContainer1.update(_item)
	if not slot.used.is_empty():
		text_label.append_text("Durability: %d" % slot.used.front())


func set_inventory(new_inv: Inventory):
	inventory = new_inv
	update(inventory.get_slot(0))


func _on_remove_inventory_items() -> void:
	inventory.add_item_amount(_item, -1)
