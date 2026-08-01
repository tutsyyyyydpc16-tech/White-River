extends Area3D

func interagir():
	if Global.tem_martelo:
		queue_free()
	else:
		Global.mensagem = "I need a hammer"
		
