@tool
class_name NewSceneGraph 
extends EventGraphNode

@export var texture_rect: TextureRect
@export var path_label: LineEdit
@export var phrase_box: PhraseBox

var file_dialog := EditorFileDialog.new()
var _texture_path: String


func _ready() -> void:
	add_child(file_dialog)
	file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	file_dialog.filters = ["*.png", "*.svg", "*.jpg", "*.jpeg", "*.webp", "*.tga", "*.bmp"]
	file_dialog.file_selected.connect(_update_texture)


func _get_model() -> EventNode:
	return EventNewStene.new()


func _set_model_properties(_node: EventNode) -> void:
	_node.texture = _texture_path 
	_node.text = phrase_box.get_data()


func _get_model_properties(_node: EventNode) -> void:
	_update_texture.call_deferred(_node.texture)
	phrase_box.set_data(_node.text)


func _on_button_pressed() -> void:
	file_dialog.popup_file_dialog()
	

func _update_texture(path: String):
	_texture_path = path
	texture_rect.texture = load(path)
	path_label.text = path.get_file()
	
