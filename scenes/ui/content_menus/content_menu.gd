class_name ContentMenu
extends PanelContainer


@onready var main_container: MarginContainer = $MarginContainer/HBoxContainer/MainContainer
@onready var sub_container: TabContainer = $MarginContainer/HBoxContainer/SubContainer

var logger := GodotLogger.with("ContentMenu (%s)" % name)
