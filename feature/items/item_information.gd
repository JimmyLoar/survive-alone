class_name ItemInformation
extends MarginContainer


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
	
	if not item.get_storage().quantity_changed.is_connected(_update_durability_text):
		item.get_storage().quantity_changed.connect(_update_durability_text)
		item.get_storage().quantity_changed.connect(_on_changed_value.bind(item.get_storage()))
	
	if _last_item:
		_last_item.get_storage().quantity_changed.disconnect(_update_durability_text)
		_last_item.get_storage().quantity_changed.disconnect(_on_changed_value.bind(_last_item.get_storage()))
	
	_last_item = item
	_update_display(item)
	_update_durability_text(item)
	_update_interaction_panel(item)


func _update_in_null():
	_last_item = null
	name_label.hide()
	interactive_container.hide()
	bottom_actions.hide()


func _on_changed_value(value, storage: StorageComponent):
	if storage.get_amount() <= 0:
		_update_in_null()


func _update_display(entity: ItemEntity):
	var data: ItemResource = entity.get_resource()
	name_label.text = "%s" % [data.visible_name]
	text_label.clear()
	text_label.append_text("%s: %d" % ["Количество", entity.get_storage().get_amount()])
	name_label.show()
	bottom_actions.show()

	for action_button: ActionButton in bottom_actions.get_children():
		if action_button.can_view.call(entity):
			action_button.show()
		else:
			action_button.hide()


func _update_durability_text(item: ItemEntity):
	var data = item.get_storage().serialize()
	if not data.has("array"):
		return
	
	var value := data.array.front() as int
	text_label.newline()
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
