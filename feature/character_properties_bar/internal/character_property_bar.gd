extends HBoxContainer

@export var property_name: String
@onready var texture_rect: TextureRect = $TextureRect
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label: Label = $ProgressBar/Label
@onready var _character_state: CharacterState = Injector.inject(CharacterState, self)

func _ready() -> void:
	_character_state.property_changed.connect(_on_property_changed)

func _on_property_changed(prop: CharacterPropertyResource):
	rerender(prop)


func rerender(prop: CharacterPropertyResource):
	if prop.name_key != property_name:
		return
	texture_rect.texture = prop.texture
	progress_bar.max_value = prop.default_max_value
	self.modulate = prop.modulate
	progress_bar.value = prop.default_value
	label.text = "%d" % ceil(progress_bar.value)
