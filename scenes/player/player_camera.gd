class_name FPSCamera extends Camera3D

@onready var save := GameSave.create_or_load()
@onready var prefs := UserPreferences.create_or_load()


@export var body : Node3D

# sensitivity options and invert
@export_category("Rotation Settings")
@export var can_rotate := true
@export var sensitivity_x: float = 0.005
@export var sensitivity_y: float = 0.005
@export var invert_x: bool = false
@export var invert_y: bool = false

# accumulators
@onready var rot_x = save.player_rotation_y
@onready var rot_y = save.camera_rotation_x:
	set(val):
		rot_y = clampf(val, deg_to_rad(-85), deg_to_rad(85))

@onready var body_target_basis : Basis = body.basis
@onready var self_target_basis : Basis = self.basis

func _ready():
	assert(body != null, "body is null")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Input.use_accumulated_input = false
	rotate_basis.call_deferred()

func _input(event):
	if not can_rotate and not Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: return
	if event is InputEventMouseMotion:
		# modify accumulated mouse rotation
		add_rot_x(event.relative.x, 0.005)
		add_rot_y(event.relative.y, 0.005)

func _physics_process(_delta: float) -> void:
	var controller_motion := Input.get_vector("look_up", "look_down", "look_left", "look_right")
	
	add_rot_x(controller_motion.y, 0.1)
	add_rot_y(controller_motion.x, 0.1)
	rotate_basis()

func add_rot_x(val: float, sens_override: float) -> void:
	rot_x += val * sens_override * prefs.sensitivity_x * Utils.bool_to_one(prefs.invert_x)
	
func add_rot_y(val: float, sens_override: float) -> void:
	rot_y += val * sens_override * prefs.sensitivity_x * Utils.bool_to_one(prefs.invert_x)

func rotate_basis() -> void:
	body.transform.basis = Basis()
	transform.basis = Basis()
	body.rotate_object_local(Vector3(0,1,0), rot_x)
	rotate_object_local(Vector3(1,0,0), rot_y)
