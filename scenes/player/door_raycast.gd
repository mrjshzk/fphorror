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
			var force_dir := object.global_position.direction_to(global_position)
			var vUp := self.global_transform.basis.y
			var vRight := self.global_transform.basis.x
			var vForward := -self.global_transform.basis.z
			var push_amount = (vUp + vForward) * mouse_input.y + vRight * -mouse_input.x
			var push :Vector3= Vector3.UP * push_amount * signf(force_dir.dot(-object.global_basis.z)) * 20
			print(push)
			object.apply_torque(push)


func _process(delta: float) -> void:
	mouse_input = Vector2.ZERO

	
