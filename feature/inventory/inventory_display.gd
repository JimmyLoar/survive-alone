class_name InventoryDisplay
extends MarginContainer

signal slot_pressed(slot: InventorySlot)
signal duble_pressed(slot: InventorySlot)

@export var page_size := Vector2i(3, 3)

@onready var slot_controller: SlotCotroller = $VBoxContainer/SlotController
@onready var page_controller: PageController = $VBoxContainer/PageController

var _slots: Array[InventorySlot]

var inventory: Inventory: 
	set = set_inventory


func _ready() -> void:
	visibility_changed.connect(update)
	slot_controller.init_slots(page_size)
	page_controller.set_page_size(page_size.x * page_size.y)


func set_inventory(new_inventory: Inventory):
	if inventory and inventory.changed.is_connected(update):
		inventory.changed.disconnect(update)
	
	inventory = new_inventory
	if not inventory.changed.is_connected(update):
		inventory.changed.connect(update)
	
	update()


func update():
	if not visible or not inventory: return
	if slot_controller:
		_slots = inventory.get_slots(true)
		slot_controller.update_slots(_slots)
	
	if page_controller:
		page_controller.set_inventory_size(inventory.get_size())
	return


func get_last_pressed():
	return slot_controller.button_group.get_pressed_button().get_index()


func _on_slot_controller_slot_pressed(slot_index: int) -> void:
	slot_pressed.emit(_slots[slot_index])


func _on_slot_controller_duble_pressed(slot_index: int) -> void:
	duble_pressed.emit(_slots[slot_index])