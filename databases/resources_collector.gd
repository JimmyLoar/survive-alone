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
            return drops.get(key, "")
        Collection.DIALOGE_CHARACTER:
            return dialoge_character.get(key, "")
        Collection.ACTIONS:
            return actions.get(key, "")
        Collection.QUESTS:
            return quests.get(key, "")
        Collection.EVENTS:
            return events.get(key, "")
        Collection.RECIPES:
            return recipes.get(key, "")
        Collection.BIOMES:
            return biomes.get(key, "")
        Collection.EVENTS_LIST:
            return events_list.get(key, "")
        Collection.ITEMS:
            return items.get(key, "")
        Collection.CHARACTER_PROPERTY:
            return character_property.get(key, "")
        _: return ""

static func find(collection: Collection, key: String) -> Resource:
    """Загружает и возвращает один ресурс"""
    var resource_uid := uid(collection, key)
    return ResourceLoader.load(resource_uid) if resource_uid else null

static func find_multiple(collection: Collection, keys: Array[String]) -> Array[Resource]:
    """Загружает и возвращает массив ресурсов по массиву ключей"""
    var result: Array[Resource] = []
    for key in keys:
        var res := find(collection, key)
        if res:
            result.append(res)
    return result

static func find_all(collection: Collection) -> Array[Resource]:
    """Возвращает все ресурсы указанной коллекции"""
    var result: Array[Resource] = []
    for key in keys(collection):
        var res := find(collection, key)
        if res:
            result.append(res)
    return result

static func keys(collection: Collection) -> Array[String]:
    """Возвращает все ключи указанной коллекции"""
    match collection:
        Collection.DROPS:
            return drops.keys()
        Collection.DIALOGE_CHARACTER:
            return dialoge_character.keys()
        Collection.ACTIONS:
            return actions.keys()
        Collection.QUESTS:
            return quests.keys()
        Collection.EVENTS:
            return events.keys()
        Collection.RECIPES:
            return recipes.keys()
        Collection.BIOMES:
            return biomes.keys()
        Collection.EVENTS_LIST:
            return events_list.keys()
        Collection.ITEMS:
            return items.keys()
        Collection.CHARACTER_PROPERTY:
            return character_property.keys()
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
    QUESTS,
    EVENTS,
    RECIPES,
    BIOMES,
    EVENTS_LIST,
    ITEMS,
    CHARACTER_PROPERTY,
}

#######################################################################
#                         КОЛЛЕКЦИИ РЕСУРСОВ                         #
# WARNING: НЕ РЕДАКТИРОВАТЬ ВРУЧНУЮ!                                 #
# ЛЮБЫЕ ИЗМЕНЕНИЯ БУДУТ ПЕРЕЗАПИСАНЫ ПРИ ОЧЕРЕДНОЙ ГЕНЕРАЦИИ!        #
#######################################################################


const drops = {
    "none": "uid://56f1qivn2r5c",
    "test_1": "uid://cmj3q638n6mio",
    "forest_biome": "uid://byqa05n1ugvxn",
}

const dialoge_character = {
    "narrator": "uid://lo5lkul44sou",
    "player": "uid://k0vu08dr0tmb",
    "grandpa": "uid://k5xol2e8fp78",
    "unknown": "uid://blr1yfkg5pohd",
    "man": "uid://b0cjwpa70higj",
}

const actions = {
    "test_action": "uid://cyejt07t5u1ej",
}

const quests = {
    "prologue_00": "uid://b3xe3vw6y5fv7",
    "prologue": "uid://dseeelh8xcs4c",
    "test3": "uid://bs2ncgfju7uqb",
    "test": "uid://rt46wktltqjl",
    "test2": "uid://byvhlyfyh7fhn",
}

const events = {
}

const recipes = {
    "testrec": "uid://bcge0nb1kyihk",
    "new_resource": "uid://pxbvidbaa863",
    "test2": "uid://di1t8oj34rnkh",
}

const biomes = {
    "forest": "uid://dn12ncdul2jqb",
    "grass": "uid://cmt1u58b84x8p",
    "ground": "uid://dpeuc3gy13evg",
    "water": "uid://b4vownqfi8d5f",
}

const events_list = {
    "biom_list_test": "uid://dcgbiiy8tbv8b",
}

const items = {
}

const character_property = {
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
