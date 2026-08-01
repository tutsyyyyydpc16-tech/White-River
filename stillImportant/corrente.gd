extends Area3D

func interagir():
	if Global.tem_alicate:
		queue_free()
	else:
		Global.mensagem = "I need a plier"
