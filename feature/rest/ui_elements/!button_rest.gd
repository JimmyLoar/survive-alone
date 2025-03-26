extends ButtonSound

@onready var rest_state: RestScreenState = Injector.inject(RestScreenState, self)
# Called when the node enters the scene tree for the first time.


func _on_pressed():
	rest_state.open()
