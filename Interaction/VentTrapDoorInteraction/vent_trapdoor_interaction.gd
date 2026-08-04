class_name VentTrapdoorInteraction
extends AbstractInteraction

"""
VentTrapdoorInteraction handles the vent trapdoor. It only opens once the
screws holding it shut have been loosened (Global.parafuso_solto). If the
player tries to interact before that, they get a hint message instead.
"""

## The AnimationPlayer that has the "open" animation for this trapdoor
@export var animation_player: AnimationPlayer

var is_open: bool = false

func interact() -> void:
	super()

	if not can_interact or is_open:
		return

	print("DEBUG trapdoor: parafuso_solto=", Global.parafuso_solto, " | animation_player=", animation_player)

	if Global.parafuso_solto:
		is_open = true
		can_interact = false
		if animation_player:
			animation_player.play("open")
			print("DEBUG trapdoor: animation.play chamado, current_animation=", animation_player.current_animation)
		else:
			print("DEBUG trapdoor: animation_player é null!")
	else:
		Global.mensagem = "There's locked"
