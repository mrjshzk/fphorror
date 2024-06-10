@tool
class_name ItemManager
extends Marker3D

var items : Array[Item] = [null, null, null, null]
@onready var mesh: MeshInstance3D = $SwayManager/MeshInstance3D
@onready var sway_manager: Node3D = $SwayManager
@export var item: Item:
	set(value):
		if value == null:
			if mesh:
				mesh.mesh = null
				mesh.scale = Vector3.ONE
				for child in mesh.get_children():
					child.queue_free()
			position = Vector3.DOWN
			rotation = Vector3.ZERO
			item = null
			return
		item = value
		if mesh:
			for child in mesh.get_children():
				child.queue_free()
		
		if mesh:
			for child in mesh.get_children():
				child.queue_free()
			if item.behaviour_scene:
				var behaviour_scene = item.behaviour_scene.instantiate()
				behaviour_scene.position = item.interest_point
				mesh.add_child(behaviour_scene)
			
		if Engine.is_editor_hint() and value != null:
			load_item(value)

var can_swap := true

signal weapon_unloaded

func _ready() -> void:
	GlobalSignals.request_items.connect(
		func():
			GlobalSignals.receive_items.emit(items)
	)
	
	## KEEPINMIND: isto so funciona porque SaveManager está em cima disto na scenetree
	if item:
		load_item(item)


func _input(event: InputEvent) -> void:
	if item != null and event.is_action_pressed("drop"):
		var scene : PackedScene = load(item.physical_scene)
		var rb : RigidBody3D = scene.instantiate()
		
		var level: Node3D = get_tree().get_first_node_in_group("Level")
		## connect signal to apply impulse on child entered
		level.child_entered_tree.connect(
			func(node: Node):
				if not node is RigidBody3D: return
				rb.global_position = self.global_position 
				rb.global_rotation = self.global_rotation
				rb.call_deferred("apply_central_impulse", -get_parent().basis.z), CONNECT_ONE_SHOT)
		
		## add rigid body
		level.call_deferred("add_child", rb)
		var idx := items.find(item)
		item = null

		if idx >= 0:
			items[idx] = null
	
	if can_swap:
		if event.is_action_pressed("item1"):
			swap_item(0)
		elif event.is_action_pressed("item2"):
			swap_item(1)
		elif event.is_action_pressed("item3"):
			swap_item(2)
		elif event.is_action_pressed("item4"):
			swap_item(3)

func load_item(i: Item) -> void:
	item = i
	mesh.mesh = i.mesh
	rotation = i.rotation
	mesh.scale = i.scale
	create_tween().tween_property(self, "position", i.position, .15).finished.connect(
		func():
			can_swap = true
	)

func unload_item() -> void:
	create_tween().tween_property(self, "position", Vector3.DOWN, .15).finished.connect(
		func():
			weapon_unloaded.emit()
	)

func add_item(i: Item) -> void:
	for _item in items:
		if _item == null:
			items[items.find(_item)] = i
			break
	if items.size() == 1:
		load_item(i)
	else:
		unload_item()
		await weapon_unloaded
		load_item(i)

func swap_item(item_idx_to_swap: int):
	if items[item_idx_to_swap] == item or items[item_idx_to_swap] == null:
		return
	can_swap = false
	unload_item()
	await weapon_unloaded
	load_item(items[item_idx_to_swap])
