class_name BiomeSerchEventResource
extends EventResource

enum Tags{
	nothing, 		#ничего
	trees, 			#деревья
	water, 			#вода
	flower_meadow,	#цветочное поле
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

@export var tags : Array[Tags] = [Tags.nothing]
@export var weith := 5
 


func _init(_name: String, stages_count: int = 1, middle_weith: int = 5) -> void:
	super(_name, stages_count)
	STAGE
