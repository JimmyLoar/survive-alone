class_name BiomeSearchList
extends Resource


@export var offset_tags_weight : Dictionary = {
	BiomeSerchEventResource.Tags.nothing: 0, 		#ничего
	BiomeSerchEventResource.Tags.trees: 0, 			#деревья
	BiomeSerchEventResource.Tags.water: 0, 			#вода
	BiomeSerchEventResource.Tags.flower: 0,			#цветы
	BiomeSerchEventResource.Tags.berries: 0,		#ягоды
	BiomeSerchEventResource.Tags.mushrooms: 0, 		#грибы
	BiomeSerchEventResource.Tags.plants: 0,			#травы
	BiomeSerchEventResource.Tags.herbivorous: 0,	#травоядные жевотные
	BiomeSerchEventResource.Tags.carnivores: 0,		#хищьники
	BiomeSerchEventResource.Tags.large_animals: 0, 	#крупные звери
	BiomeSerchEventResource.Tags.small_animals: 0, 	#небольшие звери
	BiomeSerchEventResource.Tags.ruins: 0,  		#руины
	BiomeSerchEventResource.Tags.location: 0,		#локация
} 

var rng := RandomNumberGenerator.new() as RandomNumberGenerator

@export var events: Array[BiomeSerchEventResource] = []:
	set(value):
		events = value
		_sort_events_for_tags(events)


@export var tags_list: Dictionary = {}

var _weights: PackedInt32Array
var _amount_weight := 0

func _create_weight_list() -> PackedInt32Array:
	var array := PackedInt32Array()
	_amount_weight = 0
	for i in events.size():
		var weight: int = events[i].weight
		for tag in events[i].tags:
			weight += offset_tags_weight[tag]
		_amount_weight += weight
		array.append(_amount_weight)
	return array 


func get_selected_event() -> BiomeSerchEventResource:
	if _weights.is_empty():
		_weights = _create_weight_list()
	
	var random_value := rng.randi_range(0, _amount_weight)
	var index: int = 0
	
	for i in _weights.size() - 1:
		if random_value < _weights[i + 1]:
			index = i
			break
	
	return events[index]


func _sort_events_for_tags(_events: Array[BiomeSerchEventResource]):
	tags_list.clear()
	for i in _events.size():
		for tag in _events[i].tags:
			if not tags_list.has(tag):
				tags_list[tag] = []
			tags_list[tag].append(i)
	
