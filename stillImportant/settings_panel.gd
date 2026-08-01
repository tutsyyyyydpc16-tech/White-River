extends Panel

@onready var main_buttons = $"../MainButtons"
@onready var settings_panel = $"../../SettingsPanel"

func _on_settings_pressed():
	settings_panel.visible = true
	main_buttons.visible = false
	
func _on_back_pressed():
	settings_panel.visible = false
	main_buttons.visible = true
