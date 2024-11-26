extends ContentMenu

@export var transfer_inventory: NodePath

@onready var inventory_display: InventoryDisplay = $MarginContainer/HBoxContainer/MainContainer/InventoryDisplay
@onready var item_information_panel: ItemInfoPanel = $MarginContainer/HBoxContainer/SubContainer/ItemInformationPanel


func _init() -> void:
	name = "Inventory"


func _ready() -> void:
	item_information_panel.transfered_items.connect(_on_transfered_items)
	update_inventory()


func update_inventory():
	var inv: Inventory = InventoriesController.get_player_inventory()
	inventory_display.set_inventory(inv)
	item_information_panel.set_inventory(inv)


func _on_transfered_items(slot: InventorySlot, count: int = -1) -> void:
	InventoriesController.move_item_in_inventories(slot, count)


func _on_inventory_display_duble_pressed(slot: InventorySlot) -> void:
	if not slot.get_data().is_pickable: return
	_on_transfered_items(slot)
