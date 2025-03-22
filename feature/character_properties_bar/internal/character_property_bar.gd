extends HBoxContainer

@export_enum("exhaustion","fatigue","hunger","psych","radiation","thirst") var property_name: String:
	set(value):
		property_name = value
		if _character_state:
			render(_character_state.get_property_data(property_name))
		
@onready var texture_rect: TextureRect = $TextureRect
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label: Label = $ProgressBar/Label
@onready var _character_state: CharacterState = Injector.inject(CharacterState, self)


func _ready() -> void:
	_register_methods()
	_character_state.property_changed.connect(_on_property_changed)
	render(_character_state.get_property_data(property_name))


func _register_methods():
	var execute_keeper := Injector.inject(ExecuteKeeperState, self) as ExecuteKeeperState
	
	var set_prop = func (prop_name: String, value: int):
		var property := _character_state.get_property(prop_name) as CharacterPropertyEntity
		property.value += value
		_character_state.set_property(property)

	execute_keeper.register(execute_keeper.TYPE_EFFECT, 
		"set property", set_prop, 
		["enum/String/exhaustion,fatigue,hunger,psych,radiation,thirst", "int"], 
		["property_name", "value"],
		["exhaustion", 0]
	)
	
	var greater_than_value = func(prop_name: String, check_value: int) -> bool: 
		var property := _character_state.get_property(prop_name) as CharacterPropertyEntity
		return property.value >= check_value
	
	execute_keeper.register(execute_keeper.TYPE_CONDITION, 
		"property greater than value", greater_than_value, 
		["enum/String/exhaustion,fatigue,hunger,psych,radiation,thirst", "int"], 
		["property_name", "value"],
		["exhaustion", 0]
	)
	
	var less_than_max = func(prop_name: String) -> bool: 
		var property := _character_state.get_property(prop_name) as CharacterPropertyEntity
		return property.value < property.get_max_value()
	
	execute_keeper.register(execute_keeper.TYPE_CONDITION, 
		"property less than max value", less_than_max, 
		["enum/String/exhaustion,fatigue,hunger,psych,radiation,thirst"], 
		["property_name"],
		["exhaustion"]
	)
	return


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
