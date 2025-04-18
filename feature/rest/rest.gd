extends MarginContainer

enum Props{
	exhaustion,
	hunger,
	thirst,
	fatigue,
}

const PROP_NAMES: Dictionary = {
	Props.exhaustion: "exhaustion", 
	Props.hunger: "hunger", 
	Props.thirst: "thirst", 
	Props.fatigue: "fatigue",
}
const MINUT_IN_HOUR = GameTimeEntity.MINUT_IN_HOUR

@export_category("Rest characteristics")

@export var selected_hours = 60
@export var _per_hour := {
	PROP_NAMES[Props.exhaustion]: 2.0, 
	PROP_NAMES[Props.hunger]: -2.6, 
	PROP_NAMES[Props.thirst]: -4.0, 
	PROP_NAMES[Props.fatigue]: 7.2,
	"rest_exhaustion": -0.75,
}
@export var _amount := Array()

var rest_effectivity = 1.0

var _state: RestScreenState

@onready var delta_container: HBoxContainer = %HBoxDeltaContainer
@onready var time_lable: Label = %TimeLable
@onready var effectivity_lable: Label = %EffectivityLable

@onready var character_state: CharacterState = Locator.get_service(CharacterState)
@onready var game_time: GameTimeState = Injector.inject(GameTimeState, self)
@onready var button_accept_rest: Button = %ButtonAcceptRest


func _enter_tree() -> void:
	_state = Injector.provide(RestScreenState, RestScreenState.new(self), self, Injector.ContainerType.CLOSEST)


func _ready():
	close()
	update_sprite_visual.call_deferred()


#region Открытие/Закрытие
func close() -> void:
	visible = false


func open() -> void:
	selected_hours = 0
	_amount.resize(4)
	_amount.fill(0)
	visible = true
	change_selected_time(1)


#endregion
#region Отслеживание взаимодействия
func _on_button_accept_rest_pressed():
	start_rest()


func _on_button_cancel_rest_pressed():
	close()


func _on_time_add_button_pressed():
	change_selected_time(1)


func _on_time_subtract_button_pressed():
	change_selected_time(-1)


#endregion
#region Визуал
func update_sprite_visual() -> void:
	var prop_icons = delta_container.get_children()
	
	for i in Props.values():
		var icon = prop_icons[i].icon
		var name = PROP_NAMES[i]
		var prop = character_state.get_property_data(name)
		
		if prop != null:
			icon.texture = prop.texture


func update_delta_visual(values: Array) -> void:
	for i in Props.values():
		var display = delta_container.get_child(i)
		var value = values[i]
		display.set_delta_number(value, i == Props.exhaustion)


func update_effectivity_text():
	effectivity_lable.text = "REST EFFECTIVITY: %d%%" % [rest_effectivity * 100]


#endregion
#region Расчеты времени и изменения харатеристик.
func change_selected_time(delta) -> void:
	if selected_hours + delta >= 1 and selected_hours + delta <= 24:
		time_lable.display_time(selected_hours * MINUT_IN_HOUR, (selected_hours + delta) * MINUT_IN_HOUR)
		selected_hours += delta
		var fatigue = character_state.get_property(PROP_NAMES[Props.fatigue])
		rest_effectivity = 1.0 if fatigue.value <= fatigue.get_max_value() else 0.25
		update_delta_stats(delta)


func start_rest():
	#Тут изменяются характеристики
	for i in Props.values():
		_apply_property(i)
	
	#Изменение времени
	game_time.finished_skip.connect(_reset_delta_properties, CONNECT_ONE_SHOT)
	game_time.timeskip(selected_hours * MINUT_IN_HOUR, 3)

	#По идее тут нужна анимация сна или-что-то такое
	close()


func _apply_property(key: Props):
	var property: CharacterPropertyEntity = character_state.get_property(PROP_NAMES[key])
	property.delta = _amount[key] / selected_hours / MINUT_IN_HOUR
	character_state.set_property(property)


func _reset_delta_properties(_value: int):
	for key in Props.values(): 
		var property: CharacterPropertyEntity = character_state.get_property(PROP_NAMES[key])
		var property_data: CharacterPropertyResource = character_state.get_property_data(PROP_NAMES[key])
		property.delta = property_data.default_delta_value
		character_state.set_property(property)


func update_delta_stats(delta: int) -> void:
	# Расчет изменения характеристик
	var hunger = character_state.get_property(PROP_NAMES[Props.hunger])
	var thirst = character_state.get_property(PROP_NAMES[Props.thirst])
	var exhaustion = character_state.get_property(PROP_NAMES[Props.exhaustion])
	var fatigue = character_state.get_property(PROP_NAMES[Props.fatigue])
	
	var _hunger_hours: int = abs(floor(hunger.value / _per_hour[PROP_NAMES[Props.hunger]]))
	var _thirst_hours: int = abs(floor(thirst.value / _per_hour[PROP_NAMES[Props.thirst]]))
	var _exhaustion_hours: int = abs(floor(exhaustion.value / _per_hour[PROP_NAMES[Props.exhaustion]]))
	var _fatigue_hours: int = abs(floor((fatigue.get_max_value() - fatigue.value) / _per_hour[PROP_NAMES[Props.fatigue]]))
	
	_amount[Props.exhaustion] = abs(min(_hunger_hours - selected_hours, 0) + min(_thirst_hours - selected_hours, 0)) * _per_hour[PROP_NAMES[Props.fatigue]]
	_amount[Props.hunger] = min(_hunger_hours, selected_hours) * _per_hour[PROP_NAMES[Props.hunger]]
	_amount[Props.thirst] = min(_thirst_hours, selected_hours) * _per_hour[PROP_NAMES[Props.thirst]]
	_amount[Props.fatigue] = max(min(_fatigue_hours, selected_hours), 0) * _per_hour[PROP_NAMES[Props.fatigue]] + max(selected_hours - _fatigue_hours, 0) * rest_effectivity

	if _amount[Props.exhaustion] == 0:
		_amount[Props.exhaustion] = min(abs(_per_hour["rest_exhaustion"] * selected_hours), exhaustion.value) * -1
	
	rest_effectivity = 1.0 if fatigue.value + _amount[Props.fatigue] < fatigue.get_max_value() else 0.25
	
	update_effectivity_text()
	update_delta_visual(_amount)


#endregion
