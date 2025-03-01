extends PanelContainer

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


func set_containers(containers: Array[Node]):
	var index: int = 0
	for button in buttons_container.get_children():
		if index >= containers.size():
			_display_button_null(button)
			continue
		
		_display_button_name(button, containers[index].name)
		button.pressed.connect(_on_button_pressed.bind(containers[index]))
		index += 1


func _display_button_null(button):
	if not button is Button: return
	button.text = "???"
	button.disabled = true


func _display_button_name(button, _name: String):
	if not button is Button: return
	button.text = TranslationServer.translate("%s_TITLE" % _name.get_slice("-", 1).to_upper())


func _on_button_pressed(container: ContentContainer):
	if not container: return
	container.visible = not container.visible
	#button_pressed.emit(index if target_node.current_tab != index else -1)
