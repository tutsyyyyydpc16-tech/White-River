extends Area3D

var aberto = false

func interagir():
	if not aberto:
		$AnimationPlayer.play("RESET")
		aberto = true
		Global.cutscene = true
	else:
		$AnimationPlayer.play_backwards("RESET")
		aberto = false
