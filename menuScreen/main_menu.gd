extends Node

func _on_play_pressed():
	get_tree().change_scene_to_file("res://cutscene/cutscene_intro.tscn")
	
func _on_exit_pressed() -> void:
	get_tree().quit()
	
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
