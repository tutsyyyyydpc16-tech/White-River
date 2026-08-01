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
		var interagivel = hit.is_in_group("interagivel")
		
		if interagivel:
			if interact_label != null:
				interact_label.visible = true
			crosshair.visible = true
		else:
			if interact_label != null:
				interact_label.visible = false
			crosshair.visible = false
			
		if interagivel and Input.is_action_just_pressed("interact"):
			if hit.has_method("interagir"):
				hit.interagir()
	else:
		if interact_label != null:
			interact_label.visible = false
		crosshair.visible = false
		
func  mostrar_hint_mapa():
	hint_map.visible = true
	await get_tree().create_timer(5.0).timeout
	hint_map.visible = false
