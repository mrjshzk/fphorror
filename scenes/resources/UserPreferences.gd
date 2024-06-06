class_name UserPreferences 
extends Resource

const dev_path : StringName = &"res://scenes/resources/user_preferences.tres"
const path : StringName = &"user://user_preferences.tres"

@export_category("Video Preferences")
@export var fullscreen := false:
	set(full):
		fullscreen = full
		if fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

@export_category("Audio Preferences")
@export_range(0.0, 1.0) var sound_volume := 1.0:
	set(volume):
		sound_volume = volume
		AudioServer.set_bus_volume_db(0, linear_to_db(sound_volume))

@export_category("Mouse Preferences")
@export_range(0.0, 10.0) var sensitivity_x := 1.0
@export var invert_x := false

@export_range(0.0, 10.0) var sensitivity_y := 1.0
@export var invert_y := false

static func create_or_load() -> UserPreferences:
	var prefs : UserPreferences
	
	if OS.has_feature("standalone"):
		if ResourceLoader.exists(path):
			prefs = load(path)
	else:
		if ResourceLoader.exists(dev_path):
			prefs = load(dev_path) as UserPreferences
	
	if not prefs:
		prefs = UserPreferences.new()
	return prefs

func save() -> void:
	if OS.has_feature("standalone"):
		ResourceSaver.save(self, path)
	else:
		ResourceSaver.save(self, dev_path)
