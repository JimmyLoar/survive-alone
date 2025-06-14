@tool
class_name ItemResource
extends NamedResource


@export var texture: Texture = preload("res://icon.svg")
@export var rare := Rare.NORMAL
@export var is_pickable := true 
@export var actions: Array[ActionAggregate] = [] 
@export var categories: Array[Category] = []

@export_enum("Amount:-1", "Durability:-2") var storage_component := -1:
	set(value):
		storage_component = value
		notify_property_list_changed()
@export var components: Array[Components] = []

@export_group("Durability", "durability_")
var durability_max := -1
var durability_mode := DurabilityStorageComponent.Mode.LOW_FIRST


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

enum Components{
	TOOL, 		# использование в других действиях
	WEAPON, 	# использование как оружие
	EXPIRED,	# может изменится со времянем
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
	properties.append_array(_get_storage_properties())
	return properties


func _get_storage_properties() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	match storage_component:
		-1:
			pass
		-2:
			var property = PropertyGenerater.take_int("durability_max")
			properties.append(PropertyGenerater.convent_to_range(property, -1, 65536))
			property = PropertyGenerater.take_int("durability_mode")
			properties.append(PropertyGenerater.convert_to_enum(property, ",".join(DurabilityStorageComponent.Mode.keys())))
	return properties


func _get_icon() -> Texture2D:
	return texture
