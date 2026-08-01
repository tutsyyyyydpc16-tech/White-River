extends Node3D

@onready var world = $WorldEnvironment

var env_claro = preload("res://Env/ambiente_claro.tres")
var env_escuro = preload("res://Env/ambiente_escuro.tres")

var ativado = false

func _process(delta: float) -> void:
	if Global.modo_terror and not ativado:
		ativado = true
		world.environment = env_escuro
		get_tree().current_scene.get_node("Inimigo").process_mode = Node.PROCESS_MODE_INHERIT
		get_tree().current_scene.get_node("Inimigo").visible = true
		apagar_luzes()
		
func apagar_luzes():
	
	for obj in get_tree().get_nodes_in_group("lampadas"):
		if obj is OmniLight3D:
			obj.light_energy = 0
			
		if obj is MeshInstance3D:
			var material = obj.get_active_material(0)
			
			if material:
				material = material.duplicate()
				obj.set_surface_override_material(0, material)
				material.emission_enabled = false
				material.emission = Color.BLACK
				material.albedo_color = Color(0.1, 0.1, 0.1)
