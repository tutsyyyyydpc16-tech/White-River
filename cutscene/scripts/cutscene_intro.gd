extends Node

@onready var video = $VideoStreamPlayer

func _ready():

	video.play()

	# tempo de segurança (ajusta pro tamanho do teu vídeo)
	var timer = get_tree().create_timer(20)

	# espera o vídeo OU o tempo acabar (o que vier primeiro)
	await timer.timeout

	get_tree().change_scene_to_file("res://forSceneContention/scenes/cena_contention.tscn")
	
func _input(event):
	if event.is_action_pressed("ui_accept") or Input.is_action_just_pressed("interact"):
		pular_cutscene()
	
func pular_cutscene():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://forSceneContention/scenes/cena_contention.tscn")
