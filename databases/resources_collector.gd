class_name ResourceCollector

#######################################################################
#                   МЕТОДЫ ДЛЯ РАБОТЫ С РЕСУРСАМИ                   #
# WARNING: НЕ РЕДАКТИРОВАТЬ ВРУЧНУЮ!                                 #
# ЛЮБЫЕ ИЗМЕНЕНИЯ БУДУТ ПЕРЕЗАПИСАНЫ ПРИ ОЧЕРЕДНОЙ ГЕНЕРАЦИИ!        #
#######################################################################


static func uid(collection: Collection, key: String) -> String:
	"""Возвращает UID ресурса или пустую строку если не найден"""
	match collection:
		Collection.DROPS:
			return _drops.get(key, "")
		Collection.DIALOGE_CHARACTER:
			return _dialoge_character.get(key, "")
		Collection.ACTIONS:
			return _actions.get(key, "")
		Collection.ENEMIES:
			return _enemies.get(key, "")
		Collection.QUESTS:
			return _quests.get(key, "")
		Collection.EVENTS:
			return _events.get(key, "")
		Collection.RECIPES:
			return _recipes.get(key, "")
		Collection.BIOMES:
			return _biomes.get(key, "")
		Collection.EVENTS_LIST:
			return _events_list.get(key, "")
		Collection.ITEMS:
			return _items.get(key, "")
		Collection.ACTION_TEMPLATES:
			return _action_templates.get(key, "")
		Collection.CHARACTER_PROPERTY:
			return _character_property.get(key, "")
		_: return ""

static func find(collection: Collection, key: String) -> Resource:
	"""Загружает и возвращает один ресурс"""
	var resource_uid := uid(collection, key)
	return ResourceLoader.load(resource_uid) if resource_uid else null

static func find_multiple(collection: Collection, keys: Array) -> Array:
	"""Загружает и возвращает массив ресурсов по массиву ключей"""
	var result: Array[Resource] = []
	for key in keys:
		var res := find(collection, key)
		if res:
			result.append(res)
	return result

static func find_all(collection: Collection) -> Array:
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
		Collection.DROPS:
			return _drops.keys()
		Collection.DIALOGE_CHARACTER:
			return _dialoge_character.keys()
		Collection.ACTIONS:
			return _actions.keys()
		Collection.ENEMIES:
			return _enemies.keys()
		Collection.QUESTS:
			return _quests.keys()
		Collection.EVENTS:
			return _events.keys()
		Collection.RECIPES:
			return _recipes.keys()
		Collection.BIOMES:
			return _biomes.keys()
		Collection.EVENTS_LIST:
			return _events_list.keys()
		Collection.ITEMS:
			return _items.keys()
		Collection.ACTION_TEMPLATES:
			return _action_templates.keys()
		Collection.CHARACTER_PROPERTY:
			return _character_property.keys()
		_: return []
#######################################################################
#                         НАЗВАНИЯ КОЛЛЕКЦИЙ                         #
# WARNING: НЕ РЕДАКТИРОВАТЬ ВРУЧНУЮ!                                 #
# ЛЮБЫЕ ИЗМЕНЕНИЯ БУДУТ ПЕРЕЗАПИСАНЫ ПРИ ОЧЕРЕДНОЙ ГЕНЕРАЦИИ!        #
#######################################################################


enum Collection {
	DROPS,
	DIALOGE_CHARACTER,
	ACTIONS,
	ENEMIES,
	QUESTS,
	EVENTS,
	RECIPES,
	BIOMES,
	EVENTS_LIST,
	ITEMS,
	ACTION_TEMPLATES,
	CHARACTER_PROPERTY,
}

const Drops = Collection.DROPS
const DialogeCharacter = Collection.DIALOGE_CHARACTER
const Actions = Collection.ACTIONS
const Enemies = Collection.ENEMIES
const Quests = Collection.QUESTS
const Events = Collection.EVENTS
const Recipes = Collection.RECIPES
const Biomes = Collection.BIOMES
const EventsList = Collection.EVENTS_LIST
const Items = Collection.ITEMS
const ActionTemplates = Collection.ACTION_TEMPLATES
const CharacterProperty = Collection.CHARACTER_PROPERTY

#######################################################################
#                         КОЛЛЕКЦИИ РЕСУРСОВ                         #
# WARNING: НЕ РЕДАКТИРОВАТЬ ВРУЧНУЮ!                                 #
# ЛЮБЫЕ ИЗМЕНЕНИЯ БУДУТ ПЕРЕЗАПИСАНЫ ПРИ ОЧЕРЕДНОЙ ГЕНЕРАЦИИ!        #
#######################################################################


