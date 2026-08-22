extends Area3D

var ativado = false

func _on_body_entered(body):
	print("entrou ein")
	if body.is_in_group("player") and not ativado:
		ativado = true
		$AudioStreamPlayer3D.play()
		
		if not $AudioStreamPlayer3D.finished.is_connected(_on_musica_finished):
			$AudioStreamPlayer3D.finished.connect(_on_musica_finished)

## Quando a música ambiente termina de tocar, dispara a sequência da porta
## trancada: som + animação de queda, e depois o spawn do inimigo
func _on_musica_finished():
	var porta = get_tree().current_scene.get_node_or_null("contentionV3(organized)/Props/Doors/Porta_trancada/Door_locked")
	if porta and porta.has_method("glitch"):
		porta.glitch()
	else:
		push_warning("ativarGlitch: não encontrei a Porta_trancada pra disparar a sequência")
