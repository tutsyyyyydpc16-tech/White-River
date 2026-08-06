class_name VentTrapdoorInteraction
extends AbstractInteraction

"""
VentTrapdoorInteraction handles the vent trapdoor. It only opens once the
screws holding it shut have been loosened (Global.parafuso_solto). If the
player tries to interact before that, they get a hint message instead.
"""

var animation_player: AnimationPlayer
var is_open: bool = false

func _ready() -> void:
	super()
	# Busca o AnimationPlayer manualmente (irmão desse node, filho do Trapdoor)
	animation_player = get_parent().get_node("AnimationPlayer")

func interact() -> void:
	super()

	if not can_interact or is_open:
		return

	if Global.parafuso_solto:
		is_open = true
		can_interact = false
		if animation_player:
			animation_player.play("open")

		# A caixa de colisão fixa (usada só pra detectar o clique de interação)
		# não se move com a animação da porta, então continua bloqueando a
		# passagem física mesmo depois de "aberta". Desativa ela pra deixar
		# o player passar.
		var fixed_collision := get_parent().get_node_or_null("CollisionShape3D")
		if fixed_collision:
			fixed_collision.disabled = true
	else:
		Global.mensagem = "There's locked"
