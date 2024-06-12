@tool
class_name ItemManager
extends Marker3D

var items : Array[Item] = [null, null, null, null]
@onready var mesh: MeshInstance3D = $SwayManager/MeshInstance3D
@onready var sway_manager: Node3D = $SwayManager

@onready var level: Node3D = get_tree().get_first_node_in_group("Level") ## KEEPINMIND - talvez arranjar uma solucao melhor para droppar
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
		if mesh and not Engine.is_editor_hint():
			
			for child in mesh.get_children():
				child.queue_free()
			if item.behaviour_scene != null:
				var behaviour_scene = item.behaviour_scene.instantiate()
				mesh.add_child(behaviour_scene)
			
		if Engine.is_editor_hint():
			load_item(value)
	
var can_swap := true

signal weapon_unloaded

func _ready() -> void:
	GlobalSignals.request_items.connect(
		func():
			GlobalSignals.receive_items.emit(items)
	)
	
	mesh.child_entered_tree.connect(
		func(node: Node):
			if "item_res" in node:
				node.set_deferred("item_res", item))
				
	
	level.child_entered_tree.connect(
		func(node: Node):
			if not node is PickableItem: return
			node.global_position = self.global_position 
			node.global_rotation = self.global_rotation
			node.call_deferred("apply_central_impulse", -get_parent().basis.z))
	
	## KEEPINMIND: isto so funciona porque SaveManager está em cima disto na scenetree
	if item == null:
		for it in items:
			if it != null:
				item = items[items.find(it)]
				
	if item:
		load_item(item)


func _input(event: InputEvent) -> void:
	if item != null and event.is_action_pressed("drop"):
		var scene : PackedScene = load(item.physical_scene)
		var rb : PickableItem = scene.instantiate()
		rb.item_resource = item
		var level: Node3D = get_tree().get_first_node_in_group("Level")
		GlobalSignals.item_dropped.emit(item)
		## connect signal to apply impulse on child entered
		
		
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

var load_tween : Tween
@export_category("Loading Item")
@export var load_ease: Tween.EaseType
@export var load_transition: Tween.TransitionType
@export var load_duration: float = 0.20
func load_item(i: Item) -> void:
	print("Loading item: %s" % i.name)
	if not Engine.is_editor_hint():
		item = i ## KEEPINMIND fix recursion in editor
	mesh.mesh = i.mesh
	rotation = i.rotation
	mesh.scale = i.scale
	if Engine.is_editor_hint():
		position = i.position
		return
	load_tween = create_tween()
	load_tween.set_ease(load_ease)
	load_tween.set_trans(load_transition)
	load_tween.tween_property(self, "position", i.position, load_duration).finished.connect(
		func():
			can_swap = true
	)
	GlobalSignals.item_swapped.emit(i)

var unload_tween: Tween
@export_category("Unloading item")
@export var unload_ease: Tween.EaseType
@export var unload_transition: Tween.TransitionType
@export var unload_duration: float = 0.20
func unload_item() -> bool:
	GlobalSignals.item_unloaded.emit(item)
	if item == null:
		return false
	unload_tween = create_tween()
	unload_tween.set_ease(unload_ease)
	unload_tween.set_trans(unload_transition)
	unload_tween.tween_property(self, "position", position + Vector3.DOWN, unload_duration).finished.connect(
		func():
			weapon_unloaded.emit()
	)
	return true

func add_item(i: Item) -> void:
	for _item in items:
		if _item == null:
			items[items.find(_item)] = i
			if not unload_item():
				load_item(i)
			else:
				await weapon_unloaded
			load_item(i)
			break
		
		
		

func swap_item(item_idx_to_swap: int):
	if items[item_idx_to_swap] == item or items[item_idx_to_swap] == null:
		return
	can_swap = false
	unload_item()
	await weapon_unloaded
	load_item(items[item_idx_to_swap])
