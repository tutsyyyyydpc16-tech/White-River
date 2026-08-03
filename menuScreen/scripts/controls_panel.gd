extends Panel

@onready var rows_container: VBoxContainer = $ScrollContainer/RowsContainer

const KEYBIND_ROW_SCENE := preload("res://stillImportant/keybind_row.tscn")

## Nome da ação (tem que bater com o Input Map) -> texto legível mostrado na tela
const ACTION_DISPLAY_NAMES := {
	"ui_up": "Move Forward",
	"ui_down": "Move Backward",
	"ui_left": "Move Left",
	"ui_right": "Move Right",
	"interact": "Interact",
	"flashlight": "Toggle Flashlight",
	"pause": "Pause",
	"inventory": "Inventory",
	"swap_item": "Swap Item",
	"aim": "Aim",
	"shoot": "Shoot",
	"push": "Push",
	"crouch": "Crouch",
	"jump": "Jump",
	"sprint": "Sprint",
	"primary": "Interact / Use",
	"secundary": "Alternate Interact",
	"lean_left": "Lean Left",
	"lean_right": "Lean Right",
	"quit": "Quit Game",
}

func _ready() -> void:
	for action_name in ACTION_DISPLAY_NAMES.keys():
		var row: HBoxContainer = KEYBIND_ROW_SCENE.instantiate()
		rows_container.add_child(row)
		row.setup(action_name, ACTION_DISPLAY_NAMES[action_name])
