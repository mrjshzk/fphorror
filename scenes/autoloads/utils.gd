extends Node

@onready var prefs = UserPreferences.create_or_load()

func bool_to_one(b: bool) -> int:
	return int(b) * 2 -1

func _ready() -> void:
	if prefs.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
