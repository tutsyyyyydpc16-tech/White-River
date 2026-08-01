extends Area3D

@export var cena_destino = "res://level/hospital.tscn"

func interagir():
	get_tree().change_scene_to_file(cena_destino)
