extends Node

## Faz a chave piscar — tanto a emissão do material quanto uma luz pequena
## ao redor dela — pra ficar visível mesmo em ambientes bem escuros.

@export var blink_speed: float = 2.0
@export var max_light_energy: float = 2.5
@export var max_emission_energy: float = 3.0

@onready var mesh: MeshInstance3D = get_parent().get_node("KeyMeshInstance3D")
@onready var light: OmniLight3D = get_parent().get_node("KeyBlinkLight")

var material: StandardMaterial3D
var time_elapsed: float = 0.0

func _ready() -> void:
	# Duplica o material pra não afetar outras instâncias da chave que existam
	material = mesh.get_surface_override_material(0).duplicate()
	mesh.set_surface_override_material(0, material)

func _process(delta: float) -> void:
	time_elapsed += delta
	# Pulso suave (0 a 1) usando seno, em vez de liga/desliga abrupto
	var pulse: float = (sin(time_elapsed * blink_speed) + 1.0) / 2.0
	
	material.emission_energy_multiplier = pulse * max_emission_energy
	light.light_energy = pulse * max_light_energy
