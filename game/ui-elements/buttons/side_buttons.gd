class_name SideButtons
extends VBoxContainer

const ICONS = {
	"Inventory": null,
	"Location": null,
}


@export_range(1, 16) var max_buttons := 6
@export var screen_container: TabContainer




var _linked_screens: Array = []
var _button_group := ButtonGroup.new()


func _ready() -> void:
	_init_buttons()


func _init_buttons():
	for screen in screen_container.get_children():
		create_button(screen)


func create_button(screen: PanelContainer):
	var new_button := ButtonSound.new()
	new_button.text = TranslationServer.translate("SCREEN_%s" % screen.name.to_upper())
	new_button.name = screen.name
	new_button.button_group = _button_group
	new_button.pressed.connect(screen.show)
	new_button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if ICONS.has(screen.name):
		new_button.icon = ICONS[screen.name]
	screen.hide()
	add_child(new_button)
	return new_button
