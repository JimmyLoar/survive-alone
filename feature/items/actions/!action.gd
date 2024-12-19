class_name IAction
extends Resource

var _dependence: Variant


func set_dependence(objects: Array): #virtual
	_dependence = objects


func execute(): #virtual
	pass


func get_class_name():
	return self.get_script().get_global_name()
