extends Area3D
signal walkie_coletada

func interagir():
	# Lógica para quando o player aperta E
	emit_signal("walkie_coletada")
	queue_free() # Remove a chave do mun
