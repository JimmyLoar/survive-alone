class_name InventoryDisplay
extends MarginContainer

signal slot_pressed(item_name: String)

@export var page_size := Vector2i(3, 3)


var currect_page := 0:
	set(value):
		currect_page = clamp(value, 0, max_page)
		update_page(currect_page)
		currect_page_label.text = str(currect_page + 1)

var max_page := 1

@onready var slot_controller: SlotCotroller = $VBoxContainer/SlotController
@onready var currect_page_label: Label = $VBoxContainer/PageHBoxContainer/CurrectPageLabel

@onready var inventory: Inventory = Inventory.new([
	preload("res://database/food/water_clear.tres"),
	preload("res://database/food/water_clear.tres"),
	preload("res://database/food/water_clear.tres"),
	preload("res://database/food/water_clear.tres"),
	preload("res://database/food/water_clear.tres"),
	preload("res://database/food/fry_meat.tres"),
	preload("res://database/food/fry_meat.tres"),
	preload("res://database/food/fry_meat.tres"),
])#get_tree().root.get_node("WorldScreen/Character").inventory
@onready var slot_count := page_size.x * page_size.y


func _ready() -> void:
	slot_controller.init_slots(page_size)
	slot_controller.update_slots(inventory.get_slots_list())


func connect_inventory(inv: Inventory):
	inv.changed.connect(update)


func update(inventory: Inventory):
	if not visible: return
	max_page = ceili(inventory.get_size() / slot_count)
	currect_page = currect_page
	return


func update_page(page_number: int):
	var items_list: Array = inventory.get_items().keys().slice(slot_count * page_number, slot_count * (page_number + 1))
	for i in slot_count:
		var item_data: ItemData = null
		var count: int = 0 
		
		if i < items_list.size():
			item_data = inventory.get_item(items_list[i])
			count = inventory.get_item_count(items_list[i])
		
		var slot: InventorySlotDisplay = slot_controller.get_child(i)
		#slot.update(item_data, count)


func _init_page(count: int):
	for i in count:
		var slot: InventorySlotDisplay = _get_new_slot()
		slot_controller.add_child(slot)
		#slot.update(null, 0)
	return


func _get_new_slot():
	return InventorySlotDisplay.new()


func _on_next_page_button_pressed() -> void:
	currect_page = wrapi(currect_page + 1, 0, max_page + 1)


func _on_back_page_button_pressed() -> void:
	currect_page = wrapi(currect_page - 1, 0, max_page + 1)
