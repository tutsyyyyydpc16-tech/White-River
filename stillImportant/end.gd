extends Area3D

func _on_body_entered(body):
	print(body.name)
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://level/end.tscn")
