extends Node

var list: BiomeSearchList = preload("res://feature/biom_search_event/test/biom_list_test.tres")


func get_event_list() -> BiomeSearchList:
	var FLOWERS := preload("res://feature/biom_search_event/test/flowers.tres") as BiomeSerchEventResource
	var NOTHING := preload("res://feature/biom_search_event/test/nothing.tres") as BiomeSerchEventResource
	var WOOD_1 := preload("res://feature/biom_search_event/test/wood_1.tres") as BiomeSerchEventResource
	var WOOD_2 := preload("res://feature/biom_search_event/test/wood_2.tres") as BiomeSerchEventResource
	var WOOD_3 := preload("res://feature/biom_search_event/test/wood_3.tres") as BiomeSerchEventResource
	var WOOD_HOUSE := preload("res://feature/biom_search_event/test/wood_house.tres") as BiomeSerchEventResource
	
	var id = FLOWERS.add_stage("start", "Вы вышли на поляну с цветами.")
	var next_id = FLOWERS.add_stage("reward_1", "Вы содрали несколько цветов:\n")
	FLOWERS.add_action(id, "Нарвать цветов", next_id)
	FLOWERS.add_action(next_id, "...", -1)
	next_id = FLOWERS.add_stage("exit", "Вы решатие не тратить время на их сбор. Кто знает может вы сможите найти что то получше...")
	FLOWERS.add_action(id, "Пройти мимо", next_id)
	FLOWERS.add_action(next_id, "...", -1)
	
	id = NOTHING.add_stage("start", "Через какоето время вы замечаете, что ходите кругами. Вам неудалось найти что то полезное...")
	NOTHING.add_action(next_id, "...", -1)
	
	id = WOOD_1.add_stage("start", "Бродя по округе вы замечаете, опавщие деревья")
	next_id = WOOD_1.add_stage("reward_1", "Вы содрали немного хвороста:\n")
	WOOD_1.add_action(id, "Собрать", next_id)
	WOOD_1.add_action(next_id, "...", -1)
	next_id = WOOD_1.add_stage("exit", "Вы решатие не тратить время на их сбор. Кто знает может вы сможите найти что то получше...")
	WOOD_1.add_action(id, "Пройти мимо", next_id)
	WOOD_1.add_action(next_id, "...", -1)
	
	id = WOOD_2.add_stage("start", "Бродя по округе вы замечаете, опавщие ябланю.")
	next_id = WOOD_2.add_stage("reward_1", "Вы вы сорвали все яблоки до которых смогли дотянутся.")
	WOOD_2.add_action(id, "Нарвать яблок", next_id)
	WOOD_2.add_action(next_id, "...", -1)
	next_id = WOOD_2.add_stage("exit", "Вы решатие не тратить время на их сбор. Кто знает может вы сможите найти что то получше...")
	WOOD_2.add_action(id, "Пройти мимо", next_id)
	WOOD_2.add_action(next_id, "...", -1)
	
	id = WOOD_3.add_stage("start", "Вы нашли немного хвороста")
	WOOD_3.add_action(id, "...", -1)
	
	id = WOOD_HOUSE.add_stage("start", "Побродив немного, вы замечате небольшую деревяную хищину в дали.")
	next_id = WOOD_HOUSE.add_stage("around_house", "Подойдя ближе, понимаете, что от хижены остались одни руины")
	WOOD_HOUSE.add_action(id, "Подойти ближе", next_id)
	id = next_id
	next_id = WOOD_HOUSE.add_stage("exit", "Вас становиться не посебе, когда вы смотрите на избу. Вы решаете уйти в другое место.")
	WOOD_HOUSE.add_action(0, "Уйти", next_id)
	WOOD_HOUSE.add_action(id, "Уйти", next_id)
	WOOD_HOUSE.add_action(next_id, "...", -1)
	next_id = WOOD_HOUSE.add_stage("house", "Зайдя внутарь, ничего кроме нескольких семян и старых газет найти не удалось.")
	WOOD_HOUSE.add_action(id, "Зайти", next_id)
	WOOD_HOUSE.add_action(next_id, "...", -1)
	
	list.events = Array([FLOWERS, NOTHING, WOOD_1, WOOD_2, WOOD_3, WOOD_HOUSE], TYPE_OBJECT, "Resource", BiomeSerchEventResource)
	return list
