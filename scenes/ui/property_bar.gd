class_name PropertyBar
extends HBoxContainer

@export var property_name := ""

@onready var texture_rect: TextureRect = $TextureRect
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var data: Dictionary = PlayerProperty.get_property(property_name)

func _ready() -> void:
	texture_rect.texture = data.texture
	progress_bar.max_value = data.default_max_value
	progress_bar.value = PlayerProperty.get_value(property_name)
	self.modulate = data.modulate


func _process(delta: float) -> void:
	if fmod(Engine.get_frames_drawn(), 12) != 0:
		return
	
	progress_bar.value = PlayerProperty.get_value(property_name)
