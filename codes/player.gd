extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var view = $Head
@onready var light = $Head/Camera3D/SpotLight3D
@onready var dialogue = $player_ui/CanvasLayer/DialoguePanel
@onready var dialogue2 = $player_ui/CanvasLayer/DialoguePanel2
@onready var push_ray = $Head/RayCast3D_contention
@onready var inventory_controller: Node = $InventoryController/CanvasLayer/InventoryUI
@onready var task = $player_contention_ui/task_ui
@onready var head = $Head
var ja_disparou = false
var ja_foi = false
var tem_arma = false

const PUSH_FORCE : float = 10.0
var pushable: Node3D = null
var is_pushing : bool = false
var rotation_direction : float

var crouch_height = 0.1
var stand_height = 2.0
var crouching = false
var stand_camera_y = 0.906
var crouch_camera_y = 0.2

func _ready():
	if has_node("../SpawnRua"):
		var spawn = get_node("../SpawnRua")
		global_transform.origin = spawn.global_transform.origin
	if Global.tem_lanterna:
		light.visible = true
		
func crouch(delta):
	if Input.is_action_just_pressed("crouch"):
		crouching = !crouching
		if crouching:
			$CollisionShape3D.shape.height = crouch_height
			$CollisionShape3D.shape.radius = 0.1
		else:
			$CollisionShape3D.shape.height = stand_height
			$CollisionShape3D.shape.radius = 0.5
			
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		inventory_controller.visible = true
		push_ray.enabled = false
	else:
		inventory_controller.visible = false
		push_ray.enabled = true
func _physics_process(delta: float) -> void:
	crouch(delta)
	handle_pushing(delta)
	if Global.tem_lanterna and Input.is_action_just_pressed("flashlight"):
		light.visible = !light.visible
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

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
		
	move_and_slide()
		
		
func _on_dialogue_trriger_body_entered(body: Node3D) -> void:
	if body == self and not ja_disparou:
		ja_disparou = true
		show_dialogue("Where am I?", 3)
		
func show_dialogue(text: String, duration: float) -> void:
	dialogue.visible = true
	dialogue.get_node("Label").text = text
	await get_tree().create_timer(duration).timeout
	dialogue.visible = false
	
func _on_dialogue_trriger_2_body_entered(body: Node3D) -> void:
	if body == self and not ja_foi:
		ja_foi = true
		show_dialogue("What the hell?", 3)
		
func show_dialogue2(text: String, duration: float) -> void:
	dialogue2.visible = true
	dialogue2.get_node("Label").text = text
	await get_tree().create_timer(duration).timeout
	dialogue2.visible = false
	
	
func push_obejct(dir: Vector3) -> void:
	var force = dir * PUSH_FORCE
	pushable.apply_central_force(force)
	
func check_pushable():
	push_ray.force_raycast_update()
	if push_ray.is_colliding():
		
		var obj = push_ray.get_collider()
		print(obj)
		
		if obj.is_in_group("pushable"):
			print("ACHOU PUSHABLE")
			pushable = obj
			is_pushing = true
			
func release_pushable():
	is_pushing = false
	pushable = null
	
func handle_pushing(delta):
	if not is_pushing or not pushable:
		return
		
	print("EMPURRANDO")
	
	var input_z = Input.get_axis("ui_up", "ui_down")
	var forward = -transform.basis.z
	var move : Vector3 = Vector3.ZERO
	
	if input_z:
		move = forward * (input_z * PUSH_FORCE * delta)
		
	move.y = 0.0
	
	#pushable.global_position += move
	#global_position += move
