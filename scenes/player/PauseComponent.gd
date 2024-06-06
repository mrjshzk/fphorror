extends Node

@onready var pause_menu: Control = $PauseMenu


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause_menu.show()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			pause_menu.show()
