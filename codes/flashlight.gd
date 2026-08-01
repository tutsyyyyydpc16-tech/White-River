extends Area3D

func interagir():
	
	Global.tem_lanterna = true
	queue_free() 
	Global.task_atual = "Find a way to escape"
