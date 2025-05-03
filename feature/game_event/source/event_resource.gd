@tool
class_name EventResource
extends Resource

enum Tags{
	nothing, 		#ничего
	quest,			#
	trees, 			#деревья
	water, 			#вода
	flower,			#цветы
	berries,		#ягоды
	mushrooms, 		#грибы
	plants,			#травы
	herbivorous,	#травоядные жевотные
	carnivores,		#хищьники
	large_animals, 	#крупные звери
	small_animals, 	#небольшие звери
	ruins,  		#руины
	location,		#локация
}

@export var nodes: Array[EventNode] = []
@export var edges: Array[EventEdge] = []
@export var groups: Array[Tags] = []


var name: String:
	get: return start_node.get_event_name()

var description: String:
	get: return start_node.get_event_discription()

var start_node: EventStart

var started: bool:
	get: return start_node.active

var completed: bool = false
var is_instance := false


func instantiate() -> EventResource:
	if is_instance:
		return self
	var instance := duplicate(true) as EventResource

	var duplicated_nodes: Array[EventNode] = []
	var duplicated_edges: Array[EventEdge] = []

	var node_map := {}
	# Arrays cannot be duplicated in resources, so duplicate them manually
	for node in nodes:
		var new_node := node.duplicate(true)
		node_map[node] = new_node
		duplicated_nodes.append(new_node)
	for edge in edges:
		var new_edge: EventEdge = edge.duplicate(true)
		# assign new references for edges
		if edge.from != null:
			new_edge.from = node_map[edge.from]
		if edge.to != null:
			new_edge.to = node_map[edge.to]
		duplicated_edges.append(new_edge)

	instance.nodes = duplicated_nodes
	instance.edges = duplicated_edges

	instance.is_instance = true
	instance.set_meta("resource_path", resource_path)
	instance._initialize()
	return instance


func start() -> void:
	if not is_instance:
		printerr("Quest must be instantiated to be started. Use instantiate().")
		return
	if not completed and not started:
		start_node.active = true


func update() -> void:
	if not is_instance:
		printerr("Quest must be instantiated to be updated. Use instantiate().")
		return
	if not completed:
		start_node.update()


func get_active_nodes() -> Array[EventNode]:
	var active_nodes: Array[EventNode] = []
	for node in nodes:
		if node is EventNode and node.get_active() and node is not EventStart:
			active_nodes.append(node)
	#printerr("Active: %s" % [active_nodes.map(func(a): return a.id)])
	return active_nodes


func get_next_nodes(node: EventNode, edge_type: EventEdge.EdgeType = EventEdge.EdgeType.NORMAL) -> Array[EventNode]:
	var result: Array[EventNode] = []
	result.assign(edges.filter(
		func(edge: EventEdge):
			return edge.from == node and edge.edge_type == edge_type
	).map(
		func(edge: EventEdge):
			return edge.to
	))
	return result


func get_next_actions(node: EventNode) -> Array[EventAction]:
	var result: Array[EventAction] = []
	for next_node: EventNode in get_next_nodes(node):
		var action = get_previous_nodes(next_node, EventEdge.EdgeType.ACTION)
		result.append_array(action)
	return result


func get_previous_nodes(node: EventNode, edge_type: EventEdge.EdgeType = EventEdge.EdgeType.NORMAL) -> Array[EventNode]:
	var result: Array[EventNode] = []
	result.assign(edges.filter(
		func(edge: EventEdge):
			return edge.to == node and edge.edge_type == edge_type
	).map(
		func(edge: EventEdge):
			return edge.from
	))
	return result


func complete_stage(stage: EventStage):
	stage.completed = true
	EventsGlobal.completed_stage.emit(stage)


func complete_event():
	completed = true
	EventsGlobal.completed_event.emit(self)


func action_press(action: EventAction) -> Array:
	var _result = []
	if action.action:
		_result = action.action.execute()
		action.completed = not _result.is_empty()
	
	else:
		action.completed = true
	
	update()
	return _result


func get_resource_path() -> String:
	if is_instance:
		return get_meta("resource_path")
	return resource_path


func serialize() -> Dictionary:
	return {
		completed = completed,
		nodes = nodes.map(func(node: EventNode): return node.serialize())
	}


func deserialize(data: Dictionary) -> void:
	if not is_instance:
		printerr("Quest must be instantiated to be deserialized. Use instantiate().")
		return
	
	completed = data.completed
	var node_map := {}
	for node in nodes:
		node_map[node.id] = node
	for node in data.nodes:
		if node_map.has(node.id):
			node_map[node.id].deserialize(node)


func _initialize() -> void:
	for node in nodes:
		node.set_graph(self)
		if node is EventStart:
			start_node = node as EventStart
