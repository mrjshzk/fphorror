extends PickableItem

@onready var spotlight: SpotLight3D = $SpotLight3D

func _ready() -> void:
	super()
	spotlight.visible = item_resource.phantom_data["visible"]
