class_name ItemData
extends Resource

@export_placeholder("Item N") var name: String
@export_multiline var discription: String = ""
@export var texture: Texture = preload("res://icon.svg")
@export var rare := Rare.NORMAL
@export_range(-1, 65536) var durability := -1


#"health', "hunger", "thirst", "fatigue", "radiation", "psych",
@export_category("Action")
@export_group("Action #1", "action1")
@export var action1_name: String = "Action"
@export_enum(
		"health",
		"hunger",
		"thirst",
		"fatigue",
		"radiation",
		"psych",
	) var action1_property_names: Array[String] = []
@export var action1_property_value: Array[int] = []


enum Rare{
	GARBAGE, # Мусор или бесполезный хлам
	NORMAL,  # Обычные предметы - ресурсы
	UNIQUE,  # 
	RARE,    #   
	EPIC,    #
	LEGAND,  #
	MYTH,    #
	RARITY,  #
}

const RARE_COLOR = {
	Rare.GARBAGE:Color.WEB_GRAY,
	Rare.NORMAL: Color.WHITE,
	Rare.UNIQUE: Color.LIME_GREEN, 
	Rare.RARE:   Color(0.2695, 0.7771, 0.9844, 1),
	Rare.EPIC:   Color.MEDIUM_PURPLE,
	Rare.LEGAND: Color(0.9725, 1, 0.5098, 1),
	Rare.MYTH:   Color.RED,
	Rare.RARITY: Color.DEEP_PINK,
}


func is_used_property():
	return not action1_property_names.is_empty()


func get_color():
	return RARE_COLOR[rare]
