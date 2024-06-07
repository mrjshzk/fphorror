@tool
extends EditorPlugin

const MainPanel = preload("res://addons/reset_saves_&_preferences/button.tscn")

var main_panel_instance


func _enter_tree():
	main_panel_instance = MainPanel.instantiate()
	# Add the main panel to the editor's main viewport.
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, main_panel_instance)



func _exit_tree():
	if main_panel_instance:
		remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, main_panel_instance)
		main_panel_instance.queue_free()
