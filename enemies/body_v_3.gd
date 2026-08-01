extends CharacterBody3D

const SPEED_WALK = 2.0
const SPEED_RUN = 4.0
const ANGULO_VISAO = 60.0
const ALCANCE_VISAO = 8.0
const TEMPO_MEMORIA = 0.6
const DISTANCIA_JUMPSCARE = 1.2  # o quão perto pra disparar o susto

var viu_player = false
var memoria_timer = 0.0
var patrol_dir = Vector3.ZERO
var patrol_state = "idle"
var patrol_timer = 0.0
var jumpscare_ativado = false

@onready var anim = $AnimationPlayer
@onready var player = get_tree().get_first_node_in_group("player")
@onready var jumpscare_cam = $JumpscareCamera

func _ready():
	anim.play("idle")
	_escolhe_novo_estado_patrulha()

func _physics_process(delta):
	if jumpscare_ativado:
		return  # trava tudo durante o susto

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

	if viu_player:
		var distancia = global_position.distance_to(player.global_position)
		if distancia <= DISTANCIA_JUMPSCARE:
			_disparar_jumpscare()
			return
		_perseguir(delta)
	else:
		_patrulhar(delta)

	move_and_slide()


func _disparar_jumpscare():
	jumpscare_ativado = true
	velocity = Vector3.ZERO

	if player.has_method("travar_movimento"):
		player.travar_movimento()

	jumpscare_cam.make_current()
	anim.play("jumpscare")
	await anim.animation_finished
	
	get_tree().change_scene_to_file("res://level/death_screen.tscn")

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
	query.exclude = [self]
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
