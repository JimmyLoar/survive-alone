extends MarginContainer

@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var label: Label = $HBoxContainer/Label


func update(property_name = "", value = 0):
	if property_name == "": 
		hide()
		return
	
	var property = PlayerProperty.get_property(property_name)
	texture_rect.texture = property.texture
	label.text = "%s%d" % ["+" if value >= 0 else "", value]
	show()
