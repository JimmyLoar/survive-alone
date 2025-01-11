class_name ContentContainer
extends PanelContainer

signal closed

@export_range(0.1, 10.0, 0.1) var main_stretch_ratio := 2.4

@onready var main_container: MarginContainer = $_MarginContainer/HBoxContainer/MainContainer
@onready var sub_container: TabContainer = $_MarginContainer/HBoxContainer/SubContainer
@onready var logger := Log.get_global_logger().with("ContentMenu (%s)" % name)



func _on_close_button_pressed():
	if sub_container.current_tab == 0:
		self.hide()
		return
	
	sub_container.current_tab = 0
