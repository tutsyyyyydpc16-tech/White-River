extends Node3D

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var cutscene_camera: Camera3D = %Camera3D
@onready var player_seweger_i: CharacterBody3D = %PlayerSewegerI

func _ready() -> void:
	_start_cutscene()

func _start_cutscene() -> void:
	_lock_player(true)
	cutscene_camera.current = true
	animation_player.play("seweger")
	
	if not animation_player.animation_finished.is_connected(_on_cutscene_finished):
		animation_player.animation_finished.connect(_on_cutscene_finished)

func _on_cutscene_finished(_anim_name: StringName) -> void:
	_lock_player(false)
	animation_player.animation_finished.disconnect(_on_cutscene_finished)

func _lock_player(locked: bool) -> void:
	if player_seweger_i == null:
		push_warning("Cutscene: %PlayerSewegerI não encontrado na cena.")
		return
	
	player_seweger_i.set_physics_process(!locked)
	player_seweger_i.set_process_input(!locked)
	player_seweger_i.visible = !locked
	
	if not locked:
		var player_camera: Camera3D = player_seweger_i.get_node("Head/Eyes/Camera3D")
		if player_camera:
			player_camera.current = true
