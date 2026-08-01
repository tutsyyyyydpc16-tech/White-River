extends Control #inventario

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):

	if Input.is_action_just_pressed("inventory"):
		$"../../task_ui".visible = false

		visible = !visible

		if visible:
			atualizar()

		get_tree().paused = visible

	else:
		$"../../task_ui".visible = true
func atualizar():
	print(Global.documentos)

	$paper.visible = "paper" in Global.documentos

	print($paper.visible)
