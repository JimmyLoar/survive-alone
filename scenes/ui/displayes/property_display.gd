extends MarginContainer

@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var label: Label = $HBoxContainer/Label


func update(texture: Texture, value = 0):
	if not texture: 
		hide()
		return
	
	texture_rect.texture = texture
	label.text = "%d" % value
	show()
