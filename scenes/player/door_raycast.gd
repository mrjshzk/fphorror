extends RayCast3D


var is_holding := false
var object: RigidBody3D = null
var mouse_input: Vector2


func _unhandled_input(event)-> void:
	if event is InputEventMouseMotion:
		var viewport_transform: Transform2D = get_tree().root.get_final_transform()
		mouse_input += event.xformed_by(viewport_transform).relative

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if self.is_colliding():
			GlobalSignals.lock_camera.emit()
			is_holding = true
			object = self.get_collider()
	elif event.is_action_released("interact"):
		GlobalSignals.unlock_camera.emit()
		is_holding = false
		object = null

func _physics_process(delta: float) -> void:
	if is_holding:
		if object != null:
			print(Vector3(0,1,0) * -get_speed_add() * 20)
			object.apply_torque(Vector3(0,1,0) * -get_speed_add() * 20)

func _process(delta: float) -> void:
	mouse_input = Vector2.ZERO

# KEEPINMIND
func get_speed_add() -> float:
	var vBodyCenter := self.transform * object.center_of_mass
	var jointToBody := (vBodyCenter - object.get_parent_node_3d().global_position).normalized()
	var vUp := self.transform.basis.y
	var vRight := self.transform.basis.x
	var vForward := -self.transform.basis.z
	var push_amount = (vUp + vForward) * mouse_input.y + vRight * -mouse_input.x
	var vPushRotateDir = jointToBody.cross(push_amount)
	return vPushRotateDir.dot(Vector3(0,1,0))
	
