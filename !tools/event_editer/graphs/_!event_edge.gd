@tool
class_name EventEdge 
extends Resource

enum EdgeType {
	NORMAL = 0,
	ACTION = 1,
	CONDITIONAL = 2,
	EFFECT = 2,
}


@export var from: EventNode
@export var to: EventNode
@export var edge_type: EdgeType
