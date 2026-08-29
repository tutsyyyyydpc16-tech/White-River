extends CharacterBody3D

const SPEED_WALK = 2.0
const SPEED_RUN = 4.0
const ANGULO_VISAO = 60.0
const ALCANCE_VISAO = 8.0
const TEMPO_MEMORIA = 0.6
const DISTANCIA_JUMPSCARE = 2.3  # o quão perto pra disparar o susto

var debug_timer: float = 0.0

var viu_player = false
var memoria_timer = 0.0
var patrol_dir = Vector3.ZERO
var patrol_state = "idle"
var patrol_timer = 0.0
var jumpscare_ativado = false

@onready var anim = $AnimationPlayer
@onready var player = get_tree().get_first_node_in_group("player")
@onready var jumpscare_cam = $JumpscareCamera
@onready var key_contention: RigidBody3D = $Armature/Skeleton3D/KeyAttachment3D/key_contention

func _ready():
	print("BODY_V_3 READY RODOU")
	print("CHAVE ENCONTRADA: ", key_contention)
	anim.play("idle")
	_escolhe_novo_estado_patrulha()
	dropar_chave()

func _physics_process(delta):
	
	if jumpscare_ativado:
		return  # trava tudo durante o susto

	# Se o player ainda não foi encontrado (pode acontecer se o _ready() do
	# inimigo rodar antes do _ready() do player marcar o grupo "player"),
	# tenta achar de novo a cada frame até conseguir
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		if player == null:
			return

	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y += get_gravity().y * delta

	var vendo_agora = _consegue_ver_player()

	if vendo_agora:
		memoria_timer = TEMPO_MEMORIA
		viu_player = true
	else:
		memoria_timer -= delta
		viu_player = memoria_timer > 0.0

	# Checagem de distância roda sempre, independente do raycast de visão ter passado
	# nesse frame específico — contato físico direto sempre dispara o susto
	var distancia_player = global_position.distance_to(player.global_position)
	if distancia_player <= DISTANCIA_JUMPSCARE:
		_disparar_jumpscare()
		return

	if viu_player:
		_perseguir(delta)
	else:
		_patrulhar(delta)
		
	debug_timer -= delta

	if debug_timer <= 0.0:
		debug_timer = 0.5

		print(
			"[GLITCHER] ",
			"POS: ", global_position,
			" | Y: ", global_position.y,
			" | VEL: ", velocity,
			" | ROT_Y: ", rad_to_deg(rotation.y),
			" | NO_CHAO: ", is_on_floor(),
			" | ESTADO: ", ("CHASE" if viu_player else patrol_state),
			" | ANIM: ", anim.current_animation
		)

	move_and_slide()


func _disparar_jumpscare():
	jumpscare_ativado = true
	velocity = Vector3.ZERO

	if player.has_method("travar_movimento"):
		player.travar_movimento()

	jumpscare_cam.make_current()
	anim.play("jumpscare")
	await anim.animation_finished
	
	get_tree().change_scene_to_file("res://stillImportant/death_screen.tscn")

func _consegue_ver_player() -> bool:
	if player == null:
		return false
	var dir_player = player.global_position - global_position
	var distancia = dir_player.length()
	if distancia > ALCANCE_VISAO:
		return false
	dir_player.y = 0
	dir_player = dir_player.normalized()
	var frente = Vector3(-sin(rotation.y), 0, -cos(rotation.y))
	var angulo = rad_to_deg(frente.angle_to(dir_player))
	if angulo > ANGULO_VISAO:
		return false
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position + Vector3.UP, player.global_position + Vector3.UP)
	query.exclude = [self, $Armature/Skeleton3D/Cube/StaticBody3D]
	var result = space_state.intersect_ray(query)
	if result and not result.collider.is_in_group("player"):
		return false
	return true


func _perseguir(delta):
	var dir = player.global_position - global_position
	dir.y = 0
	if dir.length() > 0.01:
		dir = dir.normalized()
	else:
		dir = Vector3.ZERO
	rotation.y = lerp_angle(rotation.y, atan2(-dir.x, -dir.z), delta * 5.0)
	velocity.x = dir.x * SPEED_RUN
	velocity.z = dir.z * SPEED_RUN
	if anim.current_animation != "run":
		anim.play("run")


func _patrulhar(delta):
	patrol_timer -= delta
	if patrol_timer <= 0.0:
		_escolhe_novo_estado_patrulha()
	if patrol_state == "walk":
		rotation.y = lerp_angle(rotation.y, atan2(-patrol_dir.x, -patrol_dir.z), delta * 5.0)
		velocity.x = patrol_dir.x * SPEED_WALK
		velocity.z = patrol_dir.z * SPEED_WALK
		if anim.current_animation != "walk":
			anim.play("walk")
	else:
		velocity.x = 0
		velocity.z = 0
		if anim.current_animation != "idle":
			anim.play("idle")


func _escolhe_novo_estado_patrulha():
	if patrol_state == "idle":
		patrol_state = "walk"
		patrol_timer = randf_range(2.0, 4.0)
		var angle = randf_range(0, TAU)
		patrol_dir = Vector3(sin(angle), 0, cos(angle))
	else:
		patrol_state = "idle"
		patrol_timer = randf_range(1.5, 3.0)

func dropar_chave() -> void:
	print("[CHAVE] Timer iniciado. Aguardando 30 segundos...")

	await get_tree().create_timer(30.0).timeout

	if not is_instance_valid(key_contention):
		print("[CHAVE] ERRO: key_contention não existe!")
		return

	print("[CHAVE] 30 segundos passaram.")
	print("[CHAVE] Posição antes de cair: ", key_contention.global_position)
	print("[CHAVE] Freeze antes: ", key_contention.freeze)

	var transform_atual = key_contention.global_transform

	key_contention.reparent(get_tree().current_scene)
	key_contention.global_transform = transform_atual

	print("[CHAVE] Posição após reparent: ", key_contention.global_position)

	key_contention.freeze = false

	print("[CHAVE] Freeze depois: ", key_contention.freeze)

	await get_tree().create_timer(1.0).timeout

	print("[CHAVE] Posição 1 segundo depois: ", key_contention.global_position)

	if key_contention.global_position.y < transform_atual.origin.y:
		print("[CHAVE] CAIU! ✓")
	else:
		print("[CHAVE] NÃO CAIU! Algo está impedindo a física.")
