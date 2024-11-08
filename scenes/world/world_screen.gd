extends Node2D


@onready var chunk_container: Node2D = $ChunkContainer
@onready var character: Character = $Character

var logger = GodotLogger.with("World")


func _ready() -> void:
	logger.info("Game starte with date '{hour}:{minut} {day}/{month}/{year}'".format(GameTime.get_date()))
	character.changed_chunk.connect(chunk_container.update_region)
	
	chunk_container.update_region(
		character.get_chunk_position()
		)


func _change_local_inventory(inventory_name: String):
	var menu: ContentMenu = get_node("UI/VBoxContainer/HBoxContainer/TabContainer/CM Loacation")
	menu.inventory_name = inventory_name
