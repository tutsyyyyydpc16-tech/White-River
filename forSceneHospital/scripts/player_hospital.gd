extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var cam = $Head/Camera3D
@onready var light = $Head/Camera3D/Flashlight/SpotLight3D
@onready var flashlight = $Head/Camera3D/Flashlight
@onready var dialogue = $PlayerHospitalUI/CanvasLayer/Inventory/DialoguePanel/Label
@onready var map = $PlayerHospitalUI/CanvasLayer/Inventory/Mapa
@onready var paper1 = $PlayerHospitalUI/CanvasLayer/Inventory/paper1
@onready var task = $PlayerHospitalUI/task_ui
@onready var walkie_in_hand = $Head/Camera3D/Walkie_Talkie

var ja_disparou = false
var ja_foi = false
var tem_arma = false
var tem_id = false
var mirando = false
var current_speed = SPEED
var tem_walkie_talkie = false
var tem_mapa = false

var bob_time := 0.0
var bob_amount := 0.03
var camera_original_pos := Vector3.ZERO

var item_atual = "gun"
var trocando_item = false
var gun_pos_original = Vector3(0.525, -0.33, -0.995)
var gun_pos_mira = Vector3(0.0, -0.228, -1.758)
var walkie_pos_original

var pagina = 0

var dialogos = [
	"Lu: Hello??",
	"Lu: Is anyone there?",
	"Isabelly: Who's speaking?",
	"Lu: Thank God... someone's alive",
	"Isabelly: Wha...",
	"Lu: What's your name, little girl?",
	"Isabelly: How do you know my gender?",
	"Lu: Your voice sounds feminine",
	"Isabelly: Oh",
	"Lu: I imagine you need help",
	"Lu: Where exactly are you?",
	"Isabelly: ...",
	"Lu: You're scared, aren't you?",
	"Isabelly: Why should I trust you?",
	"Isabelly: Who even are you?",
	"Lu: I'm a police officer. My name is Lu",
	"Isabelly: I don't trust cops anymore",
	"Lu: I understand, neither do I",
	"Lu: But you have to trust me",
	"Isabelly: Okay...",
	"Isabelly: I'm in the hospital...",
	"Lu: Shit",
	"Isabelly: What happened?",
	"Lu: Listen to me carefully, do exactly what I say, okay?",
	"Lu: Get out of there and go to a police station",
	"Lu: I won't be there... but my partner will"
	]
	
var indice_dialogo = 0


func _ready():
	
	if Global.modo_terror:
		dialogue.text = "Fuck"
	
	walkie_pos_original = walkie_in_hand.position
	light.visible = true
		
	camera_original_pos = cam.position
	if has_node("../SpawnRua"):
		var spawn = get_node("../SpawnRua")
		global_transform.origin = spawn.global_transform.origin
	if Global.tem_lanterna:
		light.visible = true

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("interact"):
		if dialogue.visible:
			if indice_dialogo < dialogos.size() - 1:
				indice_dialogo += 1
				mostrar_dialogo()
			else:
				dialogue.visible = false
				
	if Input.is_action_just_pressed("flashlight"):
		light.visible = !light.visible
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("inventory"):
		task.visible = false
		
		map.visible = false
		paper1.visible = false
		
		if pagina == 0 and Global.tem_mapa:
			map.visible = true
		
		if pagina == 1 and Global.tem_paper1:
			paper1.visible = true
			
	else:
		map.visible = false
		paper1.visible = false
		task.visible = true
		
	if Input.is_action_just_pressed("ui_right"):
		pagina += 1

	if Input.is_action_just_pressed("ui_left"):
		pagina -= 1

	pagina = clamp(pagina, 0, 1)
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if velocity.length() > 0.1 and is_on_floor():
		bob_time += delta * 10.0
		
		cam.position.y = camera_original_pos.y + sin(bob_time) * 0.02
	else:
		cam.position.y = lerp(cam.position.y, camera_original_pos.y, delta * 8.0)
		
	move_and_slide()
		
func mostrar_dialogo():
	dialogue.visible = true
	dialogue.text = dialogos[indice_dialogo]
	
func iniciar_dialogo():
	print("iniciou dialogo")

	indice_dialogo = 0

	print(dialogue)

	dialogue.visible = true
	dialogue.text = dialogos[indice_dialogo]

	print(dialogue.text)
	
