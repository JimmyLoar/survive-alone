class_name ContentMenu
extends MarginContainer

@onready var tab_container: TabContainer = $HBoxContainer/TabContainer


func _ready() -> void:
	for child in self.get_children():
		if not child is ContentContainer:
			continue
		
		self.remove_child(child)
		tab_container.add_child(child)
	tab_container.current_tab = -1
