class_name ResourceCollector
extends Object

#######################################################################
#                                                                     #
# WARNING: АВТОМАТИЧЕСКИ СГЕНЕРИРОВАННЫЙ ФАЙЛ!                       #
# НЕ РЕДАКТИРОВАТЬ ВРУЧНУЮ!                                          #
# ЛЮБЫЕ ИЗМЕНЕНИЯ БУДУТ ПЕРЕЗАПИСАНЫ ПРИ ОЧЕРЕДНОЙ ГЕНЕРАЦИИ!        #
#                                                                     #
#######################################################################



#######################################################################
# КОЛЛЕКЦИИ РЕСУРСОВ                                                 #
#######################################################################

const quests = {
	"prologue_00": "uid://b3xe3vw6y5fv7",
	"prologue": "uid://dseeelh8xcs4c",
	"test2": "uid://byvhlyfyh7fhn",
	"test3": "uid://bs2ncgfju7uqb",
	"test": "uid://rt46wktltqjl",
}

const biomes = {
	"forest": "uid://dn12ncdul2jqb",
	"grass": "uid://cmt1u58b84x8p",
	"ground": "uid://dpeuc3gy13evg",
	"water": "uid://b4vownqfi8d5f",
}

const drops = {
	"forest_biome": "uid://byqa05n1ugvxn",
	"none": "uid://56f1qivn2r5c",
	"test_1": "uid://cmj3q638n6mio",
}

const items = {
	"eat": "uid://c15r1ate8r8t0",
	"building_bonfire": "uid://dwbwer584xv32",
	"food_canned_food": "uid://chxbdcao06tc6",
	"food_fresh_meat": "uid://csx1bauob5bnf",
	"food_fry_meat": "uid://ibrfm6mql4j7",
	"food_water_clear": "uid://t6dvd3ikteh5",
	"resource_duct_tape": "uid://cqvooygqbwtxj",
	"resource_flint": "uid://deweoka8ravkd",
	"resource_stick": "uid://q60vk20s3cn8",
	"resource_wood": "uid://b2yydvgka6dr0",
	"tool_homemade_axe": "uid://y4ljuqoxwvhc",
	"tool_homemade_knife": "uid://pr76410n87uh",
	"tool_primus": "uid://w30mnp2gmvuy",
	"tool_saucepan": "uid://c2dl3xfx8wogm",
}

const events_list = {
	"biom_list_test": "uid://dcgbiiy8tbv8b",
}

const events = {
	"return_to_default": "uid://c66ptthr6m3wo",
	"bs_animal_corpse": "uid://4lsplaql8qte",
	"bs_defualt_event": "uid://dw6j3yeanfdqt",
	"bs_flowers": "uid://cy7t5tb2khs88",
	"bs_nothing": "uid://p87q2gu41esh",
	"bs_wood_1": "uid://dq2k6kcwcusov",
	"bs_wood_2": "uid://dqfvlh61m6pyf",
	"bs_wood_3": "uid://ctjrc4bmwqqyb",
	"bs_wood_house": "uid://bukhycp4s402r",
	"hungry_man_0": "uid://s6k078jwopre",
	"hungry_man_1": "uid://odru6ioyr7g5",
	"event_prologue_1": "uid://3e3vcbgoiwi",
	"event_prologue_2": "uid://c6ltxc0vmykcj",
	"event_prologue_3": "uid://ce3i74dxbybxq",
}

const actions = {
	"test_action": "uid://cyejt07t5u1ej",
}

const character_property = {
	"exhaustion": "uid://d3j3yifrth1q4",
	"fatigue": "uid://b00p46pjqmbhn",
	"hunger": "uid://bk6piro7truso",
	"none_property": "uid://u4wcq6ucjv5i",
	"psych": "uid://pbgbhwc5vroa",
	"radiation": "uid://fnk6s753jtyh",
	"thirst": "uid://xed72gsi0f8o",
}

const recipes = {
	"new_resource": "uid://pxbvidbaa863",
	"test2": "uid://di1t8oj34rnkh",
	"testrec": "uid://bcge0nb1kyihk",
	"tool_homemade_axe": "uid://cw8bywmaxpfun",
}

const dialoge_character = {
	"grandpa": "uid://k5xol2e8fp78",
	"man": "uid://b0cjwpa70higj",
	"narrator": "uid://lo5lkul44sou",
	"player": "uid://k0vu08dr0tmb",
	"unknown": "uid://blr1yfkg5pohd",
}


#######################################################################
# ТИПЫ КОЛЛЕКЦИЙ                                                     #
#######################################################################

enum Collection {
	QUESTS,
	BIOMES,
	DROPS,
	ITEMS,
	EVENTS_LIST,
	EVENTS,
	ACTIONS,
	CHARACTER_PROPERTY,
	RECIPES,
	DIALOGE_CHARACTER,
}

#######################################################################
# МЕТОДЫ ДЛЯ РАБОТЫ С РЕСУРСАМИ                                      #
#######################################################################


static func uid(collection: Collection, key: String) -> String:
	"""Возвращает UID ресурса или пустую строку если не найден"""
	match collection:
		Collection.QUESTS:
			return quests.get(key, "")
		Collection.BIOMES:
			return biomes.get(key, "")
		Collection.DROPS:
			return drops.get(key, "")
		Collection.ITEMS:
			return items.get(key, "")
		Collection.EVENTS_LIST:
			return events_list.get(key, "")
		Collection.EVENTS:
			return events.get(key, "")
		Collection.ACTIONS:
			return actions.get(key, "")
		Collection.CHARACTER_PROPERTY:
			return character_property.get(key, "")
		Collection.RECIPES:
			return recipes.get(key, "")
		Collection.DIALOGE_CHARACTER:
			return dialoge_character.get(key, "")
		_: return ""

static func find(collection: Collection, key: String) -> Resource:
	"""Загружает и возвращает один ресурс"""
	var resource_uid := uid(collection, key)
	return ResourceLoader.load(resource_uid) if resource_uid else null

static func find_multiple(collection: Collection, keys: Array[String]) -> Array:
	"""Загружает и возвращает массив ресурсов по массиву ключей"""
	var result: Array[Resource] = []
	for key in keys:
		var res := find(collection, key)
		if res:
			result.append(res)
	return result

static func get_all(collection: Collection) -> Array:
	"""Возвращает все ресурсы указанной коллекции"""
	var result: Array[Resource] = []
	for key in keys(collection):
		var res := find(collection, key)
		if res:
			result.append(res)
	return result

static func keys(collection: Collection) -> Array:
	"""Возвращает все ключи указанной коллекции"""
	match collection:
		Collection.QUESTS:
			return quests.keys()
		Collection.BIOMES:
			return biomes.keys()
		Collection.DROPS:
			return drops.keys()
		Collection.ITEMS:
			return items.keys()
		Collection.EVENTS_LIST:
			return events_list.keys()
		Collection.EVENTS:
			return events.keys()
		Collection.ACTIONS:
			return actions.keys()
		Collection.CHARACTER_PROPERTY:
			return character_property.keys()
		Collection.RECIPES:
			return recipes.keys()
		Collection.DIALOGE_CHARACTER:
			return dialoge_character.keys()
		_: return []

#######################################################################
# КОНЕЦ АВТОМАТИЧЕСКИ СГЕНЕРИРОВАННОГО ФАЙЛА                        #
#######################################################################
