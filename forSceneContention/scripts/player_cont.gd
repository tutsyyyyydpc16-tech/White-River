extends CharacterBody3D

@onready var head: Node3D = $Head
@onready var eyes: Node3D = $Head/Eyes
@onready var camera_3d: Camera3D = $Head/Eyes/Camera3D
@onready var standing_collision_shape: CollisionShape3D = $StandingCollisionShape
@onready var crouching_collision_shape: CollisionShape3D = $CrouchingCollisionShape
@onready var stand_up_check: RayCast3D = $StandUpCheck
@onready var interaction_controller: Node = %InteractionController
@onready var footsteps_se: AudioStreamPlayer3D = %Footsteps
@onready var jump_se: AudioStreamPlayer3D = %Jump
@onready var note_camera: Camera3D = %NoteCamera
@onready var flashlight: StaticBody3D = %Flashlight

#Nota variáveis
@onready var note_hand: Marker3D = %NoteHand
var note_sway_amount: float = 0.1

#Variaveis de Movimentos
const walking_speed: float = 3.0
const sprinting_speed: float = 5.0
const crouching_speed: float = 1.0
var current_speed: float = 3.0
var moving: bool = false
var input_dir: Vector2 = Vector2.ZERO
var direction: Vector3 = Vector3.ZERO
const crouching_depth: float = 0.7
const jump_velocity: float = 4.0
var lerp_speed: float = 10.0
var mouse_input: Vector2
var is_in_air: bool = false

#Configurações do Player
var base_fov: float = 90.0

#Configurações de sensividade
var normal_sensitivity: float = 0.2
var current_sensitivity: float = normal_sensitivity
var sensitivity_restore_speed: float = 5.0
var sensitivity_facing_in: bool = false

#Estados da Máquina
enum PlayerState {
	IDLE_STAND,
	IDLE_CROUCH,
	CROUCHING,
	WALKING,
	SPRINTING,
	AIR
}
var player_state: PlayerState = PlayerState.IDLE_STAND

#HeadBobbing Variáveis
const head_bobbing_sprinting_speed: float = 22.0
const head_bobbing_walking_speed: float = 14.0
const head_bobbing_crouching_speed: float = 10.0
const head_bobbing_sprinting_intensity: float = 0.2
const head_bobbing_walking_intensity: float = 0.1
const head_bobbing_crouching_intensity: float = 0.05
var head_bobbing_current_intesity: float = 0.0
var head_bobbing_vector: Vector2 = Vector2.ZERO
var head_bobbing_index: float = 0.0
var last_bob_position_x: float = 0.0
var last_bob_direction: int = 0

#Espiar Variáveis
var lean_angle: float = 12.0               
var lean_offset: float = 0.25               
var lean_speed: float = 8.0                
var target_lean: float = 0.0                        
var current_lean: float = 0.0

#Inventário Variáveis
@onready var inventory_controller: InventoryController = $InventoryController/CanvasLayer/InventoryUI
@onready var interaction_raycast: RayCast3D = %InteractionRayCast
var inventory_opened_flag: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	var deco_collision = flashlight.find_child("CollisionShape3D", true, false)
	if deco_collision:
		deco_collision.disabled = true
		
func _input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("quit"):
		#get_tree().quit()
		
	if Input.is_action_pressed("lean_left"):
		target_lean = -1.0
	elif Input.is_action_pressed("lean_right"):
		target_lean = 1.0
	else:
		target_lean = 0.0
		
	if Input.is_action_just_pressed("inventory"):
		# If the player was interacting with something, end that interaction
		if interaction_controller.interaction_component != null:
			interaction_controller.interaction_component.post_interact()
		# If the inventory is open show the cursor, inventory panel, and block all other interaction
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		inventory_controller.visible = true
		interaction_raycast.enabled = false
		inventory_opened_flag = true
	elif Input.is_action_pressed("inventory"):
		return # no-op
	elif Input.is_action_just_released("inventory"):
		# If the inventory is closed
		inventory_controller.visible = false
		interaction_raycast.enabled = true
		if not interaction_controller.current_object:
			# Special check for interactable objects that still show the mouse (wheels)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	else:
		# Camera movement via mouse
		if event is InputEventMouseMotion:
			if current_sensitivity > 0.01 and not interaction_controller.isCameraLocked():
				mouse_input = event.relative
				rotate_y(deg_to_rad(-mouse_input.x * current_sensitivity))
				head.rotate_x(deg_to_rad(-mouse_input.y * current_sensitivity))
				head.rotation.x = clamp(head.rotation.x, deg_to_rad(-85), deg_to_rad(85))
	
func _physics_process(delta: float) -> void:
	
	updatePlayerState()
	updateCamera(delta)
	
	#Caindo
	if not is_on_floor():
		is_in_air
		if velocity.y >= 0:
			velocity += get_gravity() * delta
		else:
			velocity += get_gravity() * delta * 2.0
	else: #Pulando
		if is_in_air == true:
			is_in_air = false
			footsteps_se.play()
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
			jump_se.pitch_scale = randf_range(1.12, 1.22)
			jump_se.play()
			
			
	#Movimento Lógico
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)). normalized(), delta * 10.0)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
		
	move_and_slide()
	note_tilt_and_sway(input_dir, delta)
	
func _process(delta: float) -> void:
	if inventory_opened_flag and !Input.is_action_pressed("inventory"):
		inventory_controller.visible = false
		inventory_controller.context_menu.visible = false
		interaction_raycast.enabled = true
		if not interaction_controller.current_object:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if sensitivity_facing_in:
		current_sensitivity = lerp(current_sensitivity, normal_sensitivity, delta * sensitivity_restore_speed)
		
		if abs(current_sensitivity - normal_sensitivity) < 0.01:
			current_sensitivity - normal_sensitivity
			sensitivity_facing_in = false
			
	set_camera_locked(interaction_controller.isCameraLocked())

