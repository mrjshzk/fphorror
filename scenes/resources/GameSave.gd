class_name GameSave
extends Resource

const dev_path : StringName = &"res://scenes/resources/game_save.tres"
const path : StringName = &"user://game_save.tres"

@export var player_global_position: Vector3
@export var camera_rotation_x: float
@export var player_rotation_y: float
@export var collider_height: float = 1.9

static func create_or_load() -> GameSave:
	var save_res : GameSave
	
	if OS.has_feature("standalone"):
		if ResourceLoader.exists(path):
			save_res = load(path)
	else:
		if ResourceLoader.exists(dev_path):
			save_res = load(dev_path)
	if not save_res:
		save_res = GameSave.new()
	return save_res

func save() -> void:
	if OS.has_feature("standalone"):
		ResourceSaver.save(self, path)
	else:
		ResourceSaver.save(self, dev_path)
