extends ContentMenu

@export var inventory_name: String = '': set = set_name_inventory

@onready var inventory_display: InventoryDisplay = $MarginContainer/HBoxContainer/MainContainer/InventoryDisplay
@onready var item_information_panel: ItemInfoPanel = $MarginContainer/HBoxContainer/SubContainer/ItemInformationPanel

func _init() -> void:
	name = "Inventory"


func _ready() -> void:
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