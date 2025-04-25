extends Node
class_name SMachina

var states = []
var curent_state: SMachinaState

@export var start_state: SMachinaState

func _ready():
	for x in get_children():
		if x is SMachinaState:
			states.append(x)
	_init_start_state()
	curent_state = start_state
	curent_state.enter(curent_state)
		

func _init_start_state():
	if not start_state:
		# долже быть хотя-бы 1 стейт
		start_state = states[0]
		

func _process(delta):
	curent_state.update(delta)
	
	

func change_state(new_state: SMachinaState):
	set_process(false)
	curent_state.exit()
	new_state.enter(curent_state)
	curent_state = new_state
	set_process(true)
	
