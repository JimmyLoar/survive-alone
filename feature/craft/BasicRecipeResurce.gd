extends Resource
class_name BasicRecipe

@export var ingredients: Array[ItemNumberTuple]
@export var results: Array[ItemNumberTuple]
@export var craft_time: int = 10

var _categories_init = false
var _string_view: String
var recipe_categories: Array[ItemResource.Category] = []:
	get:
		if _categories_init:
			return recipe_categories
		else:
			_init_categories()
			return recipe_categories

var _view: Node:
	get:
		if _view:
			return _view
		else:
			_view = create_view(load("res://feature/craft/ui/CraftPlaneView.tscn"))
			return _view


func create_view(packed_view_scene: PackedScene) -> Node:
	var new_scene = packed_view_scene.instantiate()
	if new_scene.has_method('setup'):
		new_scene.setup(self)
	else:
		assert(false) # должен быть метод setup в view рецепта
	return new_scene

func _init_categories():
	_categories_init = true
	for ingedient in results:
		for category in ingedient.item.categories:
			if category not in recipe_categories:
					recipe_categories.append(category)

func as_string() -> String:
	if _string_view:
		return _string_view
	var s = ''
	for x in ingredients:
		s += x.item.code_name + ' '
	for x in results:
		s += x.item.code_name+ ' '
	_string_view = s
	return  s

func _init():
	print(as_string())
