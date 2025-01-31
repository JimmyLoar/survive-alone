@tool
class_name ItemResource
extends MyResource


@export var texture: Texture = preload("res://icon.svg")
@export var rare := Rare.NORMAL
@export_range(-1, 65536) var durability := -1
@export var is_pickable := true 

@export var actions: Array[ItemActionResource] = [] 


func _init() -> void:
	super("ItemResource")


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


func get_color():
	return RARE_COLOR[rare]


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	return properties
