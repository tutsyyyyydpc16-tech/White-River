extends Area3D

var ativado = false

func _on_body_entered(body):
	print("entrou ein")
	if body.is_in_group("player") and not ativado:
		ativado = true
		$AudioStreamPlayer3D.play()
