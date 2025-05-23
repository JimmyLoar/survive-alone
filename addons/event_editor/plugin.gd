@tool
extends EditorPlugin

const EditorViewScene = preload("res://!tools/event_editer/event_editor_view.tscn")


var editor_view: EventEditorView


func _enter_tree():	
	Engine.set_meta("EventEditorPlugin", self)
	editor_view = EditorViewScene.instantiate() as EventEditorView
	EditorInterface.get_editor_main_screen().add_child(editor_view)
	_make_visible(false)


func _exit_tree() -> void:
	Engine.remove_meta("EventEditorPlugin")
	if is_instance_valid(editor_view):
		editor_view.queue_free()


func get_version() -> String:
	var config: ConfigFile = ConfigFile.new()
	config.load(get_plugin_path() + "/plugin.cfg")
	return config.get_value("plugin", "version")


func get_plugin_path() -> String:
	return get_script().resource_path.get_base_dir()


func _has_main_screen() -> bool:
	return true


func _make_visible(next_visible: bool) -> void:
	if is_instance_valid(editor_view):
		editor_view.visible = next_visible


func _get_plugin_name() -> String:
	return "EventEditor"


func _get_plugin_icon() -> Texture2D:
	return null


func _apply_changes() -> void:
	editor_view.apply_changes()


func _handles(object: Object) -> bool:
	return object is EventResource


func _edit(object: Object) -> void:
	if is_instance_valid(editor_view) and is_instance_valid(object):
		editor_view.load_resource(object as EventResource)
