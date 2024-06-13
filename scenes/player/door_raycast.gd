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
			var vRotateDir := Vector3.UP
			var vBodyVel := object.angular_velocity
			var hingeVel = vRotateDir * vRotateDir.dot(vBodyVel)
			print(hingeVel)
			object.apply_torque(Vector3.UP * get_speed_add() * 30)
			


func _process(delta: float) -> void:
	mouse_input = Vector2.ZERO

	
func get_speed_add() -> float:
	var camera : Camera3D = get_parent_node_3d()
	var camera_trans := camera.get_camera_transform()
	var vBodyCenter := object.transform * object.center_of_mass
	var vJointToBody := (vBodyCenter - object.global_position).normalized()
	var vUp := camera_trans.basis.y
	var vRight := camera.basis.x
	var vForward := -camera_trans.basis.z
	var vPushAmount := (vUp + vForward) * mouse_input.y + vRight * -mouse_input.x
	var vPushRotateDir := vJointToBody.cross(vPushAmount)
	
	return vPushRotateDir.dot(Vector3.UP)
	
