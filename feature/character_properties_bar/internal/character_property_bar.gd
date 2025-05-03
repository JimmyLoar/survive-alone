extends HBoxContainer

@export_enum("exhaustion","fatigue","hunger","psych","radiation","thirst") var property_name: String:
	set(value):
		property_name = value
		if _character_state:
			render(_character_state.get_property_data(property_name))
		
@onready var texture_rect: TextureRect = $TextureRect
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label: Label = $ProgressBar/Label
@onready var _character_state: CharacterState = Locator.get_service(CharacterState)


func _ready() -> void:
	_character_state.property_changed.connect(_on_property_changed)
	render(_character_state.get_property_data(property_name))



func _on_property_changed(prop: CharacterPropertyEntity):
	rerender(prop)


func render(prop: CharacterPropertyResource):
	texture_rect.texture = prop.texture
	label.modulate = prop.modulate
	progress_bar.self_modulate = prop.modulate


func rerender(prop: CharacterPropertyEntity):
	if prop.data_name != property_name:
		return
	
	progress_bar.max_value = prop.get_max_value()
	progress_bar.min_value = prop.get_min_value()
	progress_bar.value = prop.value
	label.text = "%d" % ceil(prop.value)
