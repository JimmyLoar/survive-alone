class_name InventorySlotDisplay
extends TextureButton

@export var _displayed_item: ItemData
@export var empty := true

@onready var item_texture: TextureRect = $ItemTexture
@onready var rare_frame: Panel = $RareFrame
@onready var amount_label: Label = $AmountLabel


func _ready() -> void:
	update()


func update(item: ItemData = _displayed_item, count: int = 1):
	match count:
		0: 
			item_texture.texture = null
			rare_frame.modulate = Color(0, 0, 0, 0)
			amount_label.hide()
			empty = true
		
		var x when x >= 1 and not item:
			item_texture.texture = null
			rare_frame.modulate = Color(0, 0, 0, 0)
			amount_label.hide()
			empty = true
		
		1:
			item_texture.texture = item.texture
			rare_frame.modulate = item.get_color()
			amount_label.hide()
			empty = false
			
		var x when x > 1:
			item_texture.texture = item.texture
			rare_frame.modulate = item.get_color()
			amount_label.show()
			amount_label.text = "%d" % count
			empty = false
		
		_:
			breakpoint


func is_empty():
	return empty
