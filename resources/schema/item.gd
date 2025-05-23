@tool
class_name ItemResource
extends NamedResource


@export var texture: Texture = preload("res://icon.svg")
@export var rare := Rare.NORMAL
@export_range(-1, 65536) var durability := -1
@export var is_pickable := true 

@export var actions: Array[ActionAggregate] = [] 

@export var categories: Array[Category] = []

func _init() -> void:
	super("Item")


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

enum Category{
	MATERIAL,
	TOOL,
	FOOD,
	MEDICINE,
	BUILDING,
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


func get_color():
	return RARE_COLOR[rare]


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	return properties
	
func _get_icon() -> Texture2D:
	return texture
