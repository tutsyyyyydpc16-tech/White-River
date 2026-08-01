extends Area3D

func _on_body_entered(body):
	if body.is_in_group("player_contention"):
		get_parent().player_perto = true

func _on_body_exited(body):
	if body.is_in_group("player_contention"):
		get_parent().player_perto = false
		
func interagir():
	get_parent().interagir()
	
