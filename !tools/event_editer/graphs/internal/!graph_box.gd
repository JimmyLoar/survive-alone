@tool
class_name EventGraphBox
extends EventGraphNode


@export var container: Container
@export var add_button: Button
@export var item_scene: PackedScene


func _ready() -> void:
	super()
	add_button.pressed.connect(_add_item)
	_add_item()


func _add_item():
	var new_item = item_scene.instantiate()
	container.add_child(new_item)
	if new_item.has_signal("request_to_remove"):
		new_item.request_to_remove.connect(_remove_item.bind(new_item))
	_update_all()
	return new_item


func _remove_item(_item: Container):
	container.remove_child(_item)
	_item.queue_free()
	_update_all()


func _update_all():
	for item in container.get_children():
		item.update()


func _get_item(index: int) -> Container:
	if index < container.get_child_count():
		return container.get_child(index)
	return _add_item()
