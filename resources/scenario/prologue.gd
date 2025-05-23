static var quests = {
	"prologue_0": [["event", "event_prologue_2"]],
	"prologue_1": [["event", ""]],
	"prologue_2": [["event", ""]],
}

static var events = {
	"prologue_0": [["quest", "prologue_0"]],
	"prologue_1": [["quest", ""]],
	"prologue_2": [["quest", ""]],
}


static func has_quest(quest_name: String):
	return quests.has(quest_name)


static func has_event(event_name: String):
	return events.has(event_name)


static func get_next(type: String, name: String) -> Array:
	match type:
		"event": return events[name]
		"quest": return quests[name]
	return []
