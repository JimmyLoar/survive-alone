class_name ChangeDurabilityAction
extends IAction

@export var value := 0


func set_dependence(objects: Array): #virtual
	if objects[0] is ItemEntity:
		_dependence = objects[0] as ItemEntity
		return
	
	_dependence = null
	Log.get_global_logger().warn("%s | setted dependence array have not [color=green]ItemEntity[/color]" % [self.get_script().get_global_name()], objects)
	return


func execute(): #virtual
	_dependence.change_durability(value)