func updatePlayerState() -> void:
	moving = (input_dir != Vector2.ZERO)
	
	if not is_on_floor():
		player_state = PlayerState.AIR
	else:
		if Input.is_action_pressed("crouch"):
			if not moving:
				player_state = PlayerState.IDLE_CROUCH
			else:
				player_state = PlayerState.CROUCHING
		elif !stand_up_check.is_colliding():
			if not moving:
				player_state = PlayerState.IDLE_STAND
			elif Input.is_action_pressed("sprint"):
				player_state = PlayerState.SPRINTING
			else:
				player_state = PlayerState.WALKING
			
	updatePlayerColShape(player_state)
	updatePlayerSpeed(player_state)
	
func updatePlayerColShape(_player_state: PlayerState) -> void:
	if _player_state == PlayerState.CROUCHING or _player_state == PlayerState.IDLE_CROUCH:
		standing_collision_shape.disabled = true
		crouching_collision_shape.disabled = false
	else:
		standing_collision_shape.disabled = false
		crouching_collision_shape.disabled = true
	
func updatePlayerSpeed(_player_state: PlayerState) -> void:
	if _player_state == PlayerState.CROUCHING or _player_state == PlayerState.IDLE_CROUCH:
		current_speed = crouching_speed
	elif _player_state == PlayerState.WALKING:
		current_speed = walking_speed
	elif _player_state == PlayerState.SPRINTING:
		current_speed = sprinting_speed
		
	
func updateCamera(delta: float) -> void:
	if player_state == PlayerState.AIR:
		pass
		
	if player_state == PlayerState.CROUCHING or player_state == PlayerState.IDLE_CROUCH:
		head.position.y = lerp(head.position.y, 1.8 * crouching_depth, delta * lerp_speed)
		camera_3d.fov = lerp(camera_3d.fov, base_fov * 0.95, delta * lerp_speed)
		head_bobbing_current_intesity = head_bobbing_crouching_intensity
		head_bobbing_index += head_bobbing_crouching_speed * delta
	elif player_state == PlayerState.IDLE_STAND:
		head.position.y = lerp(head.position.y, 1.8, delta * lerp_speed)
		camera_3d.fov = lerp(camera_3d.fov, base_fov, delta * lerp_speed)
		head_bobbing_current_intesity = head_bobbing_walking_intensity
		head_bobbing_index += head_bobbing_walking_speed * delta
	elif player_state == PlayerState.WALKING:
		head.position.y = lerp(head.position.y, 1.8, delta * lerp_speed)
		camera_3d.fov = lerp(camera_3d.fov, base_fov, delta * lerp_speed)
		head_bobbing_current_intesity = head_bobbing_walking_intensity
		head_bobbing_index += head_bobbing_walking_speed * delta
	elif player_state == PlayerState.SPRINTING:
		head.position.y = lerp(head.position.y, 1.8, delta * lerp_speed)
		camera_3d.fov = lerp(camera_3d.fov, base_fov * 1.05, delta * lerp_speed)
		head_bobbing_current_intesity = head_bobbing_sprinting_intensity
		head_bobbing_index += head_bobbing_sprinting_speed * delta
	
	head_bobbing_vector.y = sin(head_bobbing_index)
	head_bobbing_vector.x = (sin(head_bobbing_index / 2.0) * 0.5)
	if moving:
		eyes.position.y = lerp(eyes.position.y, head_bobbing_vector.y * (head_bobbing_current_intesity / 2.0), delta * lerp_speed)
		eyes.position.x = lerp(eyes.position.x, head_bobbing_vector.x * (head_bobbing_current_intesity), delta * lerp_speed)
	else:
		eyes.position.y = lerp(eyes.position.y, 0.0, delta * lerp_speed)
		eyes.position.x = lerp(eyes.position.x, 0.0, delta * lerp_speed)
		
	current_lean = lerp(current_lean, target_lean, delta * lean_speed)
	
	var target_tilt: float = deg_to_rad(-lean_angle) * current_lean
	var target_offset: float = lean_offset * current_lean
	
	camera_3d.rotation.z = lerp(camera_3d.rotation.z, target_tilt, delta * lean_speed)
	camera_3d.position.x = lerp(camera_3d.position.x, target_offset, delta * lean_speed)
	
	note_camera.fov = camera_3d.fov
	
	play_footsteps()
	
func set_camera_locked(locked: bool) -> void:
	if locked:
		current_sensitivity = 0.0
		sensitivity_facing_in = false
	else:
		sensitivity_facing_in = true
	
func note_tilt_and_sway(input_dir: Vector2, delta: float) -> void:
	if note_hand:
		note_hand.rotation.x = lerp(note_hand.rotation.x, -input_dir.y * note_sway_amount, 10 * delta)
		note_hand.rotation.z = lerp(note_hand.rotation.z, -input_dir.x * note_sway_amount, 10 * delta)
	
func play_footsteps() -> void:
	if moving and is_on_floor():
		var bob_position_x = head_bobbing_vector.x
		var bob_direction = sign(bob_position_x - last_bob_position_x)
	
		if bob_direction != 0 and bob_direction != last_bob_direction and last_bob_direction != 0:
			footsteps_se.play()
			
		last_bob_direction = bob_direction
		last_bob_position_x = bob_position_x
	else:
		last_bob_direction = 0
		last_bob_position_x = head_bobbing_vector.x
