extends GutTest

var inventory := Inventory.new("for testing")


func test_append_used():
	var item := inventory.add_item(preload("res://content/items/tools/homemade_knife.tres"), 6, [10, 25])
	item.append_used([5, 0, 18, -4])
	assert_eq(item.get_used(), [10, 25, 5, 18])
	assert_eq(item.get_total_amount(), 10)


func test_add_item():
	pass


func test_change_durability():
	var item := inventory.add_item(preload("res://content/items/tools/primus.tres"), 15, [15, 45])
	assert_eq(item.get_total_amount(), 17)
	item.change_durability(66)
	assert_eq(item.get_used(), [item._data.durability - 6])
	assert_eq(item.get_total_amount(), 15)
	#breakpoint
	
