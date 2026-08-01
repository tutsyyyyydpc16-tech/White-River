extends Area3D

func interagir():
	if Global.tem_id:
		Global.modo_terror = true
		Global.mensagem = "Shit"
		
	else:
		Global.mensagem = "I need a ID badge"
