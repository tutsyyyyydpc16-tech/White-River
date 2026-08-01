extends RayCast3D

var tem_chave = false
var tem_lanterna = false
var tem_arma = false
var lendo_papel = false
var tem_exit_key = false
var tem_walkie_talkie = false

@onready var light = $"../Camera3D/SpotLight3D"
@onready var crosshair = $"../../player_contention_ui/CanvasLayer/CenterContainer/crosshair"
@onready var interact_label = $CanvasLayer/interact_label
@onready var hint_map = $"../../player_hospital_ui/CanvasLayer/Hint"
@onready var ui = $"../../player_ui"
@onready var gun_in_hand = $"../Camera3D/gunHand"
@onready var walkie_in_hand = $"../Camera3D/Walkie_Talkie"
@onready var crosshair_ui = $"../../player_contention_ui/CanvasLayer/CenterContainer/crosshair"
@onready var paper_ui = $"../../player_contention_ui/CanvasLayer/Inventory/paper"
@onready var paper_ui2 = $"../../player_contention_ui/CanvasLayer/Inventory/paper2"
@onready var player = $"../.."

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	var player = get_parent().get_parent()
	
	add_exception(player)
	
	for child in player.get_children():
		add_exception(child)
		
	light.visible = false
	
	if crosshair != null:
		crosshair.visible = false
		
func _physics_process(_delta):
	if lendo_papel and Input.is_action_just_pressed("interact"):
		paper_ui.visible = false
		crosshair_ui.visible = true
			
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = false
		lendo_papel = false
		return
	# 🔦 lanterna
	if is_colliding():
		var hit = get_collider()
		
		var interagivel = hit.name in ["porta_hospital", "Duo_door", "Porta_banheiro", "office_chair", "Door_contention", "Door_locked", "Drawer_interact", "Drawer_interact2", "Trapdoor", "Parafusos",  "Screwdriver", "desktop", "Madeiras", "Corrente", "alicate", "martelo", "ID_Reader", "idbadge", "Walkie_Talkie", "mapa", "porta_normal", "PortaDupla", "CardReader", "ExitKey", "chave", "flashlight", "door", "paper", "paper1", "Card", "doorKey", "Rádio"]
		
		# 👁️ UI
		if interagivel:
			if interact_label != null:
				interact_label.visible = true
			crosshair.visible = true
		else:
			if interact_label != null:
				interact_label.visible = false
			crosshair.visible = false
			
		if hit.is_in_group("paper") and Input.is_action_just_pressed("interact") and not lendo_papel:
			
			if hit.has_method("interagir"):
				hit.interagir()
				print(paper_ui)
				print(paper_ui.visible)
				print(paper_ui.get_parent().visible)

		if hit.is_in_group("paper1") and Input.is_action_just_pressed("interact") and not lendo_papel:
			
			if hit.has_method("interagir"):
				hit.interagir()
			
		# 🎮 interação
		if interagivel and Input.is_action_just_pressed("interact"):
			if hit.name == "chave" and hit.has_method("interagir"):
				hit.interagir()
				tem_chave = true
				
			if hit.name == "porta_hospital" and hit.has_method("interagir"):
				hit.interagir()
				
			if hit.name == "Duo_door" and hit.has_method("interagir"):
				hit.interagir()
				
			if hit.name == "Porta_banheiro" and hit.has_method("interagir"):
				hit.interagir()
				
			if hit.name == "Trapdoor" and hit.has_method("interagir"):
				hit.interagir()
				
			if hit.name == "Drawer_interact" and hit.has_method("interagir"):
				hit.interagir()
				
			if hit.name == "Drawer_interact2" and hit.has_method("interagir"):
				hit.interagir()
				
			if hit.name == "Screwdriver" and hit.has_method("interagir"):
				hit.interagir()
				
			if hit.name == "Parafusos" and hit.has_method("interagir"):
				hit.interagir()
				
			if hit.name == "office_chair" and hit.has_method("interagir"):
				hit.interagir()
				
			if hit.name == "Door_contention" and hit.has_method("interagir"):
				hit.interagir()
				
			if hit.name == "Door_locked" and hit.has_method("interagir"):
				hit.interagir()
				
			if hit.name == "door" and hit.has_method("interagir"):
				hit.interagir()
				
			if hit.name == "alicate" and hit.has_method("interagir"):
				hit.interagir()
				
			if hit.name == "martelo" and hit.has_method("interagir"):
				hit.interagir()
				
			if hit.name == "Madeiras" and hit.has_method("interagir"):
				hit.interagir()
				
			if hit.name == "desktop" and hit.has_method("interagir"):
				hit.interagir()
				
			if hit.name == "Corrente" and hit.has_method("interagir"):
				hit.interagir()
				
			if hit.name == "ID_Reader" and hit.has_method("interagir"):
				hit.interagir()
				
			elif hit.name == "ExitKey" and hit.has_method("interagir"):
				hit.interagir()
				tem_exit_key = true
				
			elif hit.name == "mapa" and hit.has_method("interagir"):
				hit.interagir()
				player.tem_mapa = true
				mostrar_hint_mapa()
				
			elif hit.name == "Card" and hit.has_method("interagir"):
				hit.interagir()
				Global.tem_card = true
				
			elif hit.name == "Rádio" and hit.has_method("interagir"):
				hit.interagir()
	
			elif hit.name == "flashlight" and hit.has_method("interagir"):
				hit.interagir()
				Global.tem_lanterna = true
				light.visible = true
				
				if ui != null:
					Global.task_atual = "Find a way out"
					ui.atualizar_task()
				
				
			elif hit.name == "desktop_lamp" and hit.has_method("interagir"):
				hit.interagir()
					
			elif hit.name == "Walkie_Talkie" and hit.has_method("interagir"):
				hit.interagir()
				
				var player = get_parent().get_parent()
				player.tem_walkie_talkie = true
				if player.tem_walkie_talkie:
					print(player.has_method("iniciar_dialogo"))
					player.iniciar_dialogo()
				
				player.esconder_todos_itens()
				walkie_in_hand.visible = true
				player.item_atual = "walkie"
				
				hit.visible = false
				if hit.has_method("set_monitoring"):
					hit.set_monitoring(false)
					
				if walkie_in_hand != null:
					walkie_in_hand.visible = true
					
			elif hit.name == "CardReader" and hit.has_method("interagir"):
				hit.interagir(self)
				print("interagiu ein")
				
			var alvo = hit
			while alvo != null:
				if alvo.has_method("toggle_exit_door") or alvo.has_method("toggle_door") or alvo.has_method("toggle_cell_door") or alvo.has_method("toggle_normal_door"):
					break
				alvo = alvo.get_parent()
				
			if alvo != null:
				if alvo.has_method("toggle_exit_door"):
					if tem_exit_key:
						alvo.toggle_exit_door()
					else:
						print("Precisa da Chave de Saída")
						
				elif alvo.has_method("toggle_door"):
					if tem_chave:
						alvo.toggle_door()
					else:
						print("Precisa de chave")
						
				elif alvo.has_method("toggle_cell_door"):
					alvo.toggle_cell_door()
					
				elif alvo.has_method("toggle_normal_door"):
					alvo.toggle_normal_door()
					
					
						
	else:
		# 💀 quando NÃO tá olhando pra nada
		if interact_label != null:
			interact_label.visible = false
		crosshair.visible = false
		
func  mostrar_hint_mapa():
	hint_map.visible = true
	
	await get_tree().create_timer(5.0).timeout
	
	hint_map.visible = false
		
