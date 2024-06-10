extends Node

@export var player: Player
@export var camera: FPSCamera
@export var item_manager: ItemManager
@onready var game_save : GameSave = GameSave.create_or_load()


func _ready() -> void:
	load_from_save()


func load_from_save() -> void:
	item_manager.items = game_save.items
	item_manager.item = game_save.current_item
	player.global_position = game_save.player_global_position
	player.collider.shape.height = game_save.collider_height

func write_to_save() -> void:
	game_save.player_global_position = player.global_position
	game_save.player_rotation_y = camera.rot_x
	game_save.camera_rotation_x = camera.rot_y
	game_save.collider_height = player.collider.shape.height
	
	game_save.items = item_manager.items
	game_save.current_item = item_manager.item
	
	game_save.save()
	
func _exit_tree() -> void:
	write_to_save()


