extends Control

var recipe: BasicRecipe

func _ready():
	for item in recipe.ingredients:
		var new_node = load("res://feature/craft/ui/ItemNumberTupleView.tscn").instantiate()
		new_node.setup(item)
		%ingr.add_child(new_node)
		
	for item in recipe.results:
		var new_node = load("res://feature/craft/ui/ItemNumberTupleView.tscn").instantiate()
		new_node.setup(item)
		%res.add_child(new_node)

func setup(_recipe: BasicRecipe) -> void:
	recipe = _recipe
