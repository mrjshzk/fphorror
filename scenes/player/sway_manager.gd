class_name SwayManager
extends Node3D

## TODO: implement procedural sway

var mouse_input: Vector2
var input_x: int = 0

@export var player: Player

@export_category("Bobbing")
@export var bob_amount : float = 0.02
@export var bob_freq : float = 0.01

@export_category("Sway Y")
@export var sway_treshold := 1.0 ## minimo de movimento de camara (minimo é 1)
@export var sway_lerp := 10.0 ## lerp weight combinado com delta
@export var sway_rotation: Vector3
@export var sway_normal: Vector3

@export_category("Sway Z")
@export var rotation_max_angle: float = 100 ## em degraus
@export var rotation_speed := 5.0


func _unhandled_input(event)-> void:
	if event is InputEventMouseMotion:
		var viewport_transform: Transform2D = get_tree().root.get_final_transform()
		mouse_input += event.xformed_by(viewport_transform).relative

func _process(delta: float) -> void:
	if mouse_input == null: return

	# TODO: usar smoothstep

	if absf(mouse_input.x) >= sway_treshold:
		var next_rotation := lerpf(rotation.y, sway_rotation.y * signf(-mouse_input.x), sway_lerp * delta)
		rotation.y = next_rotation
	
	if absf(mouse_input.y) >= sway_treshold:
		var next_rotation := lerpf(rotation.x, sway_rotation.x * signf(-mouse_input.y), sway_lerp * delta)
		rotation.x = next_rotation
	
	if absf(mouse_input.x) == 0:
		rotation.y = lerpf(rotation.y, sway_normal.y, sway_lerp * 0.5 * delta)
	
	if absf(mouse_input.y) == 0:
		rotation.x = lerpf(rotation.x, sway_normal.x, sway_lerp * 0.5 * delta)
	
	mouse_input = Vector2.ZERO
	bob(player.velocity.length_squared(), delta)

func bob(vel : float, delta):
	if vel > 0 and player.is_on_floor():
		position.y = lerpf(position.y, sin(Time.get_ticks_msec() * bob_freq) * bob_amount, 10 * delta)
		position.x = lerpf(position.x, sin(Time.get_ticks_msec() * bob_freq * 0.5) * bob_amount, 10 * delta)
		
	else:
		position.y = lerpf(position.y, 0, 10 * delta)
		position.x = lerpf(position.x, 0, 10 * delta)
