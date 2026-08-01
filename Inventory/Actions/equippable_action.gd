extends ActionData
class_name EquippableAction

@export var one_time_use: bool = true
@export var sucess_text: String = "Desbloqueado"

func _init() -> void:
	action_type = ActionType.EQUIPPABLE
