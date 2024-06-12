class_name FPSCamera extends Camera3D

@onready var save := GameSave.create_or_load()
@onready var prefs := UserPreferences.create_or_load()


@export var body : Player

# sensitivity options and invert
@export_category("Rotation Settings")
@export var can_rotate := true
@export var sensitivity_x: float = 0.005
@export var sensitivity_y: float = 0.005
@export var invert_x: bool = false
@export var invert_y: bool = false

@export_category("Bobbing")
@export var bob_amount : float = 0.02
@export var bob_freq : float = 0.01
# accumulators
@onready var rot_x = save.player_rotation_y
@onready var rot_y = save.camera_rotation_x:
	set(val):
		rot_y = clampf(val, deg_to_rad(-85), deg_to_rad(85))

@onready var body_target_basis : Basis = body.basis
@onready var self_target_basis : Basis = self.basis


@onready var start_pos : Vector3 = position
func _ready():
	assert(body != null, "body is null")
	GlobalSignals.lock_camera.connect(
		func(): can_rotate = false; print("locked camera")
	)
	
	GlobalSignals.unlock_camera.connect(
		func(): can_rotate = true; print("unlocked camera")
	)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Input.use_accumulated_input = false
	rotate_basis.call_deferred()

func _input(event):
	if not can_rotate: return
	if not Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: return
	if event is InputEventMouseMotion:
		# modify accumulated mouse rotation
		add_rot_x(event.relative.x, 0.005)
		add_rot_y(event.relative.y, 0.005)

func _physics_process(_delta: float) -> void:
	if not can_rotate: return
	var controller_motion := Input.get_vector("look_up", "look_down", "look_left", "look_right")
	add_rot_x(controller_motion.y, 0.1)
	add_rot_y(controller_motion.x, 0.1)
	rotate_basis()
	bob(body.velocity.length_squared(), _delta)

func add_rot_x(val: float, sens_override: float) -> void:
	rot_x += val * sens_override * prefs.sensitivity_x * Utils.bool_to_one(prefs.invert_x)
	
func add_rot_y(val: float, sens_override: float) -> void:
	rot_y += val * sens_override * prefs.sensitivity_x * Utils.bool_to_one(prefs.invert_x)

func rotate_basis() -> void:
	body.transform.basis = Basis()
	transform.basis = Basis()
	body.rotate_object_local(Vector3(0,1,0), rot_x)
	rotate_object_local(Vector3(1,0,0), rot_y)

func bob(vel : float, delta):
	if vel > 0 and body.is_on_floor():
		position.y = lerpf(position.y, start_pos.y + sin(Time.get_ticks_msec() * bob_freq) * bob_amount, 10 * delta)
		position.x = lerpf(position.x, start_pos.x + sin(Time.get_ticks_msec() * bob_freq * 0.5) * bob_amount, 10 * delta)
		
	else:
		position.y = lerpf(position.y, start_pos.y, 10 * delta)
		position.x = lerpf(position.x, start_pos.x, 10 * delta)
