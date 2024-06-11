extends Node3D

@onready var light: SpotLight3D = $SpotLight3D
var item_res: Item

var data : Dictionary
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		light.visible = not light.visible
		item_res.phantom_data["visible"] = not item_res.phantom_data["visible"]

func _ready() -> void:
	await get_tree().process_frame ## KEEPINMIND: isto é por no item holder item_res esta a ser set_deferred
	create_tween().tween_property(light, "light_energy", 5, 0.3)
	position = item_res.interest_point
	if item_res.phantom_data.has("visible"):
		light.visible = item_res.phantom_data["visible"]
	
	GlobalSignals.item_unloaded.connect(
		func(item: Item):
			if item == self.item_res:
				create_tween().tween_property(light, "light_energy", 0, 0.3)
	)
