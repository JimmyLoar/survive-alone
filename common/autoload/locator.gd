extends Node


var _storage: Dictionary = {}
var _logger: Log = Log.get_global_logger().with("Locator")

func _init() -> void:
	initialize_service(GameDb)
	initialize_service(SaveDb)
	initialize_service(GameState)
	initialize_service(ResourceDb)
	initialize_service(ExecuteKeeperState)


func add_initialized_service(service: Object) -> void:
	var _name = service.get_script().get_global_name()
	if _storage.has(_name):
		return
	
	_storage[_name] = service
	_logger.info("added initialized service '[color=red]%s[/color]'" % [_name])


func initialize_service(script: GDScript, values: Array = []):
	var _name = script.get_global_name()
	if _storage.has(_name):
		return
	
	var property = script.new.callv(values)
	_logger.info("finished initialize service '[color=red]%s[/color]'.
		[color=yellow]Initialize values[/color]: " % [_name], values)
	_storage[_name] = property
	
	var signal_name = "ready_%s" % script.get_global_name()
	if has_user_signal(signal_name):
		emit_signal(signal_name)
	return property


func get_service(script: Script, emit_callable: Callable = func(o): pass) -> Object:
	if _storage.has(script.get_global_name()):
		return _storage[script.get_global_name()]
	
	_logger.warn("Failed to get service an '[color=red]%s[/color]' because it wasn't initialized!\n" % 
		[script.get_global_name()], get_stack())
	
	if not emit_callable:
		return null
	
	var signal_name = "ready_%s" % script.get_global_name()
	if not has_user_signal(signal_name):
		add_user_signal(signal_name, [{"name": "service", "type": TYPE_OBJECT}])
		connect(signal_name, remove_user_signal, CONNECT_ONE_SHOT)
	
	connect(signal_name, emit_callable, CONNECT_ONE_SHOT)
	_logger.info("A signal will be emitted connected to '[color=lightblue]%s[/color]' when server '[color=red]%s[/color] is initialized.'" % 
		[script.get_global_name()])
	return null
