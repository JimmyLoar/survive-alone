class_name Character
extends Node2D


@onready var controller: Node2D = $Controller

func _ready() -> void:
	controller.target = self

## TODO Добавить отслеживание, в каком чанке находится игрок
