extends Node

@onready var player = $"../Player"
@onready var camera = $"../Player/Camera3D"
@onready var light = $"../LuzDaSala"
@onready var glitcher = $"../Glitcher"

var acontecendo = false

func start_cutscene():
	if acontecendo:
		return
	
	acontecendo = true
	
	# trava o player
	player.set_process(false)
	player.set_physics_process(false)
	
	await piscar_luz()
	await virar_camera()
	await jumpscare()
	
	# devolve controle
	player.set_process(true)
	player.set_physics_process(true)
	
func piscar_luz():
	for i in range(5):
		light.visible = false
		await get_tree().create_timer(0.1).timeout
		light.visible = true
		await get_tree().create_timer(0.1).timeout
		
func virar_camera():
	var tempo = 0.5
	var t = 0.0
	
	var rot_inicial = camera.rotation.y
	var rot_final = rot_inicial + deg_to_rad(180)
	
	while t < tempo:
		t += get_process_delta_time()
		camera.rotation.y = lerp_angle(rot_inicial, rot_final, t / tempo)
		await get_tree().process_frame
		
func jumpscare():
	var pos_atras = player.global_transform.origin - player.global_transform.basis.z * 2.0
	
	glitcher.global_transform.origin = pos_atras
	glitcher.look_at(player.global_transform.origin, Vector3.UP)
	glitcher.visible = true
	
	await get_tree().create_timer(0.3).timeout
	
	# opcional: esconder depois
	glitcher.visible = false
