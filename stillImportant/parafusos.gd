extends Area3D
	
func interagir():
	if Global.tem_screwdriver:
		queue_free()
		Global.parafuso_solto = true
	else:
		Global.mensagem = "I need a screwdriver"
