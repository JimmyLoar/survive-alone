class_name PageController
extends HBoxContainer

signal changed_page(new_page: int)

var _entity: InventoryEntity
var _max_page: int = 1

@onready var _page_label: Label = $PageLabel


var page_size = 1:
	set(value):
		page_size = max(value, 1)
		update_max_page()

var page: int = 1:
	set(value):
		page = value
		_page_display()
		changed_page.emit(page)


func set_entity(_new: InventoryEntity):
	_entity = _new
	update_max_page()
	page_reset()


func update_max_page():
	if not _entity:
		_max_page = page_size + 1
		return
	
	_max_page = ceili(_entity.items.size() / float(page_size))


func page_up():
	page = min(page + 1, _max_page)


func page_down():
	page = max(page - 1, 1) 


func page_reset():
	page = 1 


func _page_display():
	visible = _max_page > 1
	_page_label.text = "%s" % page
	
