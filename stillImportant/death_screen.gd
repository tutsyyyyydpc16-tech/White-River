extends Control

func _ready() -> void:
	$CanvasLayer/Return.visible = false
	$CanvasLayer/Exit.visible = false
	
	await get_tree().create_timer(2.0).timeout
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	$CanvasLayer/Return.visible = true
	$CanvasLayer/Exit.visible = true
	
func _on_return_pressed():
	get_tree().change_scene_to_file("res://forSceneContention/scenes/cena_contention.tscn")
	
func _on_exit_pressed():
	get_tree().change_scene_to_file("res://menuScreen/main_menu.tscn")
