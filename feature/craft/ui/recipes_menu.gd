extends Control

@onready var _state = Locator.get_service(CraftState)

func update_recipe_list():
	for recipe in _state.recipes:
		var new_plane = load("res://feature/craft/ui/CraftPlaneView.tscn").instantiate()
		new_plane.recipe = recipe
		$VBoxContainer/ScrollContainer/VBoxContainer.add_child(new_plane)
