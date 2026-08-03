extends HBoxContainer

@onready var action_label: Label = $ActionLabel
@onready var rebind_button: Button = $RebindButton

var action_name: String = ""
var listening: bool = false

func setup(action: String, display_name: String) -> void:
	action_name = action
	action_label.text = display_name
	_refresh_button_text()
	rebind_button.pressed.connect(_on_rebind_button_pressed)

func _refresh_button_text() -> void:
	var event: InputEventKey = SettingsManager.get_keybind(action_name)
	if event:
		var code: int = event.physical_keycode if event.physical_keycode != 0 else event.keycode
		rebind_button.text = OS.get_keycode_string(code)
	else:
		rebind_button.text = "Unbound"

func _on_rebind_button_pressed() -> void:
	listening = true
	rebind_button.text = "Press a key..."

## Usamos _unhandled_key_input (não _input) pra não interferir com outros
## sistemas de input do jogo enquanto não estamos escutando por um rebind
func _unhandled_key_input(event: InputEvent) -> void:
	if not listening:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		# ESC cancela o rebind sem trocar nada, em vez de virar a nova tecla
		if event.physical_keycode == KEY_ESCAPE:
			listening = false
			_refresh_button_text()
			get_viewport().set_input_as_handled()
			return

		SettingsManager.set_keybind(action_name, event)
		listening = false
		_refresh_button_text()
		get_viewport().set_input_as_handled()
