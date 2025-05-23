var quests = {
	"prologue_0": ["event", ""],
	"prologue_1": ["event", ""],
	"prologue_2": ["event", ""],
}

var events = {
	"event_prologue_1": ["event", ""],
	"event_prologue_2": ["event", ""],
	"event_prologue_3": ["event", ""],
}


func has_quest(quest_name: String):
	return quests.has(quest_name)


func has_event(event_name: String):
	return events.has(event_name)


func get_next():
	pass
