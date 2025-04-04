@tool
class_name EventEdge 
extends Resource

enum EdgeType {
	NORMAL,
	CONDITIONAL,
}


@export var from: EventNode
@export var to: EventNode
@export var edge_type: EdgeType
