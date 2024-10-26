class_name InventoryDisplay
extends MarginContainer

signal slot_pressed(slot: Dictionary)

@export var page_size := Vector2i(3, 3)

@onready var slot_controller: SlotCotroller = $VBoxContainer/SlotController
@onready var page_controller: PageController = $VBoxContainer/PageController

var inventory: Inventory: 
	set = set_inventory


func _ready() -> void:
	visibility_changed.connect(update)
	set_inventory(InventoriesController.create_inventory("player"))
	slot_controller.init_slots(page_size)
	page_controller.set_page_size(page_size.x * page_size.y)

func set_inventory(new_inventory: Inventory):
	if inventory and inventory.changed.is_connected(update):
		inventory.changed.disconnect(update)
	
	inventory = new_inventory
	if not inventory.changed.is_connected(update):
		inventory.changed.connect(update)
	
	inventory.change_size.connect(page_controller.set_inventory_size)
	update()


func update():
	if not visible or not inventory: return
	if slot_controller:
		slot_controller.update_slots(inventory.get_slots_list())
	
	if page_controller:
		page_controller.set_inventory_size(inventory.get_size())
	return


func _on_slot_controller_slot_pressed(slot_index: int) -> void:
	slot_pressed.emit(inventory.get_slot(slot_index))
