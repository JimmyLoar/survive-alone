extends PanelContainer
class_name CraftPanelView

var recipe: BasicRecipe
@onready var _state = Injector.inject(CraftState, self)


func _ready():
	var recipe_view = load("res://feature/craft/ui/RecipeView.tscn").instantiate()
	recipe_view.setup(recipe)
	$PanelContainer/VBoxContainer/MarginContainer.add_child(recipe_view)


func _on_craft_button_pressed():
	_state.craft_from_recipe(recipe)
