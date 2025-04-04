@tool
class_name EventResource
extends NamedResource

enum Tags{
	nothing, 		#ничего
	quest,			#
	trees, 			#деревья
	water, 			#вода
	flower,			#цветы
	berries,		#ягоды
	mushrooms, 		#грибы
	plants,			#травы
	herbivorous,	#травоядные жевотные
	carnivores,		#хищьники
	large_animals, 	#крупные звери
	small_animals, 	#небольшие звери
	ruins,  		#руины
	location,		#локация
}

@export var stages: Array = []
@export var edges: Array = []
@export var groups: Array[Tags] = []
var _ids: PackedStringArray = []


func _init(_name: String = "", stages_count: int = 1) -> void:
	super("EVENT")
	code_name = _name
	
