extends HBoxContainer


@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect


func update_data(_name: StringName):
	var repository := Injector.inject(CharacterPropertyRepository, self) as CharacterPropertyRepository
	texture_rect.texture = repository.get_by_string_id(_name).texture


func update_value(value):
	var preffix := "" 
	if value > 0: 
		preffix = "+"
	label.text = "%s%d" % [preffix, value]
