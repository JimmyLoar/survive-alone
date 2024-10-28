extends CanvasLayer

signal canseled

@onready var progress_bar: TextureProgressBar = $VBoxContainer/TextureProgressBar

func _ready() -> void:
	GameTime.time_update.connect(update)
	self.hide()


func show_with_time(value: int):
	progress_bar.max_value = value
	self.show()


func update(delta: int):
	if not visible: return
	progress_bar.value += delta
	if progress_bar.value == progress_bar.max_value:
		self.hide()
