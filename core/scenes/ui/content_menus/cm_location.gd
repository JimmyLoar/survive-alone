extends "res://core/scenes/ui/content_menus/cm_inventory.gd"


func _init() -> void:
	name = "Location"


func update_inventory():
	var inv: Inventory = InventoriesController.get_location_inventory()
	inventory_display.set_inventory(inv)
	item_information_panel.set_inventory(inv)


func _on_transfered_items(slot: InventorySlot, count: int = -1) -> void:
	InventoriesController.move_item_in_inventories(slot, count, false)
