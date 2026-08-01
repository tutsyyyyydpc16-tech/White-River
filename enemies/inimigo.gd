extends CharacterBody3D

@export var speed = 3.0
var vida = 3

@onready var player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):

	if player:
		var direction = (player.global_transform.origin - global_transform.origin).normalized()

		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

		look_at(player.global_transform.origin)

	move_and_slide()

func morrer():
	print("MORREU")
	queue_free()
