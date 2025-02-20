class_name BiomeSearchList
extends EventList


@export var offset_tags_weight : Dictionary = {
	BiomeSearchEventResource.Tags.nothing: 0, 		#ничего
	BiomeSearchEventResource.Tags.trees: 0, 			#деревья
	BiomeSearchEventResource.Tags.water: 0, 			#вода
	BiomeSearchEventResource.Tags.flower: 0,			#цветы
	BiomeSearchEventResource.Tags.berries: 0,		#ягоды
	BiomeSearchEventResource.Tags.mushrooms: 0, 		#грибы
	BiomeSearchEventResource.Tags.plants: 0,			#травы
	BiomeSearchEventResource.Tags.herbivorous: 0,	#травоядные жевотные
	BiomeSearchEventResource.Tags.carnivores: 0,		#хищьники
	BiomeSearchEventResource.Tags.large_animals: 0, 	#крупные звери
	BiomeSearchEventResource.Tags.small_animals: 0, 	#небольшие звери
	BiomeSearchEventResource.Tags.ruins: 0,  		#руины
	BiomeSearchEventResource.Tags.location: 0,		#локация
} 

@export var tags_list: Dictionary = {}


var _weights: PackedInt32Array
var _amount_weight := 0


func set_events(value):
	events = value
	_sort_events_for_tags(events)


func get_event() -> BiomeSearchEventResource:
	_weights = _create_weight_list()
	
	var random_value := rng.randi_range(0, _amount_weight)
	var index: int = 0
	
	for i in _weights.size() - 1:
		if random_value < _weights[i + 1]:
			index = i
			break
	
	return events[index]


func _create_weight_list() -> PackedInt32Array:
	var array := PackedInt32Array()
	_amount_weight = 0
	for i in events.size():
		var weight: int = events[i].weight
		if weight > 0:
			_amount_weight += weight
		
		array.append(_amount_weight)
	return array 


func _sort_events_for_tags(_events: Array):
	tags_list.clear()
	for i in _events.size():
		if events[i] is not BiomeSearchEventResource:
			continue
		
		for tag in _events[i].tags:
			if not tags_list.has(tag):
				tags_list[tag] = []
			tags_list[tag].append(i)
	
