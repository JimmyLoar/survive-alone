class_name BiomeSerchUI
extends PanelContainer


var _state: BiomeSearchState

func _init() -> void:
	pass


func _enter_tree() -> void:
	_state = Injector.provide(BiomeSearchState, BiomeSearchState.new(self), self, Injector.ContainerType.CLOSEST)


func _ready() -> void:
	call_deferred("test")
	pass


func test(): 
	var event = _state.select_event()
	print(event.get_stage_text(0))
	event = _state.select_event()
	print(event.get_stage_text(0))
	event = _state.select_event()
	print(event.get_stage_text(0))
	event = _state.select_event()
	print(event.get_stage_text(0))


func display_event(event: BiomeSerchEventResource):
	self.show()
