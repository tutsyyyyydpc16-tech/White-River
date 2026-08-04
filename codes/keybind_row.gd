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
	var event: InputEvent = SettingsManager.get_keybind(action_name)
	if event is InputEventKey:
		var code: int = event.physical_keycode if event.physical_keycode != 0 else event.keycode
		rebind_button.text = OS.get_keycode_string(code)
	elif event is InputEventMouseButton:
		rebind_button.text = _mouse_button_to_text(event.button_index)
	else:
		rebind_button.text = "Unbound"

func _mouse_button_to_text(button_index: int) -> String:
	match button_index:
		MOUSE_BUTTON_LEFT:
			return "Mouse Left"
		MOUSE_BUTTON_RIGHT:
			return "Mouse Right"
		MOUSE_BUTTON_MIDDLE:
			return "Mouse Middle"
		MOUSE_BUTTON_WHEEL_UP:
			return "Wheel Up"
		MOUSE_BUTTON_WHEEL_DOWN:
			return "Wheel Down"
		_:
			return "Mouse %d" % button_index

func _on_rebind_button_pressed() -> void:
	listening = true
	rebind_button.text = "Press key/click..."

## Usamos _input (não _unhandled_key_input) pra capturar a tecla/clique ANTES do
## sistema de foco do próprio Godot "roubar" teclas como Tab pra navegar entre botões
func _input(event: InputEvent) -> void:
	if not listening:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		if event.physical_keycode == KEY_ESCAPE:
			listening = false
			_refresh_button_text()
			get_viewport().set_input_as_handled()
			return

		SettingsManager.set_keybind(action_name, event)
		listening = false
		_refresh_button_text()
		get_viewport().set_input_as_handled()

	elif event is InputEventMouseButton and event.pressed:
		SettingsManager.set_keybind(action_name, event)
		listening = false
		_refresh_button_text()
		get_viewport().set_input_as_handled()
