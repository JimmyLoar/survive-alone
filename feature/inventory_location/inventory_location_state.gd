class_name InventoryLocationState
extends Inventory

signal search_drop_changed(value: SearchDropResource)
var search_drop: SearchDropResource = null:
	get:
		return search_drop
	set(value):
		search_drop = value
		search_drop_changed.emit(value)
