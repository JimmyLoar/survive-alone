extends ContentMenu

@export var inventory_name: String = '': set = set_name_inventory

@onready var inventory_display: InventoryDisplay = $MarginContainer/HBoxContainer/MainContainer/InventoryDisplay
@onready var item_information_panel: ItemInfoPanel = $MarginContainer/HBoxContainer/SubContainer/ItemInformationPanel


func _init() -> void:
	name = "Inventory"


func _ready() -> void:
	item_information_panel.transfered_items.connect(_on_transfered_items)
	var inventory := InventoriesController.get_inventory(inventory_name)
	inventory_display.set_inventory(inventory)
	item_information_panel.set_inventory(inventory)


func set_name_inventory(value):
	inventory_name = value
	if not inventory_display:
		return
	
	var inv: Inventory = InventoriesController.get_inventory(inventory_name)
	inventory_display.set_inventory(inv)
	logger.debug("Getting inventory with name '%s'" % inventory_name)


func _on_transfered_items(inv_name: String, slot: Dictionary, count: int) -> void:
	var index = inventory_display.get_last_pressed()
	InventoriesController.move_item_in_inventories(inventory_name, inv_name, index, count)


func _on_inventory_display_duble_pressed(slot: Dictionary) -> void:
	if not slot.item.is_pickable: return
	_on_transfered_items(item_information_panel.transfer_inv_name, slot, -1)
