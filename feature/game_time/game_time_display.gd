class_name GameTimeDisplay
extends Label


var _time: GameTimeEntity


func _ready() -> void:
	_time = Locator.get_service(GameTimeState).time
	_time.changed_value.connect(_update_time_label)
	_update_time_label(0)


func _update_time_label(_delta):
	text = "{hour}:{minut} {day}/{month}/{year}".format(_time.get_date())
