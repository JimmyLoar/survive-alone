extends Node2D


@export var character: Character
@onready var chunk_container: Node2D = $ChunkContainer

var logger = GodotLogger.with("World")


@export var controller: CharacterController


func _ready() -> void:
	logger.info("Game starte with date '{hour}:{minut} {day}/{month}/{year}'".format(GameTime.get_date()))
	character.changed_chunk.connect(chunk_container.update_region)
	
	chunk_container.update_region(
		character.get_chunk_position()
		)


func _change_local_inventory(inventory_name: String):
	var menu: ContentMenu = get_node("UI/VBoxContainer/HBoxContainer/TabContainer/CM Loacation")
	menu.inventory_name = inventory_name
