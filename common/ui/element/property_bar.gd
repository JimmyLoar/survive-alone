@tool
class_name PropertyBar
extends HBoxContainer

@onready var texture_rect: TextureRect = $TextureRect
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label: Label = $ProgressBar/Label

var property_id: int = 3
var _property_name: String = ""
var _properties: PlayerPropertiesController

var database: Database = load("res://content/database.gddb")
var data: GameProperty


func _ready() -> void:
	if Engine.is_editor_hint():
		set_process(false)
		return
	
	_properties = Game.get_world_screen().get_player_properties()
	data = database.fetch_data("properties", property_id)
	update()



func update():
	_property_name = data.name_key
	texture_rect.texture = data.texture
	progress_bar.max_value = data.default_max_value
	self.modulate = data.modulate
	update_value()


func update_value():
	if Engine.is_editor_hint(): 
		return
	
	progress_bar.value = _properties.get_value(_property_name)
	label.text = "%d" % ceil(progress_bar.value)


func _process(delta: float) -> void:
	if fmod(Engine.get_frames_drawn(), 12) != 0:
		return
	
	update_value()


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = [] 
	var name_hint = PROPERTY_HINT_NONE
	var name_string = ""
	if Engine.is_editor_hint():
		var props = database.fetch_collection_data("properties") as Dictionary
		var _names = PackedStringArray(props.values().map(
			func(element: GameProperty):
				return "%s:%d" % [element.name_key, props.find_key(element)]
		))
		name_hint = PROPERTY_HINT_ENUM
		name_string = ", ".join(_names)
	
	properties.append({
		name = "property_id",
		type = TYPE_INT,
		hint = name_hint,
		hint_string = name_string,
	})
	
	return properties
