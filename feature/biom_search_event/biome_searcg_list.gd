class_name BiomeSearchList
extends Resource


@export var base_tags_weight : Dictionary = {
	"trees": 0, 			#деревья
	"water": 0, 			#вода
	"flower": 0,			#цветы
	"berries": 0,			#ягоды
	"mushrooms": 0, 		#грибы
	"plants": 0,			#травы
	"herbivorous": 0,		#травоядные жевотные
	"carnivores": 0,		#хищьники
	"large_animals": 0, 	#крупные звери
	"small_animals": 0, 	#небольшие звери
	"ruins": 0,  			#руины
	"location": 0,			#локация
} 

@export var events_list: Array[BiomeSerchEventResource] = []

@export var events: Dictionary = {
	"trees": 0, 			#деревья
	"water": 0, 			#вода
	"flower": 0,			#цветы
	"berries": 0,			#ягоды
	"mushrooms": 0, 		#грибы
	"plants": 0,			#травы
	"herbivorous": 0,		#травоядные жевотные
	"carnivores": 0,		#хищьники
	"large_animals": 0, 	#крупные звери
	"small_animals": 0, 	#небольшие звери
	"ruins": 0,  			#руины
	"location": 0,			#локация
}




func _sort_events_for_tags(events: Array[BiomeSerchEventResource]):
	events.clear()
	for event in events:
		for tag in event.tags:
			events[tag] = event
	
	print(events)
