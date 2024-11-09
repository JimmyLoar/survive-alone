class_name PageController
extends HBoxContainer

signal changed_page(new_page: int)

@export_range(1, pow(2, 16)) var page_size: int = 1 : set = set_page_size
@export var currect_page: int = 0: set = set_page
		
@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_READ_ONLY + PROPERTY_USAGE_EDITOR
	) var max_page: int = 0
@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_READ_ONLY + PROPERTY_USAGE_EDITOR
	) var inventory_size: int = 1: set = set_inventory_size

@onready var currect_page_label: Label = $CurrectPageLabel

func _ready() -> void:
	set_page(max_page)


func set_page_size(value: int):
	page_size = max(value, 1)
	update_max_page()


func set_inventory_size(value):
	inventory_size = max(value, 1)
	update_max_page()


func update_max_page():
	max_page = ceili(inventory_size / page_size)


func set_page(new_page: int):
	currect_page = clampi(new_page, 0, max_page)
	changed_page.emit(currect_page)
	if currect_page_label:
		currect_page_label.set_text("%d" % [currect_page + 1])


func _on_back_page_button_pressed() -> void:
	var new_page = currect_page - 1
	$BackPageButton.disabled = new_page <= 0
	set_page(new_page)


func _on_next_page_button_pressed() -> void:
	var new_page = currect_page + 1
	$NextPageButton.disabled = currect_page >= max_page
	set_page(new_page)
