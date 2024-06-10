class_name PickableItem
extends RigidBody3D


@export var item_resource: Item

func _ready() -> void:
	add_to_group("ExcludeStairStep")
	lock_rotation = true
	collision_layer = 3
	collision_mask = 3
	

func get_picked() -> Item:
	queue_free()
	GlobalSignals.item_picked_up.emit(item_resource)
	return item_resource


