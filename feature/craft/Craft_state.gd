extends Injectable
class_name CraftState

var _node
var _lambda: Callable
var _inventory_state: InventoryCharacterState
var _time_state: GameTimeState

var known_recipes: Array[BasicRecipe] = [
	load("res://feature/craft/testrec.tres"),
	load("res://feature/craft/ui/Recepies/test2.tres"),
	load("res://feature/craft/ui/Recepies/new_resource.tres"),
	]

func _init(node, gts: GameTimeState) -> void:
	_node = node
	Callable(func():
		_init_dependencies()
	).call_deferred()

func _init_dependencies():
	_inventory_state = Injector.inject(InventoryCharacterState, _node)
	_time_state = Injector.inject(GameTimeState, _node)

func craft_from_recipe(recipe: BasicRecipe):
	if recipe_can_be_crafted(recipe):
		if !_time_state:
			_time_state = Injector.inject(GameTimeState, _node)
		_lambda = Callable(func(x):  if x == 0: _fulfill(recipe))
		_time_state.finished_skip.connect(_lambda)
		_time_state.timeskip(recipe.craft_time, 3.0, true)
		
		


func _fulfill(recipe):
	_time_state.finished_skip.disconnect(_lambda)
	for tuple in recipe.ingredients:
		_inventory_state.remove_item(tuple.item.code_name, tuple.amount)
	for tuple in recipe.results:
		_inventory_state.add_item(tuple.item, tuple.amount)
	

func recipe_can_be_crafted(recipe: BasicRecipe) -> bool:
	if recipe not in known_recipes:
		return false
	
	for tuple in recipe.ingredients:
		if !_inventory_state.has_item_amount(tuple.item.code_name, tuple.amount):
			return false
	return true
