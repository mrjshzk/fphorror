extends Node3D

var item_res: Item
var data: Dictionary
@onready var mesh: MeshInstance3D = get_parent()
@onready var start_position : Vector3 = mesh.position
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("interact"):
		mesh.position.y = lerpf(mesh.position.y, (sin(Time.get_ticks_msec() * 0.025) * 0.5), delta)
	else:
		mesh.position = mesh.position.lerp(start_position, delta * 5)

