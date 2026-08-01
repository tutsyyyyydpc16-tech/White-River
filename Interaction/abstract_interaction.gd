class_name AbstractInteraction
extends Node

"""
AbstractInteraction é a classe base para todos os objetos interativos do jogo.
Ela define a interface comum (preInteract, interact, auxInteract, postInteract)
e o estado compartilhado (can_interact, is_interacting, lock_camera, nodes_to_affect).
Tipos concretos de interação (por exemplo, portas, interruptores, notas, teclados numéricos) devem estender
esta classe e implementar seu próprio comportamento específico de interação, reutilizando
a lógica comum aqui fornecida.
"""

## Uma lista de nós que podem ser afetados pela interação com este objeto interativo. Os nós neste array devem ter um script próprio anexado,
## contendo um método "execute" que pode ser chamado utilizando o método `notify_nodes(percentage: float)` fornecido.
@export var nodes_to_affect: Array[Node]

## Uma referência ao nó que representa este objeto interativo. Muito provavelmente o nó StaticBody3D ou PhysicsBody3D.
var object_ref: Node3D

## Verdadeiro se o jogador tiver permissão para interagir com este objeto neste quadro específico; caso contrário, falso.
var can_interact: bool = true

## Verdadeiro se o jogador estiver interagindo com este objeto neste quadro; caso contrário, falso.
var is_interacting: bool = false

## Verdadeiro se a câmera deve ser travada para este tipo de interação; caso contrário, falso.
var lock_camera: bool = false


## Executa uma vez, após o nó e todos os seus filhos terem entrado na árvore de cena e estarem prontos
func _ready() -> void:
	object_ref = get_parent()

## Executado uma vez, quando o jogador clica pela PRIMEIRA vez em um objeto para interagir com ele
func pre_interact() -> void:
	is_interacting = true
	
## Executado a cada quadro enquanto o jogador interage com este objeto
func interact() -> void: return

## Interação alternativa usando o botão secundário
func aux_interact() -> void: return 
	
## Executado uma vez, quando o jogador interage pela última vez com um objeto
func post_interact() -> void:
	is_interacting = false
	lock_camera = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

## Itera sobre uma lista de nós com os quais é possível interagir e executa a respectiva lógica de cada um
func notify_nodes(percentage: float) -> void:
	for node in nodes_to_affect:
		if node and node.has_method("execute"):
			node.call("execute", percentage)
			
## Verdadeiro se o item for usado com sucesso, falso caso contrário. Classes filhas devem implementar a lógica.
func use_item(_item_data: ItemData) -> bool:
	return false
