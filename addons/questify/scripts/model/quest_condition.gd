class_name QuestCondition extends QuestNode


enum ValueType {
	BOOLEAN,
	STRING,
	INTEGER,
}


enum TypeVariants{
	none,
	change_location,
	var_3,
	var_4,
	var_5,
	
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
