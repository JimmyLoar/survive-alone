@tool
class_name DialogeEventGraphNode 
extends EventGraphNode 

const CHARACTERS_LIST = [
	preload("uid://b0cjwpa70higj"),
	preload("uid://b0cjwpa70higj"),
	preload("uid://b0cjwpa70higj"),
]

const PARAGRAPH_BOX = preload("res://!tools/event_editer/graphs/internal/paragraph_box.tscn")


@onready var menu_button: MenuButton = $MenuButton
@onready var character_selecter: OptionButton = %CharacterSelecter


func _ready() -> void:
	character_selecter.clear()
	for char in CHARACTERS_LIST:
		#character_selecter.get_popup().add_item(char.name)
		character_selecter.add_item(char.name)


func _get_model() -> EventNode:
	return DialogeEventNode.new()


func _set_model_properties(_node: EventNode) -> void:
	pass


func _get_model_properties(_node: EventNode) -> void:
	pass


func _add_paragrath():
	pass


func _remove_paragrath():
	pass
