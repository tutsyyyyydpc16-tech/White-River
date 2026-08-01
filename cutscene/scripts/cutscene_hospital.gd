extends Area3D

@onready var camera = $"../Camera3D"
@onready var animation = $"../AnimationPlayer"

var iniciou = false

func _on_body_entered(body):

	if iniciou:
		return

	if body.is_in_group("PlayerRua"):
		iniciou = true

		body.set_physics_process(false)

		camera.current = true

		animation.play("Cutscene_hospital")
		
		await animation.animation_finished
		
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Cutscene_hospital":
		get_tree().change_scene_to_file("res://level/hospital.tscn")
