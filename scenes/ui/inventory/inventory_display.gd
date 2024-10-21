class_name InventoryDisplay
extends MarginContainer

signal slot_pressed(item_name: String)

@export var page_size := Vector2i(3, 3)

@onready var slot_controller: SlotCotroller = $VBoxContainer/SlotController
@onready var page_controller: PageController = $VBoxContainer/PageController

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


func _ready() -> void:
	slot_controller.init_slots(page_size)
	slot_controller.update_slots(inventory.get_slots_list())


func connect_inventory(inv: Inventory):
	inv.changed.connect(update)


func update(inventory: Inventory):
	if not visible: return
	return
