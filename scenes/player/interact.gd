extends RayCast3D


@onready var manager: Marker3D = %ItemManager

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_colliding():
		var item : Item = get_collider().get_picked()
		manager.add_item(item)
