class_name Item
extends Object

var name: String
 
var durability : int
var max_durability : int


func _init(new_name: String, _durability: int = 100) -> void:
	name = new_name
	max_durability = _durability
	durability = _durability


func is_used():
	return durability != max_durability


func reset():
	durability = max_durability


func get_showed_name():
	return TranslationServer.translate("ITEM_%s_NAME" % name.to_upper())


static func get_new_item(item: Item):
	var new_item := Item.new(item.name, item.max_durability)
	return Item
