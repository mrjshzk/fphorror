@tool
extends Button

func _ready() -> void:
	self.pressed.connect(reset)

func reset() -> void:
	var dir_access := DirAccess.open("res://scenes/resources/")
	dir_access.remove("game_save.tres")
	dir_access.remove("user_preferences.tres")
