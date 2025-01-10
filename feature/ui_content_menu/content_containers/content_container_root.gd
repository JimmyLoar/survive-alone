class_name ContentContainer
extends PanelContainer

signal closed

@export_range(0.1, 10.0, 0.1) var main_stretch_ratio := 2.4

@onready var main_container: MarginContainer = $_MarginContainer/HBoxContainer/MainContainer
@onready var sub_container: TabContainer = $_MarginContainer/HBoxContainer/SubContainer
@onready var logger := Log.get_global_logger().with("ContentMenu (%s)" % name)


func _ready() -> void:
	main_container.size_flags_stretch_ratio = main_stretch_ratio
	for child: Node in get_children():
		var child_name := child.name.to_lower() as String
		if child_name.begins_with("_"):
			continue
		
		elif child_name.begins_with("main"):
			_transfer_to_container(child, main_container)
			child.show()
		
		elif child_name.begins_with("sub"):
			_transfer_to_container(child, sub_container)
			sub_container.current_tab = 0
		
		else:
			push_error("child '%s' not begin with 'main' or 'sub'" % child.name)
			child.queue_free()


func change_visible():
	self.visible = not self.visible


func _transfer_to_container(child: Node, container: Node):
	self.remove_child(child)
	container.add_child(child)


func _on_close_button_pressed():
	if sub_container.current_tab == 0:
		self.hide()
		return
	
	sub_container.current_tab = 0
