class_name ItemDisplay
extends MarginContainer

@onready var rarety_rect: TextureRect = $RaretyRect
@onready var texture_rect: TextureRect = $TextureRect
@onready var label_amount: Label = $LabelAmount


func _init() -> void:
	set("size_flags_horizontal", SIZE_EXPAND_FILL)
	set("size_flags_vertical", SIZE_EXPAND_FILL)


func update_data(data: ItemResource):
	if not data:
		texture_rect.texture = null
		return 
	
	rarety_rect.modulate = data.get_color()
	texture_rect.texture = data.texture


func update_amount(amount: int):
	label_amount.visible = amount > 0
	label_amount.text = "%d" % amount
	
