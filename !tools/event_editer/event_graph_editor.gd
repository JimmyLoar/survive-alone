@tool
class_name EventGraphEditor extends GraphEdit


const StartNodeScene = preload("uid://dkhtgmqtjt83l")
const TextNodeScene = preload("uid://m6ledbbrs2q4")
const NewSceneNodeScene = preload("uid://oxgje7b8st3c")
const EndNodeScene = preload("uid://bnf6ipbnvyj65")
const ActionsNodeScene = preload("uid://b8g6wavqx75ii")
const MainTextureNodeScene = preload("uid://bqnf6dvvd6n7")
const SubTextureNodeScene = preload("uid://dfk7mfh1i4yhp")
const ClearTextNodeScene = preload("uid://cp4d103yot38v")
const AbortNodeScene = preload("uid://ddhmoxckqyrvv")


var selected_nodes: Array[EventGraphNode] = []
var copied_nodes: Array[EventGraphNode] = []


func add_node(new_node: EventGraphNode, position_offset: Vector2) -> void:
	if new_node.id.is_empty():
		new_node.id = QuestifyNanoIdGenerator.generate(10)
	new_node.position_offset = position_offset
	if not new_node.has_loaded_position:
		new_node.position_offset += scroll_offset
		new_node.position_offset /= zoom
	add_child(new_node)


func clear() -> void:
	clear_connections()
	for node in get_child_nodes():
		remove_child(node)
		node.queue_free()


func save(path: String) -> int:
	var root := _serialize_resource()
	if root != null:
		var error := ResourceSaver.save(root, path)
		return error
	return ERR_CANT_CREATE


func load(path: String) -> EventResource:
	var resource := ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE) as EventResource
	load_resource(resource)
	return resource


func load_resource(resource: EventResource) -> void:
	_deserialize_resource(resource)


func get_child_nodes() -> Array:
	return find_children("", "EventGraphNode", false, false)
	
	
func _serialize_resource() -> EventResource:
	var start_nodes := find_children("", "EventStartNode", false, false)
	if start_nodes.size() != 1:
		# TODO: add better error handling
		printerr("Exactly one EventStartNode is required in a graph")
		return null
		
	var end_nodes := find_children("", "EventEndNode", false, false)
	if end_nodes.size() != 1:
		# TODO: add better error handling
		printerr("Exactly one EventEndNode is required in a graph")
		return null
	
	var connections := get_connection_list()
	var resource := EventResource.new()
	var edges: Array[EventEdge] = []
	resource.nodes.assign(_get_nodes(connections, edges))
	resource.edges = edges
	return resource
	
	
func _get_nodes(connections: Array[Dictionary], edges: Array[EventEdge]) -> Array[EventNode]:
	var created_nodes := {}
	for graph_node: EventGraphNode in get_child_nodes():
		created_nodes[graph_node.name] = graph_node.get_model()
	for connection in connections:
		var edge := EventEdge.new()
		edge.from = created_nodes[connection.from_node]
		edge.to = created_nodes[connection.to_node]
		edge.edge_type = connection.to_port as EventEdge.EdgeType
		edges.append(edge)
	
	var result: Array[EventNode] = []
	result.assign(created_nodes.values())
	return result


func _deserialize_resource(resource: EventResource) -> void:
	clear()
	var model_to_graph_node_map := {}
	for node in resource.nodes:
		var graph_node := _get_graph_node(node)
		add_node(graph_node, node.graph_editor_position)
		graph_node.load_model(node)
		model_to_graph_node_map[node] = graph_node
	
	for edge in resource.edges:
		connect_node(model_to_graph_node_map[edge.from].name, 0, model_to_graph_node_map[edge.to].name, edge.edge_type)


