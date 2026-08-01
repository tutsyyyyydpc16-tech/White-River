extends Node3D

@export var player: CharacterBody3D
@export var anim: AnimationPlayer

func iniciar_cutscene():
	player.set_process(false)
	player.set_physics_process(false)

	anim.play
