class_name ChunkData
extends Resource

enum ObjectType{
	MAIN_BUILD,
}

@export var objects := {
	Vector2(10, 10): ObjectType.MAIN_BUILD,
	Vector2(90, 6): ObjectType.MAIN_BUILD,
	Vector2(33, 70): ObjectType.MAIN_BUILD,
}
