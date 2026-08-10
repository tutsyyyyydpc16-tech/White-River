extends  Node

@onready var label = $"task_ui/task_text"
@onready var mensagem: Label = %Label
@onready var pause_menu: CanvasLayer = %pause_menu

var mostrando_mensagem = false

# Ignora o input de "pause" por um instante logo que a cena carrega, pra não pegar
# um evento de tecla "sobrando" da troca de cena anterior (ex: clicar Play no menu
# principal), que às vezes causava uma pausa/despausa fantasma escondendo o reticle
var pronto_para_pause: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	mensagem.visible = false
	pause_menu.visible = false
	Global.task_atual = "Get the flashlight"
	label.text = Global.task_atual
	
	# Garantia extra: força o reticle visível no início, independente de
	# qualquer corrida de eventos que possa ter mexido nele antes disso
	if has_node("%DefaultReticle"):
		%DefaultReticle.get_parent().visible = true
	
	# Garante que os overlays visuais (CRT/Barrel/Pixel) nunca bloqueiem cliques do mouse,
	# já que eles são só efeito visual e não deveriam interceptar input nenhum
	for shader_layer_name in ["CRT", "Barrel", "Pixel"]:
		var shader_layer := get_node_or_null(shader_layer_name)
		if shader_layer and shader_layer.has_node("ColorRect"):
			shader_layer.get_node("ColorRect").mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Aplica as configurações salvas (brilho e efeito VHS/CRT) assim que a cena carrega
	SettingsManager.apply_scene_settings()
	
	# Espera alguns frames antes de aceitar input de pause, pra deixar qualquer
	# evento "fantasma" da troca de cena se dissipar primeiro
	await get_tree().create_timer(0.3).timeout
	pronto_para_pause = true

## Centraliza toda a lógica de pausar/despausar num único lugar, pra não
## repetir (e desincronizar) a mesma lógica em 3 funções diferentes
func _set_paused(paused: bool) -> void:
	get_tree().paused = paused
	pause_menu.visible = paused
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if paused else Input.MOUSE_MODE_CAPTURED)
	
	# Esconde o reticle inteiro enquanto o menu tá aberto, já que centralizado
	# ele acaba caindo bem em cima dos botões do menu
	if has_node("%DefaultReticle"):
		%DefaultReticle.get_parent().visible = not paused

func resume_game():
	_set_paused(false)
	
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
		
	if pronto_para_pause and Input.is_action_just_pressed("pause"):
		_set_paused(not pause_menu.visible)
		
func atualizar_task():
	label.text = Global.task_atual
	
func mostrar_mensagem(texto):
	mensagem.text = texto
	mensagem.visible = true
	
	await get_tree().create_timer(2.0).timeout
	
	mensagem.visible = false
	mostrando_mensagem = false
