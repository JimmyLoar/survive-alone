extends "res://core/scenes/ui/content_menus/cm_inventory.gd"


func _init() -> void:
	name = "Location"


func update_inventory():
	var inv: Inventory = _inventory_controller.get_location_inventory()
	inventory_display.set_inventory(inv)
	item_information_panel.set_inventory(inv)


func _on_transfered_items(slot: InventorySlot, count: int = -1) -> void:
	_inventory_controller.move_item_in_inventories(slot, count, false)


func _on_visibility_changed() -> void:
	if not is_node_ready(): return
	update_inventory()
