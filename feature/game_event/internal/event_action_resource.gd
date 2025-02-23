@tool
class_name EventActionResource
extends ActionResource

const ACTION_START_EVENT = "START_EVENT"
const ACTION_START_EVENT_FROM_LIST = "START_EVENT_FOM_LIST"

var event: EventResource
var events_list: BiomeSearchList


func _init() -> void:
	super("EventAction")
	#Actions.merge({
		#START_EVENT = Utils.NUMB_POWERS_2[3],
		#START_EVENT_FOM_LIST = Utils.NUMB_POWERS_2[4],
	#})


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	#properties.append_array(super())
	#
	#if _is_type(type, Actions.START_EVENT):
		#properties.append(PropertyGenerater.take_resource("events_list", "EventResource"))
	#
	#if _is_type(type, Actions.START_EVENT_FOM_LIST):
		#properties.append(PropertyGenerater.take_resource("events_list", "EventList"))
	
	return properties
