## A class that manages injectables.
## Valid injectables include:
## * [Injectable] &ndash; A class that extends Injectable.
## * [InjectionToken] &ndash; A class that instantiates an InjectionToken.
## * [String] &ndash; A string that matches the name of an InjectionToken or another string.
extends Node

## The name of the meta data that is added to nodes.
var META_INJECTABLES_NAME: String = 'InjectableMeatas'
## A list of nodes that have injectables.
var containers: Array = []

class MetaData:
	var type: Variant
	var value: Variant
	var container: Node
	var source: Node
	
	func _init(_type: Variant, _value: Variant, _container: Node, _source: Node):
		type = _type
		value = _value
		source = _source
		container = _container


## Provides an injectable to a node and it's children.
## * [type] &ndash; is the injectable class to provide. This can be an instance of Injectable or InjectionToken or String.
## * [value] &ndash; is value to provide
## * [source] &ndash; is node relative that makes provide. Usualy self  
## * [container] &ndash; is the node to add the provider data to. One of "root", "closest", "source".
## * 	"root" - value will be added to the root node. Create container if not exist
## * 	"closest" - value will be added to nerrest down to up parrent of source. Includes source
## * 	"source" - value will be added to the source node. Create container if not exist
## * [parameters] &ndash; is an array of parameters to pass to the Injectable's constructor. If the [type] is an InjectionToken, this is the value to inject, such as a [Node], [String], [Int], etc.
## * return &ndash; is provided value or null if not provided
func provide(type: Variant, value: Variant, source: Node, container = "source") -> Variant:
	if container is String and  container != 'source' and container != 'root' and container != "closest":
		printerr('Injectable.provide: "container" must be one of "root", "closest", "source".')
		push_error('Injectable.provide: "v" must be of "root", "closest", "source".')
		return null

	if !is_instance_of(value, type) and !(is_instance_of(type, InjectionToken) or (type is String)):
		printerr('Injectable.provide: "value" must be an instance of "type" or use InjectionToken or String.')
		push_error('Injectable.provide: "value" must be an instance of "type" or use InjectionToken or String.')
		return null

	if container is String and container == 'root':
		container = get_tree().root

	if container is String and container == 'closest':
		container = _closest_container(source)
		
	if container is String and container == 'source':
		container = source

	var meta_data = MetaData.new(type, value, container, source)

	container.tree_exiting.connect(func(): clear(container))

	var meta: Array = container.get_meta(META_INJECTABLES_NAME, [])
	meta.append(meta_data)
	source.set_meta(META_INJECTABLES_NAME, meta)

	if not container in containers:
		containers.append(source)

	return value

## Gets an injectable.
## [b]Note:[/b] It is not advised to use this function in [_process] or [_physics_process].
## * [type] &ndash; is the injectable class to inject into the node.
## * [source] &ndash; is the node to start looking for the injectable. This usually is set to self.
func inject(type: Variant, source: Node) -> Variant:
	var result =  _find_injectable(type, source)
	if result == null:
		printerr('Injectable.inject: Injected value not found.')
		push_error('Injectable.inject: Injected value not found.')
	
	return result

## Clears one or all nodes of their injectables.
## Nodes referencing the injectables will start to return null.
## You can call `Injector.clear('all')` before you change scenes to clear all injectables.
## * [source] &ndash; is the node to clear the injectables from. Defaults to 'all' which clears all nodes.
## 		* If [source] &ndash; is 'root', it will clear the injectables from the root node.
##		* If [source] &ndash; is 'all', it will clear the injectables from all nodes.
##		* If [source] &ndash; is a node, it will clear the injectables from that node.
## * [protect] &ndash; is an array of nodes to protect from being cleared. This is useful if you want to clear all injectables from a node and it's children but want to protect a few nodes from being cleared.
func clear(container: Variant, protect: Array=[]) -> void:
	if container is String and container == 'root':
		container = get_tree().root
	if container is String and container == 'all':
		for node in containers:
			var meta = node.get_meta(META_INJECTABLES_NAME, [])
			if !protect.has(node):
				for injectable in meta:
					_clear_injectable(injectable)
				containers.erase(node)
				node.set_meta(META_INJECTABLES_NAME, [])
	else:
		if containers.has(container):
			for node in containers:
				if _is_descendant_of(node, container):
					var meta = node.get_meta(META_INJECTABLES_NAME, [])
					if !protect.has(node):
						for injectable in meta:
							_clear_injectable(injectable)
						containers.erase(node)
						node.set_meta(META_INJECTABLES_NAME, [])


