extends HBoxContainer

@export var property_name: String
@onready var texture_rect: TextureRect = $TextureRect
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label: Label = $ProgressBar/Label
@onready var _character_state: CharacterState = Injector.inject(CharacterState, self)


func _ready() -> void:
	_character_state.property_changed.connect(_on_property_changed)
	var conditions: CondisionsAndEffects = Injector.inject(CondisionsAndEffects, self)
	conditions.register_custom_effect("set_charracter_property", 
		func (prop_name: String, check_value: int):
			var property := _character_state.get_property(property_name)
			_character_state.set_property(property)
	)
	conditions.register_custom_condition("has_charracter_property", 
		func(prop_name: String, check_value: int): 
			var property := _character_state.get_property(property_name)
			return property.default_value >= check_value
	)


func _on_property_changed(prop: CharacterPropertyResource):
	rerender(prop)


func rerender(prop: CharacterPropertyResource):
	if prop.code_name != property_name:
		return

	texture_rect.texture = prop.texture
	progress_bar.max_value = prop.default_max_value
	self.modulate = prop.modulate
	progress_bar.value = prop.default_value
	label.text = "%d" % ceil(progress_bar.value)
