extends Node


func _init() -> void:
	initialize_service(GameDb)
	initialize_service(SaveDb)
	initialize_service(GameState)
	initialize_service(ResourceDb)
	initialize_service(ExecuteKeeperState)


var _storage: Dictionary = {}


func add_initialized_service(service: Object) -> void:
	var _name = service.get_script().get_global_name()
	_storage[_name] = service
	Log.get_global_logger().debug("added initialized service '[color=red]%s[/color]'" % [_name])


func initialize_service(script: GDScript, values: Array = []):
	var _name = script.get_global_name()
	var property = script.new.callv(values)
	Log.get_global_logger().debug("finished initialize service '[color=red]%s[/color]'.
		[color=yellow]Initialize values[/color]: " % [_name], values)
	_storage[_name] = property
	
	var signal_name = "ready_%s" % script.get_global_name()
	if has_user_signal(signal_name):
		emit_signal(signal_name)
	return property


func get_service(script: Script, emit_callable: Callable = func(o): pass) -> Object:
	if _storage.has(script.get_global_name()):
		return _storage[script.get_global_name()]
	
	Log.get_global_logger().debug("Failed to get service an '[color=red]%s[/color]' because it wasn't initialized!\n" % 
		[script.get_global_name()], get_stack())
	
	if not emit_callable:
		return null
	
	var signal_name = "ready_%s" % script.get_global_name()
	if not has_user_signal(signal_name):
		add_user_signal(signal_name, [{"name": "service", "type": TYPE_OBJECT}])
		connect(signal_name, remove_user_signal, CONNECT_ONE_SHOT)
	
	connect(signal_name, emit_callable, CONNECT_ONE_SHOT)
	Log.get_global_logger().debug("A signal will be emitted connected to '[color=lightblue]%s[/color]' when server '[color=red]%s[/color] is initialized.' \n" % 
		[script.get_global_name()])
	return null



func _init_state(property: Variant, state: GDScript, _signal: Signal, values: Array = []) -> Object:
	if not property:
		property = state.new.callv(values)
		_signal.emit(property)
		Log.get_global_logger().debug("init state '[color=red]%s[/color] %s'\n" % [state.get_global_name(), property], values)
	return property 
