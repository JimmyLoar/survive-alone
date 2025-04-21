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
	_logger.info("added initialized service '[color=orangered]%s[/color]'" % [_name])


func initialize_service(script: GDScript, values: Array = []):
	var _name = script.get_global_name()
	if _storage.has(_name):
		return _storage[script.get_global_name()]
	
	var service = script.new.callv(values)
	if not service:
		_logger.warn("FAILED initialize service '[color=orangered]%s[/color]', return Nil!" % [_name], values)
	else:
		_logger.info("finished initialize service '[color=orangered]%s[/color]'." % [_name], values)
	_storage[_name] = service
	
	var signal_name = "ready_%s" % script.get_global_name()
	if has_user_signal(signal_name):
		emit_signal(signal_name, service)
	return service


func get_service(script: Script, emit_callable: Callable = func(o): pass) -> Object:
	if _storage.has(script.get_global_name()):
		return _storage[script.get_global_name()]
	
	_logger.warn("Failed to get service an '[color=orangered]%s[/color]' because it wasn't initialized!" % 
		[script.get_global_name()])
	
	if not emit_callable:
		return null
	
	var signal_name = "ready_%s" % script.get_global_name()
	if not has_user_signal(signal_name):
		add_user_signal(signal_name, [{"name": "service", "type": TYPE_OBJECT}])
		connect(signal_name, _request_to_remove_signal, CONNECT_ONE_SHOT)
	
	connect(signal_name, emit_callable, CONNECT_ONE_SHOT)
	_logger.info("A signal '[color=lightblue]%s[/color]' will be emitted when service '[color=orangered]%s[/color] is initialized.'" % 
		[signal_name, script.get_global_name()])
	return null


func _request_to_remove_signal(_object: Object):
	remove_user_signal("ready_%s" % _object.get_script().get_global_name())
