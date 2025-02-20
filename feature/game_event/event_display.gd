class_name EventDisplay 
extends PanelContainer

@onready var texture_rect: TextureRect = %TextureRect
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var item_list: ItemList = %ItemList



func _ready() -> void:
	var test = _get_test_resource()


func _get_test_resource() -> EventResource:
	var event := EventResource.new("Test")
	var start_id = event.add_stage("start", "start event -_-")
	var left_id = event.add_stage("left", "left side")
	var right_id = event.add_stage("right", "right_side")
	var finish_id = event.add_stage("finish", "finished")
	
	event.add_action(start_id, "[turn left]", left_id)
	event.add_action(start_id, "[turn right]", right_id)
	event.add_action(left_id, "Im sad(", finish_id, true)
	event.add_action(right_id, "Im fun)", finish_id, true)
	event.add_action(finish_id, "[exit]", -1, true)
	return event
