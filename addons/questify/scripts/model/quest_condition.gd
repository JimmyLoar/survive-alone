class_name QuestCondition extends QuestNode


enum ValueType {
	BOOLEAN,
	STRING,
	INTEGER,
}


enum TypeVariants{
	none,
	location_change,
	search_finish,
	battle_finish,
	inventory_has,
	inventory_add,
	event_finished,
}


const KEYS = {
	TypeVariants.none: [],
	TypeVariants.location_change: [&"any", &"structure", &"biome"],
	TypeVariants.search_finish: [&"finish", &"item", &"item_amount"],
	TypeVariants.battle_finish: [&"win", &"lose", &""],
	TypeVariants.inventory_has: [&"item", &"item_amount"],
	TypeVariants.inventory_add: [&"item", &"item_amount"],
	TypeVariants.event_finished: [&"event", &"event_list"],
}

const HINTS = {
	TypeVariants.none: 				"""""",
	TypeVariants.location_change:	"""""",
	TypeVariants.search_finish:		"""""",
	TypeVariants.battle_finish:		"""""",
	TypeVariants.inventory_has:		"""""",
	TypeVariants.inventory_add:		"""""",
	TypeVariants.event_finished:	"""""",
}


@export var type: TypeVariants
@export var key: StringName = &""


var value: Variant:
	get: return get_meta("value")


func update() -> void:
	if not get_completed():
		Questify.condition_query_requested.emit(type, key, value, self)


func set_completed(new_value: bool) -> void:
	completed = new_value