func _get_graph_node(node: EventNode) -> EventGraphNode:
	if node is EventStart:
		return StartNodeScene.instantiate()
	elif node is EventText:
		return TextNodeScene.instantiate()
	elif node is EventNewStene:
		return NewSceneNodeScene.instantiate()
	elif node is EventEnd:
		return EndNodeScene.instantiate()
	elif node is EventAction:
		return ActionsNodeScene.instantiate()
	elif node is EventMainTexture:
		return MainTextureNodeScene.instantiate()
	elif node is EventSubTexture:
		return SubTextureNodeScene.instantiate()
	elif node is EventAbort:
		return AbortNodeScene.instantiate()
	return null
	
	
func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	connect_node(from_node, from_port, to_node, to_port)


func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)


func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	var connections := get_connection_list()
	var connections_to_remove: Array[Dictionary] = []
	var nodes_to_remove: Array[EventGraphNode] = []
	for node in nodes:
		connections_to_remove.append_array(connections.filter(
			func(connection): return connection.from_node == node or connection.to_node == node
		))
		nodes_to_remove.append(get_node(NodePath(node)))
	var plugin = (Engine.get_meta("EventEditorPlugin") as EditorPlugin)
	var undo_redo := plugin.get_undo_redo()
	undo_redo.create_action("Delete Quest Nodes")
	undo_redo.add_do_method(self, "_delete_nodes", nodes_to_remove, connections_to_remove)
	undo_redo.add_undo_method(self, "_undo_delete_nodes", nodes_to_remove, connections_to_remove)
	undo_redo.commit_action()


func _on_copy_nodes_request() -> void:
	if selected_nodes.size() > 0:
		copied_nodes.clear()
		copied_nodes.assign(selected_nodes)


func _on_paste_nodes_request() -> void:
	if copied_nodes.size() > 0:
		var nodes_to_copy: Array[EventGraphNode] = []
		for node in copied_nodes:
			var new_node := node.duplicate(7) as EventGraphNode
			new_node.set_meta("original_offset", node.position_offset)
			nodes_to_copy.append(new_node)
		var undo_redo := (Engine.get_meta("EventEditorPlugin") as EditorPlugin).get_undo_redo()
		undo_redo.create_action("Paste Quest Nodes")
		undo_redo.add_do_method(self, "_paste_nodes", nodes_to_copy)
		undo_redo.add_undo_method(self, "_undo_paste_nodes", nodes_to_copy)
		undo_redo.commit_action()


func _on_node_selected(node: Node) -> void:
	if not selected_nodes.has(node):
		selected_nodes.append(node)


func _on_node_deselected(node: Node) -> void:
	if selected_nodes.has(node):
		selected_nodes.erase(node)	


func _delete_nodes(nodes: Array[EventGraphNode], connections: Array[Dictionary]) -> void:
	for connection in connections:
		disconnect_node(connection.from_node, connection.from_port, connection.to_node, connection.to_port)
	for node in nodes:
		node.selected = false
		remove_child(node)
	
	
func _undo_delete_nodes(nodes: Array[EventGraphNode], connections: Array[Dictionary]) -> void:
	for node in nodes:
		node.selected = true
		add_child(node)
	for connection in connections:
		connect_node(connection.from_node, connection.from_port, connection.to_node, connection.to_port)


func _paste_nodes(nodes: Array[EventGraphNode]) -> void:
	selected_nodes.clear()
	for node: EventGraphNode in get_child_nodes():
		node.selected = false
	var relative_base_position: Vector2 = copied_nodes.reduce(
		func(accum: Vector2, current_node: EventGraphNode):
			return accum + current_node.position_offset, 
		Vector2.ZERO
	) / copied_nodes.size()
	for node in nodes:
		var model := node.get_model()
		node.load_model(model)
		node.id = ""
		node.has_loaded_position = false
		add_node(node, get_local_mouse_position())
		node.position_offset += node.get_meta("original_offset", Vector2.ZERO) - relative_base_position
		node.selected = true
	
	
func _undo_paste_nodes(nodes: Array[EventGraphNode]) -> void:
	for node in nodes:
		node.selected = false
		remove_child(node)
