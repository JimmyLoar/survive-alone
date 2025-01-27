class_name ItemInfoPanel
extends MarginContainer

signal remove_items(item_list: Array)
signal add_items(item_list: Array)
signal transfered_items(item: ItemEntity, count: int)

@onready var name_label: Label = %NameLabel
@onready var text_label: RichTextLabel = %RichTextDiscription
@onready var interactive_container: VBoxContainer = $VBoxContainer/ScrollContainer/VBoxContainer
@onready var pick_up_button: Button = $VBoxContainer/Buttons/PickUpButton


@onready var inventory: InventoryState: 
	set = set_inventory

var _last_item: ItemEntity
var _quantity_selecter: QuantitySelecter

func _ready() -> void:
	update()


func update(item: ItemEntity = null):
	if not item or _last_item == item:
		_update_in_null()
		return
	
	if not item.changed_durability.is_connected(_update_durability_text):
		item.changed_durability.connect(_update_durability_text)
		item.changed_amount.connect(_on_changed_value)
	
	if _last_item:
		_last_item.changed_durability.disconnect(_update_durability_text)
		_last_item.changed_amount.disconnect(_on_changed_value)
	
	_last_item = item
	_update_display(item)
	_update_durability_text(item)
	_update_interaction_panel(item.get_resource().actions)
	
	pick_up_button.visible = item.get_resource().is_pickable
	Injector.provide(ItemEntity, _last_item, self)


func _update_in_null():
	get_parent().current_tab = 0
	_last_item = null
	name_label.hide()
	interactive_container.hide()
	pick_up_button.hide()


func _on_changed_value(value):
	if value <= 0:
		_update_in_null()


func _update_display(item: ItemEntity):
	var data: ItemResource = item.get_resource()
	name_label.text = "%s" % data.name_key
	text_label.clear()
	text_label.append_text("%s" % data.discription)
	get_parent().current_tab = get_index()
	name_label.show()
	pick_up_button.show()
	#show()


func _update_durability_text(item: ItemEntity):
	text_label.newline()
	var value := item.get_resource().durability
	if not item.get_used().is_empty(): 
		value = item.get_used().front()
	if value <= 0: return
	text_label.append_text("Durability: %d" % value)


func _update_interaction_panel(actions: Array[ItemActionResource]):
	for i in interactive_container.get_child_count() - 1:
		var child := interactive_container.get_child(i + 1) as ItemAction
		if not child:
			continue
		
		if i >= actions.size():
			child.hide()
			continue
		
		child.display(actions[i])
		child.show()
	interactive_container.show()


func set_inventory(new_inv: InventoryState):
	inventory = new_inv
	update()


func _on_reduced_self() -> void:
	if not _last_item.is_empty():
		_last_item.increase_total_amount(-1)
	
	if _last_item.is_empty():
		update()


func _on_pick_up_button_pressed() -> void:
	return
	#if not _quantity_selecter:
		#_quantity_selecter = #Game.get_world_screen().get_quantity_selecter()
	#_quantity_selecter.canseled.connect(_on_selecter_canseled, CONNECT_ONE_SHOT)
	#_quantity_selecter.confirmed_value.connect(_on_selecter_confirmed_value, CONNECT_ONE_SHOT)
	#_quantity_selecter.enable(_last_item.get_total_amount())


func _on_selecter_confirmed_value(value: int):
	_quantity_selecter.canseled.disconnect(_on_selecter_canseled)
	transfered_items.emit(self._last_item, value)
	if value >= _last_item.get_total_amount():
		update()


func _on_selecter_canseled():
	_quantity_selecter.confirmed_value.disconnect(_on_selecter_confirmed_value)
