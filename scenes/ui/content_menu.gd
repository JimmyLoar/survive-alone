class_name ContentMenu
extends PanelContainer

@export var main_scene : PackedScene
@export var sub_scene : PackedScene
@export var border_size := 4

@onready var main_container: MarginContainer = $MarginContainer/HBoxContainer/MainContainer
@onready var sub_container: MarginContainer = $MarginContainer/HBoxContainer/SubContainer




func _ready() -> void:
	if main_scene:
		set_main(main_scene.instantiate())
	if sub_scene:
		set_sub(sub_scene.instantiate())
	


func _set_menu(menu: Control, container: Container):
	if not menu: return
	container.add_child(menu)
	menu.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	menu.size_flags_vertical = Control.SIZE_EXPAND_FILL


func set_main(menu: Control):
	_set_menu(menu, main_container)


func set_sub(menu: Control):
	_set_menu(menu, sub_container)
