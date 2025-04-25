extends SMachinaState

@onready var _moving_line = %MovingLine
@onready var _line_cross = %Cross
@onready var _character = $"../.."

func enter(previous_state: SMachinaState):
	_moving_line.show()

var passability = {'water': 0, 'grass': 0.5}

func update(delta: float):
	var move_speed = _character.move_speed
	var position = _character.position
	var target_position = _character._state.target_position
	var position_with_gap = position + ((target_position - position).normalized() * _character.biome_check_gap) 
	var biom_passability = 1
	$"../../Marker2D".target_position = -position + position_with_gap
	
	for biome in _character._biomes_layer_state.get_visible_tile_biomes_fast(_character._biomes_layer_state.global_to_map(position_with_gap)):
		if biome.name in passability.keys():
			biom_passability = min(biom_passability, passability.get(biome.name))
			
	move_speed = move_speed * biom_passability
	
	var time_unit = _character.time_unit
	var move_step = delta * move_speed
	var distance = position.distance_to(target_position)

	if distance > move_step:
		update_position(position.move_toward(target_position, move_step))
		_character._game_time.do_step(time_unit)
		
	else:
		update_position(target_position)
		time_unit = max(time_unit * (distance / move_step), 1)
		_character._game_time.do_step(time_unit)
		
	_moving_line.points[0] = target_position - position
	_line_cross.position = target_position - position
	_character._update_props_by_time_spend(time_unit)
	
	if target_position == position or move_speed == 0:
		%CharacterStateMachina.change_state(%Idle)

func update_position(pos: Vector2):
	_character.position = pos
	_character._state.position_changed.emit(pos)
	_character._save_position_debounce.emit()



func exit():
	_moving_line.hide()
