class_name EventDialogueCharacter
extends Resource

@export var name: String

@export var avatars: Dictionary[String, Texture2D] = {
	defualt = preload("res://icon.svg"),
}
@export var name_modulate: Color = Color.WHITE
