extends CanvasLayer

signal canseled

@onready var progress_bar: TextureProgressBar = $VBoxContainer/TextureProgressBar


func show_with_time(value: int):
	progress_bar.max_value = value
	progress_bar.value = 0
	self.show()


func update(delta: int):
	if not visible: return
	progress_bar.value += delta
	if progress_bar.value == progress_bar.max_value:
		self.hide()
