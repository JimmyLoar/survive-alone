class_name ItemInfoPanel
extends MarginContainer


#signal remove_items(item_list: Array)
#signal add_items(item_list: Array)
#signal transfered_items(item: ItemEntity, count: int)



@onready var name_label: Label = %NameLabel
@onready var text_label: RichTextLabel = %RichTextDiscription
@onready var interactive_container: VBoxContainer = $VBoxContainer/ScrollContainer/VBoxContainer
@onready var bottom_actions: Node = $VBoxContainer/Buttons


var _last_item: ItemEntity

func _ready() -> void:
	update()

func set_bottom_actions(actions: Array):
	for old_action in bottom_actions.get_children():
		old_action.queue_free()

	for action in actions:
		var button = ActionButton.new()
		button.text = action.text
		button.connect("pressed", Callable(func(): action.on_pressed.callv([_last_item])))
		button.can_view = action.can_view
		bottom_actions.add_child(button)

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
	_update_interaction_panel(item)


func _update_in_null():
	get_parent().current_tab = 0
	_last_item = null
	name_label.hide()
	interactive_container.hide()
	bottom_actions.hide()


func _on_changed_value(value):
	if value <= 0:
		_update_in_null()


func _update_display(item: ItemEntity):
	var data: ItemResource = item.get_resource()
	name_label.text = "%s" % data.visible_name
	text_label.clear()
	text_label.append_text("%s" % data.discription)
	get_parent().current_tab = get_index()
	name_label.show()
	bottom_actions.show()

	for action_button: ActionButton in bottom_actions.get_children():
		if action_button.can_view.call(item):
			action_button.show()
		else:
			action_button.hide()


func _update_durability_text(item: ItemEntity):
	text_label.newline()
	var value := item.get_resource().durability
	if not item.get_used().is_empty(): 
		value = item.get_used().front()
	if value <= 0: return
	text_label.append_text("Durability: %d" % value)


func _update_interaction_panel(item: ItemEntity):
	var actions: Array[ActionAggregate] = item.get_resource().actions
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


func _on_reduced_self() -> void:
	if not _last_item.is_empty():
		_last_item.increase_total_amount(-1)
	
	if _last_item.is_empty():
		update()
