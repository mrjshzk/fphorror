class_name Pickable
extends RigidBody3D


@export var item_name: String
@export var item_mesh: MeshInstance3D
@export var item_albedo_texture: Texture2D

var collider: CollisionShape3D
@onready var normal_material: StandardMaterial3D = item_mesh.mesh.material
@onready var picked_material: ShaderMaterial = ShaderMaterial.new()

func _ready() -> void:
	picked_material.shader = load("res://shaders/weapon_clipping_fix.gdshader")
	picked_material.set_shader_parameter("texture_albedo", item_albedo_texture)
	mass = 10
	self.add_to_group("ExcludeStairStep")
	for child in get_children():
		if child is CollisionShape3D:
			collider = child
			break

func attach() -> void:
	item_mesh.mesh.material = picked_material
	freeze = true
	collider.disabled = true

func drop(direction: Vector3) -> void:
	item_mesh.mesh.material = normal_material
	freeze = false
	collider.disabled = false
	apply_central_impulse(direction * 100)
