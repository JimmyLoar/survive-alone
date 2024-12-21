class_name ChangeDurabilityAction
extends IAction

@export var value := 0


func set_dependence(objects: Array): #virtual
	if objects[0] is Item:
		_dependence = objects[0] as Item
		return
	
	_dependence = null
	GodotLogger.warn("%s | setted dependence array have not [color=green]Item[/color]" % [self.get_script().get_global_name()], objects)
	return


func execute(): #virtual
	_dependence.change_durability(value)
