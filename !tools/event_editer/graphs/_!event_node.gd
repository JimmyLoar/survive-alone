@tool
class_name EventGraphNode
extends GraphNode

var id: String
var has_loaded_position := false
var _base_name: String


func _ready() -> void:
	var delete_button: Button = Button.new()
	var node_name_array: Array[StringName] = [name]
	delete_button.icon = get_theme_icon("Close", "EditorIcons")
	delete_button.pressed.connect(get_parent()._on_delete_nodes_request.bind(node_name_array))
	delete_button.size_flags_horizontal = SIZE_SHRINK_END
	get_titlebar_hbox().add_child(delete_button)
	_base_name = title


func get_model() -> EventNode:
	var node := _get_model()
	node.id = id
	node.graph_editor_position = position_offset
	if not size.is_zero_approx():
		node.graph_editor_size = size
	_set_model_properties(node)
	return node
	
	
func load_model(node: EventNode) -> void:
	id = node.id
	title += " (%s)" % id
	position_offset = node.graph_editor_position
	if not node.graph_editor_size.is_zero_approx():
		size = node.graph_editor_size
	has_loaded_position = true
	_get_model_properties(node)


func get_edge_type(next_node: EventGraphNode) -> EventEdge.EdgeType:
	return EventEdge.EdgeType.NORMAL


func _get_model() -> EventNode:
	return null
	
	
func _set_model_properties(_node: EventNode) -> void:
	pass
	
	
func _get_model_properties(_node: EventNode) -> void:
	pass
