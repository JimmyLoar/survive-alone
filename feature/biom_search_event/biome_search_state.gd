class_name BiomeSearchState
extends Injectable

var events_list: BiomeSearchList 

var _ui_node: Node


func _init(_ui: Node) -> void:
	_ui_node = _ui
	var event_creater := preload("res://feature/biom_search_event/test/event_creater.gd").new()
	#print(events_list.events)
	events_list = event_creater.get_event_list()


func show_ui():
	_ui_node.show()


func select_event() -> BiomeSerchEventResource:
	var event = events_list.get_selected_event()
	return event
