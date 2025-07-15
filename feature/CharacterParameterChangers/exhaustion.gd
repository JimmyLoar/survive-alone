extends CharacterParametrLooker
class_name ExhaustionLooker


var _exh_lvl_flags = [0, 0, 0, 0, 0]

var active: bool = true

var _exh_lvl:
	get:
		var sum = 0
		for f in _exh_lvl_flags:
			sum += f
		return sum

var _exh_lvl_delta_dict = {
	1: 0.01,
	2: 0.05,
	3: 0.2,
	4: 0.3
}
@onready var _game_time: GameTimeState = Locator.get_service(GameTimeState)

func _enter_tree() -> void:
	Locator.add_initialized_service(self)

func _ready() -> void:
	super._ready()
	_game_time.finished_step.connect(_update_props_by_time_spend)

func _on_property_changed(prop_data: CharacterPropertyEntity):
	if prop_data.data_name  == 'exhaustion':
		if prop_data.value >= prop_data.get_max_value():
			state.die()
	
	if prop_data.data_name == 'hunger':
		if prop_data.value <= 0:
			_exh_lvl_flags[0] = 1
		else:
			_exh_lvl_flags[0] = 0
	
	if prop_data.data_name == 'thirst':
		if prop_data.value <= 0:
			_exh_lvl_flags[1] = 1
		else:
			_exh_lvl_flags[1] = 0
			
			
func _update_props_by_time_spend(_delta):
	if !active:
		return
	if (_exh_lvl) == 0:
		return
	var exh = state.get_property('exhaustion')
	exh.value += _delta * _exh_lvl_delta_dict.get(_exh_lvl, 0)
	state.set_property(exh)
