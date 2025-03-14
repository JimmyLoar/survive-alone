class_name EventStageResource
extends Resource

@export var name: StringName = &"start"
@export_multiline var text: String = ""
@export var texture: Texture2D
@export var actions: Array[EventActionResource] = []

@export var showing_action_hints := false
