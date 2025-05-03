class_name VisibleTilesDiff
extends Object

var removed: Array[Rect2i] = []
var added: Array[Rect2i] = []
var updated: Array[Rect2i] = []

static func from_rect_diff(previous: Rect2i, current: Rect2i) -> VisibleTilesDiff:
	var diff = VisibleTilesDiff.new()
	
	var intersection = previous.intersection(current)
	var union = previous.merge(current)
	
	if intersection.size == Vector2i.ZERO:
		diff.removed.push_back(previous)
		diff.added.push_back(current)
		return diff
	#print("----")
	#print("previous ", previous.position, previous.end)
	#print("current ", current.position, current.end)
	#print("intersection ", intersection.position, intersection.end)
	#print("union ", union.position, union.end)
	if current.position.x != previous.position.x:
		var rect = Rect2i(
			union.position,
			Vector2i(
				intersection.position.x - union.position.x,
				union.end.y - union.position.y
			)
		)
		if current.position.x < previous.position.x:
			#print(".position.x added rect ", rect.position, rect.end)
			diff.added.push_back(rect)
		else:
			#print(".position.x removed rect ", rect.position, rect.end)
			diff.removed.push_back(rect)
			
	if current.position.y != previous.position.y:
		var rect = Rect2i(
			Vector2i(
				intersection.position.x,
				union.position.y
			),
			Vector2i(
				intersection.end.x - intersection.position.x,
				intersection.position.y - union.position.y
			)
		)
		if current.position.y < previous.position.y:
			#print(".position.y added rect ", rect.position, rect.end)
			diff.added.push_back(rect)
		else:
			#print(".position.y removed rect ", rect.position, rect.end)
			diff.removed.push_back(rect)
	if current.end.x != previous.end.x:
		var rect = Rect2i(
			Vector2i(
				intersection.end.x,
				union.position.y
			),
			Vector2i(
				union.end.x - intersection.end.x,
				union.end.y - union.position.y
			)
		)
		if current.end.x > previous.end.x:
			#print(".end.x added rect ", rect.position, rect.end)
			diff.added.push_back(rect)
		else:
			#print(".end.x removed rect ", rect.position, rect.end)
			diff.removed.push_back(rect)
	if current.end.y != previous.end.y:
		var rect = Rect2i(
			Vector2i(
				intersection.position.x,
				intersection.end.y
			),
			Vector2i(
				intersection.end.x - intersection.position.x,
				union.end.y - intersection.end.y
			)
		)
		if current.end.y > previous.end.y:
			#print(".end.y added rect ", rect.position, rect.end)
			diff.added.push_back(rect)
		else:
			#print(".end.y removed rect ", rect.position, rect.end)
			diff.removed.push_back(rect)

	return diff

static  func from_updated(_updated: Rect2i, current: Rect2i) -> VisibleTilesDiff:
	var diff = VisibleTilesDiff.new()
	var intersection = _updated.intersection(current)
	
	if intersection.size != Vector2i.ZERO:
		diff.updated.push_back(intersection)
	
	return diff
