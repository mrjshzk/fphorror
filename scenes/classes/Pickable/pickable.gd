class_name PickableItem
extends RigidBody3D


@export var item_resource: Item

func _ready() -> void:
	GlobalSignals.receive_items.connect(check_if_in_inventory)
	add_to_group("ExcludeStairStep")
	add_to_group("Save")
	lock_rotation = false
	collision_layer = 3
	collision_mask = 3
	
	GlobalSignals.request_items.emit()

func get_picked() -> Item:
	queue_free()
	GlobalSignals.item_picked_up.emit(item_resource)
	return item_resource


func check_if_in_inventory(items: Array[Item]):
	for item in items:
		if item == null: continue
		if item.unique_name == item_resource.unique_name:
			queue_free()
			break
