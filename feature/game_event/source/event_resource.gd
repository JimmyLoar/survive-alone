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

@export var stages: Array[EventNode] = []
@export var edges: Array[EventEdge] = []
@export var groups: Array[Tags] = []
var _ids: PackedStringArray = []


var name: String:
	get: return start_node.get_event_name()

var description: String:
	get: return start_node.get_event_discription()

var start_node: StartEventNode

var started: bool:
	get: return start_node.active

var completed: bool = false
var is_instance := false


func instantiate() -> EventResource:
	if is_instance:
		return self
	var instance := duplicate(true) as EventResource

	var duplicated_stages: Array[EventNode] = []
	var duplicated_edges: Array[EventEdge] = []

	var node_map := {}
	# Arrays cannot be duplicated in resources, so duplicate them manually
	for stage in stages:
		var new_node := stage.duplicate(true)
		node_map[stage] = new_node
		duplicated_stages.append(new_node)
	for edge in edges:
		var new_edge: EventEdge = edge.duplicate(true)
		# assign new references for edges
		if edge.from != null:
			new_edge.from = node_map[edge.from]
		if edge.to != null:
			new_edge.to = node_map[edge.to]
		duplicated_edges.append(new_edge)

	instance.stages = duplicated_stages
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


func get_active_stages() -> Array[StageEventNode]:
	var active_stages: Array[StageEventNode] = []
	for stage in stages:
		if stage is StageEventNode and stage.get_active():
			active_stages.append(stage)
	return active_stages


func get_next_stages(stage: EventNode, edge_type: EventEdge.EdgeType = EventEdge.EdgeType.NORMAL) -> Array[EventNode]:
	var result: Array[EventNode] = []
	result.assign(edges.filter(
		func(edge: EventEdge):
			return edge.from == stage and edge.edge_type == edge_type
	).map(
		func(edge: EventEdge):
			return edge.to
	))
	return result


func get_previous_stages(stage: EventNode, edge_type: EventEdge.EdgeType = EventEdge.EdgeType.NORMAL) -> Array[EventNode]:
	var result: Array[EventNode] = []
	result.assign(edges.filter(
		func(edge: EventEdge):
			return edge.to == stage and edge.edge_type == edge_type
	).map(
		func(edge: EventEdge):
			return edge.from
	))
	return result


func get_resource_path() -> String:
	if is_instance:
		return get_meta("resource_path")
	return resource_path


func serialize() -> Dictionary:
	return {
		completed = completed,
		stages = stages.map(func(stage: EventNode): return stage.serialize())
	}


func deserialize(data: Dictionary) -> void:
	if not is_instance:
		printerr("Quest must be instantiated to be deserialized. Use instantiate().")
		return
	completed = data.completed
	var node_map := {}
	for stage in stages:
		node_map[stage.id] = stage
	for stage in data.stages:
		if node_map.has(stage.id):
			node_map[stage.id].deserialize(stage)


func _initialize() -> void:
	for stage in stages:
		stage.set_graph(self)
		if stage is StartEventNode:
			start_node = stage as StartEventNode
