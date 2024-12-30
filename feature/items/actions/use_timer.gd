class_name UseTimerAction
extends IAction

@export_range(1, 144000, 1) var game_time := 1
@export_range(1, 1000, 1) var multiper := 1

var time: GameTimeCounter

func set_dependence(objects := []):
	time = objects[0] as GameTimeCounter


func execute():
	if not time: 
		breakpoint
		return
	time.add_action_time(game_time, multiper)
