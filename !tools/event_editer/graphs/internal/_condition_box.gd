@tool
class_name Condition
extends GraphBoxItem


var resource: ExecuteKeeperResource

@export var label: RichTextLabel
@export var remove_button: Button


func _ready() -> void:
	update()


func update():
	remove_button.visible = not (get_index() == 0 and get_parent().get_child_count() == 1)
	if not resource:
		resource = ExecuteKeeperResource.new()
		resource.changed.connect(update_text)
		update_text()


func _set_data(new_resource):
	resource = new_resource as ExecuteKeeperResource
	update_text()


func _get_data():
	return resource


func update_text():
	var text = ""
	if resource:
		for i in resource.args_data.size():
			text += "[cell]    %s:[/cell][cell][color=yellow]   %s[/color][/cell]" % [resource.get_name_values()[i], resource.args_data[i]]
		text = "[color=green]%s:\n[color=gray][table=2]%s[/table][/color]" % [resource.name, text]
	label.text = text 


func _on_edit_button_pressed() -> void:
	var inspector = EditorInterface.get_inspector()
	inspector.edit(resource)


func _on_remove_button_pressed() -> void:
	request_to_remove.emit()
