extends MarginContainer

signal button_pressed(index: int)

@export var target_node: TabContainer
@export var showing_version := false
@onready var buttons_container: VBoxContainer = $VBoxContainer

@onready var version_display: VersionDisplay = $VBoxContainer/Control3/VersionDisplay

func _ready() -> void:
	version_display.visible = showing_version
	for child in buttons_container.get_children():
		if not child is Button:
			continue
		
		child.pressed.connect(_button_pressed.bind(child.get_index() - 1))


func _button_pressed(index: int):
	button_pressed.emit(index if target_node.current_tab != index else -1)
