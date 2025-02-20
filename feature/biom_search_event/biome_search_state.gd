class_name BiomeSearchState
extends Injectable

signal finished_event()
signal started_event()


var events_list: BiomeSearchList 

var currect_event: BiomeSearchEventResource
var currect_stage: int = -1

var _ui_node: BiomeSearchUI


func _init(_ui: BiomeSearchUI) -> void:
	_ui_node = _ui
	var event_creater := preload("res://feature/biom_search_event/test/event_creater.gd").new()
	events_list = event_creater.get_event_list()


func open():
	_ui_node.open()


func go_to(next: int):
	currect_stage = next
	if currect_stage == -1:
		finished_event.emit(currect_event)
		currect_event = null


func select_event() -> BiomeSearchEventResource:
	currect_event = events_list.get_event() 
	currect_stage = 0
	started_event.emit(currect_event)
	return currect_event
