extends Area3D

func interagir():
	Global.tem_mapa = true
	var ui = get_tree().get_first_node_in_group("ui")
	ui.visible = true
	get_tree().paused = true
	queue_free()
	
