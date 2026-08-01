extends Area3D

func interagir():
	Global.tem_paper1 = true
	var ui = get_tree().get_first_node_in_group("ui")
	ui.paper1.visible = true
	get_tree().paused = true
	queue_free()
	
