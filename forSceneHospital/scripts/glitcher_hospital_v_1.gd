extends CharacterBody3D

var player = null

const SPEED = 4.0

@export var player_path : NodePath

@onready var anim = $AnimationPlayer
@onready var visual = $Corpo
@onready var nav_agent = $NavigationAgent3D

var update_timer := 0.0

func _ready():
	player = get_node(player_path)
	print(player)
	print(nav_agent)

func _physics_process(delta):

	if player == null:
		return

	update_timer -= delta

	if update_timer <= 0:
		update_timer = 0.2
		nav_agent.target_position = player.global_position

	#if nav_agent.is_navigation_finished():
		#return

	var distance = global_position.distance_to(player.global_position)

	if distance < 1.5:
		velocity = Vector3.ZERO
		update_animation()
		move_and_slide()
		return

	var next_nav_point = nav_agent.get_next_path_position()

	var direction = (next_nav_point - global_position)
	
	direction.y = 0
	
	direction = direction.normalized()
	print(next_nav_point)

	velocity = direction * SPEED

	var target = player.global_position
	target.y = visual.global_position.y

	visual.look_at(target, Vector3.UP)

	update_animation()

	move_and_slide()

func update_animation():

	if velocity.length() > 0.1:

		if anim.current_animation != "walk":
			anim.play("walk")

	else:

		if anim.current_animation != "idle":
			anim.play("idle")
			
func morrer():
	print("MORREU")
	queue_free()
