extends HBoxContainer


@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect
@onready var character_state: CharacterState = Locator.get_service(CharacterState)


func update_data(_name: StringName):
	var property: CharacterPropertyResource = character_state.get_property_data(_name)
	texture_rect.texture = property.texture


func update_value(value):
	var preffix := "" 
	if value > 0: 
		preffix = "+"
	label.text = "%s%d" % [preffix, value]
