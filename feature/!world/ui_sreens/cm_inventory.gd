extends ContentMenu

@export var transfer_inventory: NodePath

@onready var inventory_display: InventoryDisplay = $MarginContainer/HBoxContainer/MainContainer/InventoryDisplay
@onready var item_information_panel: ItemInfoPanel = $MarginContainer/HBoxContainer/SubContainer/ItemInformationPanel
var _inventory_controller: InventoriesController

func _init() -> void:
	name = "Inventory"


func _ready() -> void:
	_inventory_controller = Game.get_world_screen().get_inventories_controller()
	item_information_panel.transfered_items.connect(_on_transfered_items)
	update_inventory()


func update_inventory():
	var inv: Inventory = _inventory_controller.get_player_inventory()
	inventory_display.set_inventory(inv)
	item_information_panel.set_inventory(inv)


func _on_transfered_items(slot: InventorySlot, count: int = -1) -> void:
	_inventory_controller.move_item_in_inventories(slot, count)


func _on_inventory_display_duble_pressed(slot: InventorySlot) -> void:
	if not slot.get_data().is_pickable: return
	_on_transfered_items(slot)