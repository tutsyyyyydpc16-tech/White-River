extends Area3D

@export var cena_destino = "res://level/cena_rua.tscn"

func _process(delta: float) -> void:
	if Global.cutscene:
		$CollisionShape3D.disabled = false
	else:
		$CollisionShape3D.disabled = true

func _on_body_entered(body):
		if body.is_in_group("player"):
			get_tree().change_scene_to_file(cena_destino)
