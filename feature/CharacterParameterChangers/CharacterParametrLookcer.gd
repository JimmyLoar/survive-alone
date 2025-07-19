extends Node
class_name CharacterParametrLooker


@onready var state: CharacterState = Locator.get_service(CharacterState)


func _ready() -> void:
	state.property_changed.connect(_on_property_changed)


func _on_property_changed(_prop_data: CharacterPropertyEntity):
	pass
