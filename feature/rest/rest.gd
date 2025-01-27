extends MarginContainer

var _state: RestScreenState

@export_category("Rest characteristics")

@export var fatigue_per_hour = 4
@export var hunger_per_hour = 1
@export var thirst_per_hour = 1
@export var damage_per_hour = 2
@export var dubled_damage_per_hour = 8

var selected_time = 60
var visual_time = 60

var _t = 0


func _enter_tree() -> void:
	_state = Injector.provide(RestScreenState, RestScreenState.new(self), self, "closest")


@onready var visual_number_1 = %TimerNumber1
@onready var visual_number_2 = %TimerNumber2
@onready var visual_number_3 = %TimerNumber3
@onready var visual_number_4 = %TimerNumber4

@onready var visual_delta_e = %DeltaExhausion
@onready var visual_delta_h = %DeltaHunger
@onready var visual_delta_t = %DeltaThrist
@onready var visual_delta_f = %DeltaFatigue

@onready var character_state: CharacterState = Injector.inject(CharacterState, self)
@onready var game_time: GameTimeState = Injector.inject(GameTimeState, self)


func _ready():
	close()
	Callable(func(): update_sprite_visual()).call_deferred()


#
# Открытие/Закрытие
#


func close() -> void:
	visible = false


func open() -> void:
	_state._selected_time = 60
	visual_time = 60
	update_time_visual()
	update_delta_stats()
	visible = true


#
# Отслеживание взаимодействия
#


func _on_button_accept_rest_pressed():
	start_rest()


func _on_button_cancel_rest_pressed():
	close()


func _on_time_add_button_pressed():
	change_selected_time(60)


func _on_time_subtract_button_pressed():
	change_selected_time(-60)


#
# Визуал
#


func update_sprite_visual() -> void:
	%IconE.texture = character_state.get_property("exhaustion").texture
	%IconH.texture = character_state.get_property("hunger").texture
	%IconT.texture = character_state.get_property("thirst").texture
	%IconF.texture = character_state.get_property("fatigue").texture


func update_time_visual() -> void:
	var hours = int(visual_time / 60)
	var minutes = int(visual_time % 60)

	visual_number_1.text = str(hours / 10)
	visual_number_2.text = str(hours % 10)
	visual_number_3.text = str(minutes / 10)
	visual_number_4.text = str(minutes % 10)


func update_delta_visual() -> void:
	visual_delta_e.set_delta_number(_state._delta_exhaustion)
	visual_delta_h.set_delta_number(_state._delta_hunger)
	visual_delta_t.set_delta_number(_state._delta_thirst)
	visual_delta_f.set_delta_number(_state._delta_fatigue)


func _process(delta):
	_t += delta
	visual_time = int(lerp(visual_time, _state._selected_time, _t))
	update_time_visual()
	if _t >= 1:
		set_process(false)


func start_update_time_visual() -> void:
	_t = 0
	set_process(true)


#
# Расчеты времени и изменения харатеристик.
#


func change_selected_time(delta) -> void:
	if _state._selected_time + delta >= 60 and _state._selected_time + delta <= 60 * 24:
		_state._selected_time += delta
		start_update_time_visual()
		update_delta_stats()


func start_rest():
	#Тут изменяются характеристики
	var hunger = character_state.get_property("hunger")
	hunger.default_value += _state._delta_hunger
	character_state.set_property(hunger)
	var thirst = character_state.get_property("thirst")
	thirst.default_value += _state._delta_thirst
	character_state.set_property(thirst)
	var exhaustion = character_state.get_property("exhaustion")
	exhaustion.default_value += _state._delta_exhaustion
	character_state.set_property(exhaustion)
	var fatigue = character_state.get_property("fatigue")
	fatigue.default_value += _state._delta_fatigue
	character_state.set_property(fatigue)
	#Изменение времени
	game_time.timeskip(_state._selected_time * 10)

	#По идее тут нужна анимация сна или-что-то такое
	close()


func update_delta_stats() -> void:
	# Расчет изменения характеристик
	var selected_hours = int(_state._selected_time / 60)

	_state._delta_fatigue = selected_hours * fatigue_per_hour

	var hunger = character_state.get_property("hunger")
	var thirst = character_state.get_property("thirst")

	# Если хватает и воды и еды
	if (
		hunger.default_value >= selected_hours * hunger_per_hour
		and thirst.default_value >= selected_hours * thirst_per_hour
	):
		_state._delta_thirst = -selected_hours * hunger_per_hour
		_state._delta_hunger = -selected_hours * thirst_per_hour
		_state._delta_exhaustion = 0
	# Если не хватает и воды и еды
	elif (
		hunger.default_value < selected_hours * hunger_per_hour
		and thirst.default_value < selected_hours * thirst_per_hour
	):
		_state._delta_thirst = -max(thirst.default_value, 0)
		_state._delta_hunger = -max(hunger.default_value, 0)
		_state._delta_exhaustion = selected_hours * dubled_damage_per_hour
	# Если не хватает чего-то одного
	else:
		_state._delta_thirst = -max(min(thirst.default_value, selected_hours * thirst_per_hour), 0)
		_state._delta_hunger = -max(min(hunger.default_value, selected_hours * hunger_per_hour), 0)
		_state._delta_exhaustion = selected_hours * damage_per_hour

	update_delta_visual()
