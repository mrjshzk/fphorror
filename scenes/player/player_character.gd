class_name Player
extends StairsCharacter


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var shapecast: ShapeCast3D = $ShapeCast3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	super(delta)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	handle_crouch()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	desired_velocity = velocity.normalized()
	move_and_stair_step()


func handle_crouch() -> void:
	var crouching := Input.is_action_pressed("crouch")
	if crouching:
		collider.shape.height -= get_physics_process_delta_time() * 5
	elif not shapecast.is_colliding():
		collider.shape.height += get_physics_process_delta_time() * 2
	
	collider.shape.height = clampf(collider.shape.height, 0.9, 1.8)

