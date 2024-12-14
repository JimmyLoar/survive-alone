extends MarginContainer

@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var label: Label = $HBoxContainer/Label


func update(property: GameProperty, value = 0):
	if not property: 
		hide()
		return
	
	texture_rect.texture = property.texture
	label.text = "%s%d" % ["+" if value >= 0 else "", value]
	show()
