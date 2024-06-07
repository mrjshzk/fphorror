extends Control

## PAUSE MENU NODES
@onready var main: VBoxContainer = %Main
@onready var resume_button: Button = %Resume
@onready var options_button: Button = %OpenOptions
@onready var quit_button: Button = %Quit


## PAUSE OPTIONS NODES
@onready var options: VBoxContainer = %Options
@onready var full_screen: CheckBox = %CheckBox
@onready var volume_slider: HSlider = %VolumeSlider
@onready var back_button: Button = %OptionsBack

## USER PREFERENCES
@onready var prefs := UserPreferences.create_or_load()

func _ready() -> void:
	# set variables according to preferences
	full_screen.button_pressed = prefs.fullscreen
	volume_slider.value = prefs.sound_volume
	
	# connect signals
	resume_button.pressed.connect(unpause)
	quit_button.pressed.connect(quit_game)
	options_button.pressed.connect(show_options)
	back_button.pressed.connect(show_pause)
	full_screen.toggled.connect(func(enabled: bool): prefs.fullscreen = enabled)
	volume_slider.value_changed.connect(func(val: float): prefs.sound_volume = val)
	visibility_changed.connect(toggle_pause)

func toggle_pause() -> void:
	if self.visible:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		show_pause()

func unpause() -> void:
	self.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().set_deferred("paused", false)
	

func show_options() -> void:
	main.hide()
	options.show()
	back_button.grab_focus()

func show_pause() -> void:
	options.hide()
	main.show()
	resume_button.grab_focus()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		unpause()

func quit_game() -> void:
	prefs.save()
	get_tree().quit()
