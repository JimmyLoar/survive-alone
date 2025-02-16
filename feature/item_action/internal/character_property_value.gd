extends HBoxContainer


@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect
@onready var character_property_repository : CharacterPropertyRepository = Injector.inject(CharacterPropertyRepository, self)

func update_data(_name: StringName):
	texture_rect.texture = character_property_repository.get_by_name(_name).texture


func update_value(value):
	var preffix := "" 
	if value > 0: 
		preffix = "+"
	label.text = "%s%d" % [preffix, value]
