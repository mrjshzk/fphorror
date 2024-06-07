extends RayCast3D


var current_item: Pickable = null

func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact"): return
	if is_colliding() and not current_item:
		current_item = get_collider()
		current_item.attach()
		%RemoteTransform.remote_path = get_path_to(current_item)
	elif current_item:
		%RemoteTransform.remote_path = get_path_to(self)
		current_item.drop(-get_parent_node_3d().global_basis.z)
		current_item = null
