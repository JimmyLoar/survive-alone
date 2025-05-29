class_name QuestEnd extends QuestNode

enum Next{NONE, QUEST, EVENT}

@export var next_type: Next = Next.EVENT
@export var next_name: String
 

func get_active() -> bool:
	return all_previous_nodes_completed()


func get_completed() -> bool:
	return get_active()


func update() -> void:
	if get_completed():
		_graph.complete_quest()
