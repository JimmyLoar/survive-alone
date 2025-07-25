class_name ConditionManager
extends Node


signal conditions_updated()
signal tag_added(tag: String)
signal tag_removed(tag: String)

var active_tags: Dictionary = {}  # { "tag": weight }


func add_tag(tag: String, weight: float = 1.0) -> void:
	active_tags[tag] = weight
	conditions_updated.emit()
	tag_added.emit(tag)


func remove_tag(tag: String) -> void:
	if active_tags.erase(tag):
		conditions_updated.emit()
		tag_removed.emit(tag)


func clear_tags(prefix: String = "") -> void:
	var to_remove = []
	for tag in active_tags:
		if prefix.is_empty() or tag.begins_with(prefix):
			to_remove.append(tag)
	
	for tag in to_remove:
		remove_tag(tag)


func clear_all_tags():
	active_tags.clear()
	conditions_updated.emit()
