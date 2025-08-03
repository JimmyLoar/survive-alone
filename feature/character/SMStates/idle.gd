extends SMachinaState

@export var character: Character


func enter(_previous_state: SMachinaState):
	if character:
		character._state.stop_moving()
