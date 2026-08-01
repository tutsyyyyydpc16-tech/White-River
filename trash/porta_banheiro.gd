extends Area3D

var ja_aberto = false

func interagir():
	if not ja_aberto:
		$AnimationPlayer.play("open")
		ja_aberto = true
	else:
		$AnimationPlayer.play_backwards("open")
		ja_aberto = false
