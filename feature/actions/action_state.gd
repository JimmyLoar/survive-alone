class_name ActionState
extends Injectable


var _logger: Log
var _node : Node


func _init(new_node: Node) -> void:
	_logger = Log.get_global_logger().with("ActionState")
	_node = new_node


#region PublicFunction
func can_execute(action_entity: ActionResource) -> bool:
	var result := true
	#if action_entity.has_type(ActionResource.ACTION_NEED_ITEMS):
		#result = result and _has_items_in_inventories(action_entity.get_values().need_items)
		#if not result:
			#_logger.debug("Can not execute '%s' become have not needed items" % action_entity.code_name)
	
	return result


func execute(action_entity: ActionResource) -> void:
	pass
	#var data := action_entity.get_values()
	#if action_entity.has_type(ActionResource.ACTION_CHANGE_PROPERTY):
		#_execute_properties(data.properties)
	#if action_entity.has_type(ActionResource.ACTION_NEED_ITEMS):
		#_execute_remove_items(data.need_items)
	#if action_entity.has_type(ActionResource.ACTION_REWARD_ITEMS):
		#_execute_add_items(data.reward_items)
	
#endregion


#region PropertyHandle
#func _execute_properties(properties: Dictionary):
	#var property_repository := _take_properties_repository()
	#var prop_state := Injector.inject(CharacterState, self) as CharacterState
	#for property_name in properties:
		#if properties[property_name] == 0:
			#continue
		#
		#var property: CharacterPropertyResource = property_repository.get_by_string_id(property_name)
		#property.default_value += properties[property_name]
		#prop_state.set_property(property)
#
#
#func _take_properties_repository() -> CharacterPropertyRepository:
	#return Injector.inject(CharacterPropertyRepository, self)
##endregion
#
#
##region ItemsHandle
#func _execute_remove_items(items_list: Dictionary):
	#var remaing = _remove_items_from_inventory(items_list, Injector.inject(InventoryCharacterState, self))
	#_logger.debug("Items removed from character inventory, remaing: ", remaing)
	#if not remaing.is_empty():
		#_logger.debug("Items removed from location inventory, remaing: ", remaing)
		#remaing = _remove_items_from_inventory(remaing, Injector.inject(InventoryLocationState, self))
#
#
#func _remove_items_from_inventory(items: Dictionary, inventory: InventoryState) -> Dictionary:
	#var remaing ={}
	#for item_name: StringName in items:
		#if items[item_name] == 0:
			#continue
		#
		#var entity := inventory.fetch_item(item_name)
		#var remaing_value = entity.decrease_total_amount(items[item_name])
		#if remaing_value <= 0:
			#continue
		#remaing[item_name] = remaing_value
	#return remaing
#
#
#func _execute_add_items(items_list: Dictionary):
	#var character_inventory := Injector.inject(InventoryCharacterState, self) as InventoryCharacterState
	#var database := Injector.inject(ResourceDb, self).connection as Database
	#for item_name in items_list:
		#if items_list[item_name] <= 0:
			#continue
		#character_inventory.add_item(database.fetch_data_string("items/%s" % item_name), items_list[item_name])
#
#
#func _has_items_in_inventories(items_list: Dictionary) -> bool:
	#var remaing = _has_items_in_inventory(items_list, Injector.inject(InventoryCharacterState, self))
	#_logger.debug("Character inventory have %s: " % ["not items" if not remaing.is_empty() else "all items"], remaing if not remaing.is_empty() else items_list)
	#if not remaing.is_empty():
		#remaing = _has_items_in_inventory(remaing, Injector.inject(InventoryLocationState, self))
		#_logger.debug("Location inventory have %s: " % ["not items" if not remaing.is_empty() else "all items"], remaing if not remaing.is_empty() else items_list)
	#return remaing.is_empty()
#
#
#func _has_items_in_inventory(items: Dictionary, inventory: InventoryState) -> Dictionary:
	#var remaing = {}
	#for item_name: StringName in items:
		#if items[item_name] == 0:
			#continue
		#
		#var quantity = inventory.find_and_get_amount(item_name)
		#if quantity >= items[item_name]:
			#continue
		#remaing[item_name] = items[item_name] - quantity
	#return remaing
##endregion
