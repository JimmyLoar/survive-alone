class_name ContentMenu
extends MarginContainer

@onready var tab_container: TabContainer = $HBoxContainer/TabContainer
@onready var battons_bar: MarginContainer = $HBoxContainer/ContentBattonsBar


func _ready() -> void:
	battons_bar.set_containers(tab_container.get_children())
	tab_container.current_tab = -1
