extends Area3D

signal id_coletada

func interagir():
	Global.tem_id = true
	emit_signal("id_coletada")
	print("coletei ID")
	queue_free() # Remove a chave do mundo
