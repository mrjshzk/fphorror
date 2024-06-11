class_name Item
extends Resource




@export var name: StringName
@export var unique_name: StringName
@export var mesh: Mesh
@export_category("Orientation")
@export var position: Vector3
@export var rotation: Vector3
@export var scale: Vector3 = Vector3.ONE
@export var physical_scene: String


@export_category("Behaviour")
@export var phantom_data: Dictionary
@export var behaviour_scene: PackedScene
@export var interest_point := Vector3.ZERO
