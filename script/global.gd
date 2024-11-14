extends Node

var current_map : Node3D
var can_be_paused = true


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func reset_map():
	# Resets the current scene/map.
	get_tree().change_scene_to_file("res://scenes/test_case.tscn")


func pause_game(value : bool) -> void:
	if can_be_paused:
		for that_player in get_tree().get_nodes_in_group("player"):
			that_player.ui.pause_screen(value)
		get_tree().paused = value


# Anchors the mouse to the screen if it wasn't already.
func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		pause_game(false)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