const _drops = {
	"none": "uid://56f1qivn2r5c",
	"test_1": "uid://cmj3q638n6mio",
	"forest_biome": "uid://byqa05n1ugvxn",
}

const _dialoge_character = {
	"narrator": "uid://lo5lkul44sou",
	"player": "uid://k0vu08dr0tmb",
	"grandpa": "uid://k5xol2e8fp78",
	"unknown": "uid://blr1yfkg5pohd",
	"man": "uid://b0cjwpa70higj",
}

const _actions = {
	"test_action": "uid://cyejt07t5u1ej",
}

const _enemies = {
	"stray_dog": "uid://k6plf838eui1",
}

const _quests = {
	"prologue_1": "uid://b3xe3vw6y5fv7",
	"test3": "uid://bs2ncgfju7uqb",
	"test": "uid://rt46wktltqjl",
	"prologue_0": "uid://dseeelh8xcs4c",
	"test2": "uid://byvhlyfyh7fhn",
}

const _events = {
	"bs_wood_3": "uid://ctjrc4bmwqqyb",
	"return_to_default": "uid://c66ptthr6m3wo",
	"bs_wood_2": "uid://dqfvlh61m6pyf",
	"bs_nothing": "uid://p87q2gu41esh",
	"bs_wood_1": "uid://dq2k6kcwcusov",
	"bs_wood_house": "uid://bukhycp4s402r",
	"bs_flowers": "uid://cy7t5tb2khs88",
	"bs_defualt_event": "uid://dw6j3yeanfdqt",
	"bs_animal_corpse": "uid://4lsplaql8qte",
	"prologue_1": "uid://3e3vcbgoiwi",
	"prologue_3": "uid://ce3i74dxbybxq",
	"prologue_2": "uid://c6ltxc0vmykcj",
	"hungry_man_0": "uid://s6k078jwopre",
	"hungry_man_1": "uid://odru6ioyr7g5",
}

const _recipes = {
	"tool_homemade_axe": "uid://cw8bywmaxpfun",
	"testrec": "uid://bcge0nb1kyihk",
	"new_resource": "uid://pxbvidbaa863",
	"test2": "uid://di1t8oj34rnkh",
}

const _biomes = {
	"forest": "uid://dn12ncdul2jqb",
	"grass": "uid://cmt1u58b84x8p",
	"ground": "uid://dpeuc3gy13evg",
	"water": "uid://b4vownqfi8d5f",
}

const _events_list = {
	"biom_list_test": "uid://dcgbiiy8tbv8b",
}

const _items = {
	"tool_primus": "uid://w30mnp2gmvuy",
	"tool_saucepan": "uid://c2dl3xfx8wogm",
	"tool_homemade_axe": "uid://y4ljuqoxwvhc",
	"tool_homemade_knife": "uid://pr76410n87uh",
	"building_bonfire": "uid://dwbwer584xv32",
	"resource_duct_tape": "uid://cqvooygqbwtxj",
	"resource_stick": "uid://q60vk20s3cn8",
	"resource_flint": "uid://deweoka8ravkd",
	"resource_wood": "uid://b2yydvgka6dr0",
	"food_canned_food": "uid://chxbdcao06tc6",
	"food_water_clear": "uid://t6dvd3ikteh5",
	"food_fresh_meat": "uid://csx1bauob5bnf",
	"food_fry_meat": "uid://ibrfm6mql4j7",
}

const _action_templates = {
	"eat": "uid://c15r1ate8r8t0",
}

const _character_property = {
	"thirst": "uid://xed72gsi0f8o",
	"psych": "uid://pbgbhwc5vroa",
	"exhaustion": "uid://d3j3yifrth1q4",
	"fatigue": "uid://b00p46pjqmbhn",
	"radiation": "uid://fnk6s753jtyh",
	"none_property": "uid://u4wcq6ucjv5i",
	"hunger": "uid://bk6piro7truso",
}


#######################################################################
#                            КОНЕЦ ФАЙЛА                            #
# WARNING: НЕ РЕДАКТИРОВАТЬ ВРУЧНУЮ!                                 #
# ЛЮБЫЕ ИЗМЕНЕНИЯ БУДУТ ПЕРЕЗАПИСАНЫ ПРИ ОЧЕРЕДНОЙ ГЕНЕРАЦИИ!        #
#######################################################################
