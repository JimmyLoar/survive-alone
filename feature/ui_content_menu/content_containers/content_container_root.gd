class_name ContentContainer
extends PanelContainer
@warning_ignore('unused_signal')
signal closed

@export_range(0.1, 10.0, 0.1) var main_stretch_ratio := 2.4
@export var button_texture: Texture

@onready var main_container: MarginContainer = %MainContainer
@onready var sub_container: TabContainer = %SubContainer
@onready var logger := Log.get_global_logger().with("ContentMenu (%s)" % name)


func _ready() -> void:
	pass


func _on_close_button_pressed():
	if sub_container.current_tab == 0:
		var parent = get_parent()
		if parent is TabContainer:
			parent.current_tab = -1
		else:
			self.hide()
		return
	
	sub_container.current_tab = 0
