extends CanvasLayer

@onready var fps_label = $FPSLabel
@onready var task_label = $task_text

var tempo = 0

func atualizar_task():
	task_label.text = Global.task_atual

func _process(delta):
	tempo += delta
	if tempo >= 0.5:
		fps_label.text = "FPS: %d" % Engine.get_frames_per_second()
		tempo = 0
	
