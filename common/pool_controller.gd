class_name ObjectsPool
extends Node

var _pool = []
var _create_template: Object

func _init(_type: int, _class: StringName = "", _script: Variant = null, _template: Object = null) -> void:
	_pool = Array([], _type, _class, _script)
	_create_template = _template


func add(object: Variant) -> bool:
	if is_object_validate(object):
		_pool.append(object)
		return true
	return false


func is_object_validate(object: Object) -> bool:
	if typeof(object) != _pool.get_typed_builtin():
		push_error("attempt to add incompatible type object to the pool")
		return false
	
	elif object.get_class() != _pool.get_typed_class_name():
		push_error("attempt to add incompatible class object to the pool")
		return false
	
	elif object.get_script() != _pool.get_typed_script():
		push_error("attempt to add incompatible scripte object to the pool")
		return false
	
	return true


func take() -> Variant:
	if _pool.is_empty():
		return _create()
	return _pool.pop_front()


func _create() -> Variant:
	match typeof(_create_template):
		TYPE_OBJECT when _create_template is PackedScene:
			return _create_template.instantiate()
		
		TYPE_OBJECT when _pool.get_typed_class_name() == "Resource":
			return _create_template.duplicate() 
		
		TYPE_OBJECT:
			return _create_template.new()
	
	return _create_template
