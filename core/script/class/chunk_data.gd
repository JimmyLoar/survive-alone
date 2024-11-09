@tool
class_name ChunkData
extends Resource

@export var name: String = "chunk"

const STRUCTURE_DATA = 0
const STRUCTURE_POSITION = 1

var object_count := 0:
	set(value):
		object_count = value
		objects.resize(value)
		notify_property_list_changed()

var position: Vector2i = Vector2i.ZERO
var structure_image: Texture2D
var tags: Array[StringName] = []


var objects: Array[Array] = []


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	properties.append({
		name = "position",
		type = TYPE_VECTOR2I,
		usage = PROPERTY_USAGE_DEFAULT + PROPERTY_USAGE_READ_ONLY,
	})
	
	properties.append({
		name = "structure_image",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture2D",
		usage = PROPERTY_USAGE_DEFAULT + PROPERTY_USAGE_READ_ONLY,
	})
	
	properties.append({
		name = "object_count",
		type = TYPE_INT,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0,16,1,or_greater",
		usage = PROPERTY_USAGE_DEFAULT,
	})
	for i in object_count:
		objects[i].resize(2)
		properties.append({
			name = "object_%d/data" % i,
			type = TYPE_OBJECT,
			hint = PROPERTY_HINT_RESOURCE_TYPE,
			hint_string = "Resource",
			usage = PROPERTY_USAGE_DEFAULT,
		})
		
		properties.append({
			name = "object_%d/position" % [i],
			type = TYPE_PACKED_VECTOR2_ARRAY,
			usage = PROPERTY_USAGE_DEFAULT,
			})
	
	return properties

const _keys = {
	"data": STRUCTURE_DATA,
	"position": STRUCTURE_POSITION,
}

func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with("object"):
		objects.resize(object_count)
		var index: int = property.get_slice("/", 0).to_int()
		var key = property.get_slice("/", 1)
		objects[index].resize(2)
		objects[index][_keys[key]] = value
		return true
	return false


func _get(property: StringName) -> Variant:
	if property.begins_with("object"):
		objects.resize(object_count)
		var index: int = property.get_slice("/", 0).to_int()
		var key = property.get_slice("/", 1)
		objects[index].resize(2)
		return objects[index][_keys[key]]
	return null
