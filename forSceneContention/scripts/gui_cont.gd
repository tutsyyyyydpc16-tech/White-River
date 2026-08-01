extends  Node

@onready var label = $"task_ui/task_text"
@onready var mensagem: Label = %Label
@onready var pause_menu: CanvasLayer = %pause_menu

var mostrando_mensagem = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	mensagem.visible = false
	pause_menu.visible = false
	Global.task_atual = "Get the flashlight"
	label.text = Global.task_atual
	
func resume_game():
	get_tree().paused = false
	pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func quit_game():
	get_tree().quit()
	
func set_task(body ,task_text: String):
		$task_ui/task_text.text = task_text
	
func _process(delta: float) -> void:
	
	label.text = Global.task_atual
	
	if Global.mensagem != "" and not mostrando_mensagem:
		
		mostrando_mensagem = true
		mostrar_mensagem(Global.mensagem)
		Global.mensagem = ""
		
	if Input.is_action_just_pressed("pause"):
		pause_menu.visible = !pause_menu.visible
		get_tree().paused = pause_menu.visible
		if get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if !get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
func atualizar_task():
	label.text = Global.task_atual
	
func mostrar_mensagem(texto):
	mensagem.text = texto
	mensagem.visible = true
	
	await get_tree().create_timer(2.0).timeout
	
	mensagem.visible = false
	mostrando_mensagem = false


func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