## Finds an injectable and recursively climbs up the node tree until it finds it.
## * [type] &ndash; is the injectable to find. This can be any valid injectable data type.
## * [source] &ndash; is the node to start looking for the injectable. Defaults to 'root' which starts at the root node.
## * [multi] &ndash; is a boolean that determines if multiple injectables should be returned. This climbs all the way to the top of the node tree and returns an array of all the injectables that were found.
## * [multiple] &ndash; is an array that is used internally to store the injectables that were found if [multi] is true.
func _find_injectable(type: Variant, container: Node) -> Variant:
	var meta: Array = container.get_meta(META_INJECTABLES_NAME, [])

	# Loop through the injectables on the node and check if they match the type.
	for meta_data in meta:
		# If the injectable is a string, check if the type is a string and if they match.
		if type is String:
			if (
				(meta_data.type is InjectionToken and meta_data.type.token_name == type) or
				(meta_data.type is String and meta_data.type == type)
			):
				return meta_data.value
		# If the injectable is an InjectionToken, check if the type is an InjectionToken and if they match.
		elif type is InjectionToken:
			if meta_data.type is InjectionToken and meta_data.type.token_name == type.token_name:
				return meta_data.value
		# If the injectable is an instance of the type, return it.
		elif is_instance_of(meta_data.value, type):
			return meta_data.value

	# If we haven't found the injectable, check the parent node.
	if container.get_parent():
		return _find_injectable(type, container.get_parent())

	# If we still haven't found the injectable, return null.
	return null

## Clears an injectable by setting it to null, the garbage collector will take care of the rest.
## * [injectable] &ndash; is the injectable to clear.
func _clear_injectable(injectable: Variant) -> void:
	if injectable is Dictionary:
		if injectable.value.has_method('_destroy'):
			injectable.value._destroy()
		injectable.clear()
	elif injectable is Injectable:
		if injectable.has_method('_destroy'):
			injectable._destroy()

## Checks if a node is a descendant of another node.
## * [node] &ndash; is the node to check.
## * [parent] &ndash; is the node to check if it is a parent of the node.
func _is_descendant_of(node: Node, parent: Node) -> bool:
	if node == parent:
		return true
	if node.get_parent() == null:
		return false
	return _is_descendant_of(node.get_parent(), parent)

## Clears all injectables when the scene is exited.
func _on_tree_exiting():
	clear('all')

## Creates an injectable.
## * [type] &ndash; is the injectable class to create. This can be an instance of Injectable or InjectionToken.
## * [source] &ndash; is the node to add the provider data to. This usually is set to [self] but can be any node.
## * [parameters] &ndash; is an array of parameters to pass to the Injectable's constructor. If the [type] is an InjectionToken, this is the value to inject, such as a [Node], [String], [Int], etc.
func _create_injectable(type: Variant, source: Node, parameters: Variant=null) -> Injectable:
	if not parameters is Array and parameters != null:
		parameters = [parameters]

	var klass = type.callv('new', parameters)
	if parameters is Dictionary:
		for key in parameters:
			klass[key] = parameters[key]
	klass.node_ref = source
	return klass

## Checks if a type is injectable.
## * [type] &ndash; is the type to check.
func _is_injectable(type: Variant) -> bool:
	if is_instance_of(type, Injectable) or is_instance_of(type, InjectionToken) or type is String:
		return true
	return false

func _node_has_injectable(node: Node, injectable: Variant) -> bool:
	var meta = node.get_meta(META_INJECTABLES_NAME, [])
	for item in meta:
		if item is String and injectable is String and item == injectable:
			return true
		elif item is Dictionary and injectable is InjectionToken and item.type.token_name == injectable.token_name:
			return true
		elif is_instance_of(item.value, injectable):
			return true
	return false
	
func _closest_container(node: Node) -> Node:
	if (node.get_meta(META_INJECTABLES_NAME, "not_exist") is Array):
		return node
	
	var parent = node.get_parent()
	if (parent):
		return _closest_container(parent)
	
	return null
