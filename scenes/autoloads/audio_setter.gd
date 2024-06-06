extends Node

var playback:AudioStreamPlaybackPolyphonic

const hover_sound : AudioStream = preload("res://assets/audio/ui/gui_click_7.mp3")
const click_sound : AudioStream = preload("res://assets/audio/ui/gui_click_2.mp3")

func _ready() -> void:
	set_process_mode(Node.PROCESS_MODE_ALWAYS)

func _enter_tree() -> void:
	# Create an audio player
	var player = AudioStreamPlayer.new()
	add_child(player)

	# Create a polyphonic stream so we can play sounds directly from it
	var stream = AudioStreamPolyphonic.new()
	stream.polyphony = 32
	player.stream = stream
	player.play()
	# Get the polyphonic playback stream to play sounds
	playback = player.get_stream_playback()
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node: Node):
	if node is Button:
		node.mouse_entered.connect(_play_hover)
		node.pressed.connect(_play_pressed)


func _play_hover() -> void:
	playback.play_stream(hover_sound, 0, 0, randf_range(0.9, 1.1))


func _play_pressed() -> void:
	playback.play_stream(click_sound, 0, 0, randf_range(0.9, 1.1))
