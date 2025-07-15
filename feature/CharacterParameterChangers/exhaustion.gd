extends CharacterParametrLooker

var _exh_lvl_flags = [0, 0, 0, 0, 0]

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

func _ready() -> void:
	super._ready()
	_game_time.finished_step.connect(_update_props_by_time_spend)

func _on_property_changed(prop_data: CharacterPropertyEntity):
	print(prop_data.data_name)
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
	if (_exh_lvl) == 0:
		return
	var exh = state.get_property('exhaustion')
	exh.value += _delta * _exh_lvl_delta_dict.get(_exh_lvl, 0)
	state.set_property(exh)
