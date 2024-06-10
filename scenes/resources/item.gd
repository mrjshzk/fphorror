class_name Item
extends Resource

@export var name: StringName
@export var mesh: Mesh
@export_category("Orientation")
@export var position: Vector3
@export var rotation: Vector3
@export var scale: Vector3
@export var physical_scene: String
@export_category("Sway")
@export var sway_min := Vector2(-20, -20)
@export var sway_max := Vector2(20, 20)
@export_range(0,0.2,0.01) var sway_speed_position := 0.07
@export_range(0,0.2,0.01) var sway_speed_rotation := 0.1
@export_range(0,0.25,0.01) var sway_amount_position := 0.1
@export_range(0,50,0.1) var sway_amount_rotation := 30
