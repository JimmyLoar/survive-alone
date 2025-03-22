class_name QuantitySelectorState
extends Injectable

var node: QuantitySelector

func _init(_node: QuantitySelector) -> void:
	node = _node

var is_opened:
	get: return self.node.is_opened

func open(max_value: int, title: String, on_confirm : Callable, on_cancel: Callable = func():):
	node.open(max_value, title, on_confirm, on_cancel)
