class_name FPSCamera extends Camera3D


@export_category("General Settings")
@export var body : Node3D

# sensitivity options and invert
@export_category("Rotation Settings")
@export var can_rotate := true
@export var sensitivity_x: float = 0.005
@export var sensitivity_y: float = 0.005
@export var invert_x: bool = false
@export var invert_y: bool = false
@export var side_rotation_speed := 0.5
@export_range(0, 90, 1) var side_rotation_angle := 5

# accumulators
@onready var rot_x = body.rotation.y
@onready var rot_y = 0


@onready var body_target_basis : Basis = body.basis
@onready var self_target_basis : Basis = self.basis

@onready var prefs := UserPreferences.create_or_load()

func _ready():
	assert(body != null, "body is null")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Input.use_accumulated_input = false

func _input(event):
	if event is InputEventMouseMotion and can_rotate and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# modify accumulated mouse rotation
		rot_x += event.relative.x * (0.005 * Utils.bool_to_one(prefs.invert_x))
		rot_y += event.relative.y * (0.005 * Utils.bool_to_one(prefs.invert_y))
		
		rot_y = clampf(rot_y, deg_to_rad(-85), deg_to_rad(85)) # clamp up and down rotation

		body.transform.basis = Basis()
		transform.basis = Basis()
		body.rotate_object_local(Vector3(0,1,0), rot_x)
		rotate_object_local(Vector3(1,0,0), rot_y)




func handle_side_rotation() -> void:
	var horizontal_input = Input.get_axis("move_left", "move_right")
	rotation.z += -int(horizontal_input) * side_rotation_speed * get_process_delta_time()
	rotation.z = clampf(rotation.z, deg_to_rad(-side_rotation_angle), deg_to_rad(side_rotation_angle))

