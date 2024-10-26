class_name ContentMenu
extends PanelContainer

@export var main_scene : PackedScene
@export var sub_scene : PackedScene
@export var border_size := 4

@export_group("Connect signals", "connection")
@export var connection_main_to_sub: Array[StringName] = []
@export var connection_sub_to_menu: Array[StringName] = []

@onready var main_container: MarginContainer = $MarginContainer/HBoxContainer/MainContainer
@onready var sub_container: MarginContainer = $MarginContainer/HBoxContainer/SubContainer


func _ready() -> void:
	if main_scene:
		set_main(main_scene.instantiate())
	if sub_scene:
		set_sub(sub_scene.instantiate())
	
	_connect_menus(get_menu(), get_menu(false), connection_main_to_sub)
	_connect_menus(get_menu(false), get_menu(), connection_sub_to_menu)
	


func set_main(menu: Control) -> void:
	_set_menu(menu, main_container)


func set_sub(menu: Control) -> void:
	_set_menu(menu, sub_container)


func _set_menu(menu: Control, container: Container):
	if not menu: return
	container.add_child(menu)
	container.move_child(menu, 0)
	menu.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	menu.size_flags_vertical = Control.SIZE_EXPAND_FILL


func get_menu(is_main := true) -> Control:
	if is_main:
		return _get_menu(main_container)
	return _get_menu(sub_container)


func _get_menu(container: Container) -> Control:
	return container.get_child(0)


func _connect_menus(menu_a, menu_b, signal_list: Array[StringName]):
	if not menu_a or not menu_b: return
	for value in signal_list:
		if OK != _connect_signal(menu_a, menu_b, value):
			breakpoint

func _connect_signal(emitter: Control, receiver: Control, signal_structure: String) -> int:
	var _structure = signal_structure.split(",")
	if not emitter.has_signal(_structure[0]):
		return ERR_DOES_NOT_EXIST
	
	emitter.connect(_structure[0], Callable(receiver, _structure[1]))
	return OK


func call_method(is_main: bool, method: StringName, args := []):
	if is_main:
		get_menu().callv(method, args)
	
	else:
		get_menu(false).callv(method, args)
