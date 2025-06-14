class_name QuestCondition extends QuestNode


enum ValueType {
	BOOLEAN,
	STRING,
	INTEGER,
}


enum TypeVariants{
	none,
	change_location,
	inventory,
	item,
	battle,
	property,
}


const KEYS = {
	TypeVariants.none: [],
	TypeVariants.change_location: [&"any", &"structure", &"biome"],
	TypeVariants.inventory: [&"add_item", &"has_item", &"remove_item"],
	TypeVariants.item: [&"has", &"take", &"remove"],
	TypeVariants.battle: [&"finish", &"win", &"lose"],
	TypeVariants.property: [&"has", &"change",],
}



@export var type: TypeVariants
@export var key: String = ""


var value: Variant:
	get: return get_meta("value")


func update() -> void:
	if not get_completed():
		Questify.condition_query_requested.emit(type, key, value, self)


func set_completed(new_value: bool) -> void:
	completed = new_value
