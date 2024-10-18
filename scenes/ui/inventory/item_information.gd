class_name ItemInfoPanel
extends MarginContainer

@export var _item: ItemData

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var text_label: RichTextLabel = $VBoxContainer/ScrollContainer/VBoxContainer/RichTextLabel
@onready var pickup_button: Button = $VBoxContainer/Buttons/Button


func _ready() -> void:
	if _item:
		update(_item)


func update(item: ItemData, data: Dictionary = {}):
	name_label.text = "%s" % item.name
	text_label.clear()
	text_label.append_text("%s" % item.discription)
	$VBoxContainer/ScrollContainer/VBoxContainer/PanelContainer1.update(item)
	


func _create_button():
	pass
