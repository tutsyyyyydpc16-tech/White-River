extends CharacterBody3D

@export var patrol_destinations: Array[Node3D]
@onready var player = get_tree().current_scene.get_node("player_hospital")
@onready var rng = RandomNumberGenerator.new()

var speed = 3.0
var destination
var chasing = false
var destination_value

var chase_timer = 0.0

func _ready() -> void:
	pick_destination()
	
func _process(delta: float) -> void:
	if !chasing:
		if speed != 3.0:
			speed = 3.0
	if chasing:
		if speed != 5.0:
			speed = 5.0
		if chase_timer < 15.0:
			chase_timer += 1 * delta
		else:
			chase_timer = 0
			chasing = false
			pick_destination()
	if destination != null:
		var look_dir = lerp_angle(deg_to_rad(global_rotation_degrees.y), atan2(-velocity.x, -velocity.z), 0.5)
		global_rotation_degrees.y = rad_to_deg(look_dir)
		update_target_location()
		
func chase_player(ChaseCast: RayCast3D):
	if ChaseCast.is_colliding():
		var hit = ChaseCast.get_collider()
		if hit.name == "player_hospital":
			if !chasing:
				chasing = true
				destination = player
		
func _physics_process(delta: float) -> void:
	chase_player($ChaseCast)
	chase_player($ChaseCast2)
	chase_player($ChaseCast3)
	chase_player($ChaseCast4)
	chase_player($ChaseCast5)
	if not is_on_floor():
		velocity += get_gravity() * delta
	if destination != null:
		var current_location = global_transform.origin
		var next_location = $NavigationAgent3D.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * speed
		#velocity = velocity.move_toward(new_velocity, 0.25)
		#move_and_slide()

func pick_destination(dont_choose = null):
	if !chasing:
		var num = rng.randi_range(0, patrol_destinations.size() - 1)
		destination_value = num
		destination = patrol_destinations[num]
		if destination != null and dont_choose != null and destination == patrol_destinations[dont_choose]:
			if dont_choose < 1:
				destination = patrol_destinations[dont_choose + 1]
			if dont_choose > 0 and dont_choose <= patrol_destinations.size() - 1:
				destination = patrol_destinations[dont_choose - 1]
	
func update_target_location():
	$NavigationAgent3D.target_position = destination.global_transform.origin
	
func compute_velocity(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()
