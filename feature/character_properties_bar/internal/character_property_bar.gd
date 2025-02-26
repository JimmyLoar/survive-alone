extends HBoxContainer

@export var property_name: String
@onready var texture_rect: TextureRect = $TextureRect
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label: Label = $ProgressBar/Label
@onready var _character_state: CharacterState = Injector.inject(CharacterState, self)


func _ready() -> void:
	_character_state.property_changed.connect(_on_property_changed)
	
	var effect = func (prop_name: String, value: int):
		var property := _character_state.get_property(prop_name)
		property.default_value += value
		_character_state.set_property(property)
	
	var condition = func(prop_name: String, check_value: int): 
		var property := _character_state.get_property(property_name)
		return property.default_value >= check_value
	
	var execute_keeper := Injector.inject(ExecuteKeeperState, self) as ExecuteKeeperState
	execute_keeper.register(execute_keeper.TYPE_EFFECT, 
		"set character property", effect, 
		["enum/String/exhaustion,fatigue,hunger,psych,radiation,thirst", "int"], 
		["exhaustion", 0]
	)
	execute_keeper.register(execute_keeper.TYPE_CONDITION, 
		"char property greater than value", condition, 
		["enum/String/exhaustion,fatigue,hunger,psych,radiation,thirst", "int"], 
		["exhaustion", 0]
	)
	
	condition = func(prop_name: String, check_value: int): 
		var property := _character_state.get_property(property_name)
		return property.default_value < check_value
	
	execute_keeper.register(execute_keeper.TYPE_CONDITION, 
		"char property less than value", condition, 
		["enum/String/exhaustion,fatigue,hunger,psych,radiation,thirst", "int"], 
		["exhaustion", 0]
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
