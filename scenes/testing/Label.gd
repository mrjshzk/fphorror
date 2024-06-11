extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignals.item_swapped.connect(
		func(item: Item):
			self.text = item.name
	)
	GlobalSignals.item_dropped.connect(
		func(dropped_item: Item):
			self.text = ""
	)
