class_name ConditionManager
extends Node

# Словарь активных тегов: { "тег": вес }
var active_tags: Dictionary = {}

# Сигнал при изменении условий
signal conditions_updated()
signal music_conditions_updated()  


func add_tag(tag: String, weight: float = 1.0) -> void:
	active_tags[tag] = weight
	conditions_updated.emit()
	music_conditions_updated.emit()

# Удаляет тег
func remove_tag(tag: String) -> void:
	if active_tags.erase(tag):
		conditions_updated.emit()
		music_conditions_updated.emit()

# Очищает все теги определённой группы (например, "погода")
func clear_tags(prefix: String) -> void:
	var tags_to_remove = []
	for tag in active_tags:
		if tag.begins_with(prefix):
			tags_to_remove.append(tag)
	
	for tag in tags_to_remove:
		active_tags.erase(tag)
	
	if tags_to_remove.size() > 0:
		conditions_updated.emit()
		music_conditions_updated.emit()
