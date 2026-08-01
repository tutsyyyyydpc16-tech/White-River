extends Control

@onready var audio = $AudioStreamPlayer

func go_to_menu():
	get_tree().change_scene_to_file("res://level/main_menu.tscn")
	
func _ready():
	audio.bus = "SFX"
	await get_tree().create_timer(5.0).timeout
	go_to_menu()
