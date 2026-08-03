extends Area3D

@export var inimigo_cena: PackedScene
@export var ponto_spawn: Node3D

func interagir():
	Global.mensagem = "FUCK!"


func glitch():
	var glitch_audio = $"../Glitch"
	glitch_audio.play()
	
	if not glitch_audio.finished.is_connected(_on_glitch_finished):
		glitch_audio.finished.connect(_on_glitch_finished)


func _on_glitch_finished():
	$Door_falling.play()
	$AnimationPlayer.play("fall")
	await $Door_falling.finished
	_spawnar_inimigo()


func _spawnar_inimigo():
	if inimigo_cena == null:
		push_warning("Nenhuma cena de inimigo foi atribuída no Inspetor!")
		return

	var inimigo = inimigo_cena.instantiate()
	get_tree().current_scene.add_child(inimigo)
	inimigo.global_position = ponto_spawn.global_position if ponto_spawn else global_position
