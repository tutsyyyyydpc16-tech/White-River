extends Area3D

func interagir():
	if Global.parafuso_solto:
		$AnimationPlayer.play("open")
	else:
		Global.mensagem = "There's locked"
