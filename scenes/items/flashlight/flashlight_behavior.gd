extends Node3D

@onready var light: SpotLight3D = $SpotLight3D
var item_res: Item

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		light.visible = not light.visible
		item_res.phantom_data["visible"] = not item_res.phantom_data["visible"]

func _ready() -> void:
	position = item_res.interest_point
	if item_res.phantom_data.has("visible"):
		light.visible = item_res.phantom_data["visible"]
