extends ContentContainer

var _state: CraftState
@onready var game_time: GameTimeState = Locator.get_service(GameTimeState)

var ordered_views: Array[Node] = []
@onready var _node_plase = $_MarginContainer/HBoxContainer/MainContainer/VBoxContainer/ScrollContainer/VBoxContainer

@onready var _serch_node = $_MarginContainer/HBoxContainer/SubContainer/Control/VBoxContainer/MarginContainer/LineEdit
var known_recipes_views = []

var category_for_view = {}

func _enter_tree() -> void:
	_state = Locator.initialize_service(CraftState)

func _init_category_for_view():
	for category in ItemResource.Category:
		category_for_view.merge({ItemResource.Category[category]: false})

func _ready():
	_init_category_for_view()
	for recipe in _state.recipes:
		ordered_views.append(recipe._view)
		_node_plase.add_child(recipe._view)
		
	for recipe in _state.known_recipes:
		known_recipes_views.append(recipe._view)
	
	_state.recipe_added.connect(func(recipe):
		known_recipes_views.append(recipe._view)
		_sort()
		)
		
	_sort()
	_update_view_by_category()

	


func _sort_by_knowlage_factor():
	ordered_views.sort_custom(func(x, y):	
		if (y in known_recipes_views) < (x in known_recipes_views):
			return true
		return false)


func _update_node_order():
	var current = _node_plase.get_children()
	if current == ordered_views:
		return  
	for i in range(len(ordered_views)):
		_node_plase.move_child(ordered_views[i], i)

func _update_view_by_category():
	var all_category_of = category_for_view.values().all(func(x): return x == false)
	for view in ordered_views:
		if all_category_of:
			view.visible = true
		else:
			view.visible = __category_coincides_any(view.recipe.recipe_categories)



func __category_coincides_any(categories):
	for category in categories:
		if category_for_view.get(category):
			return true
	return false


func _sort():
	_sort_by_knowlage_factor()
	_update_node_order()

func _update_view_():
	_update_view_by_category()
	_update_view_by_serch()
	
func __debug_print(s):
	for x in s:
		print(x.as_string())

func _on_tools_toggled(toggled_on):
	category_for_view[ItemResource.Category.TOOL] = toggled_on
	_update_view_()


func _on_food_toggled(toggled_on):
	category_for_view[ItemResource.Category.FOOD] = toggled_on
	_update_view_()


func _on_material_toggled(toggled_on):
	category_for_view[ItemResource.Category.MATERIAL] = toggled_on
	_update_view_()

func _update_view_by_serch():
	if _serch_node.text:
		for view in ordered_views: 
			if view.visible:
				if not _serch_node.text in view.recipe.as_string():
					view.visible = false

func _on_line_edit_text_changed(new_text):
	_update_view_()
