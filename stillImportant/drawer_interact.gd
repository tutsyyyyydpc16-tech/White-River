extends Area3D

var aberto = false

func interagir():
	if not aberto:
		$AnimationPlayer.play("open_drawer")
		$"../AudioStreamPlayer3D".play()
		aberto = true
	else:
		$AnimationPlayer.play_backwards("open_drawer")
		$"../AudioStreamPlayer3D".play()
		aberto = false
