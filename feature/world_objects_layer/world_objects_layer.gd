extends Node2D

var _state: WorldObjectsLayerState

func _enter_tree() -> void:
	_state = Injector.provide(WorldObjectsLayerState, WorldObjectsLayerState.new(), self, "closest")
