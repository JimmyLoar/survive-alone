extends Window

signal finished

const FIGHT_TIME = 5.0

var timer: SceneTreeTimer

@onready var progress_bar: ProgressBar = $PanelContainer/VBoxContainer/ProgressBar
@onready var label: Label = $PanelContainer/VBoxContainer/Label


func _ready() -> void:
	set_process(false)
	progress_bar.max_value = FIGHT_TIME


func start():
	label.text = title
	timer = get_tree().create_timer(FIGHT_TIME)
	timer.timeout.connect(_finish)
	set_process(true)


func _process(delta: float) -> void:
	progress_bar.value = FIGHT_TIME - timer.time_left


func _finish():
	set_process(false)
	finished.emit(true)
