extends CanvasLayer

signal canseled

@onready var progress_bar: TextureProgressBar = $VBoxContainer/TextureProgressBar

func _ready() -> void:
	var game_time = Game.get_world_screen().get_game_time()
	game_time.time_updated.connect(update)
	self.hide()


func show_with_time(value: int):
	progress_bar.max_value = value
	progress_bar.value = 0
	self.show()


func update(delta: int):
	if not visible: return
	progress_bar.value += delta
	if progress_bar.value == progress_bar.max_value:
		self.hide()
