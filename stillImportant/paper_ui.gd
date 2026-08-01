extends Control

var pode_fechar = false

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _process(delta):
	if visible and Input.is_action_just_pressed("interact"):
		visible = true
		
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = true
		
		
