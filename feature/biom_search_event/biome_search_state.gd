class_name BiomeSearchState
extends Injectable

signal finished_event()
signal started_event()


var events_list: BiomeSearchList 

var _ui_node: BiomeSerchUI

var currect_event: BiomeSerchEventResource
var currect_stage: int = -1

func _init(_ui: BiomeSerchUI) -> void:
	_ui_node = _ui
	var event_creater := preload("res://feature/biom_search_event/test/event_creater.gd").new()
	#print(events_list.events)
	events_list = event_creater.get_event_list()


func open():
	_ui_node.open()


func go_to(action_index: int):
	currect_stage = currect_event.get_action_next_stage(currect_stage, action_index)
	if currect_stage == -1:
		finished_event.emit(currect_event)
		currect_event = null


func select_event() -> BiomeSerchEventResource:
	currect_event = events_list.get_selected_event() 
	currect_stage = 0
	started_event.emit(currect_event)
	return currect_event
