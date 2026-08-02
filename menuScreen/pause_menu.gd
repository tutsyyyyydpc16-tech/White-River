extends CanvasLayer

@onready var pause_menu: CanvasLayer = $"."
@onready var main_buttons = $MainButtons
@onready var settings_panel = $SettingsPanel
@onready var controls_panel = $ControlsPanel

func _ready() -> void:
	if settings_panel.has_node("MusicSlider"):
		settings_panel.get_node("MusicSlider").value = SettingsManager.music_volume
	if settings_panel.has_node("SoundSlider"):
		settings_panel.get_node("SoundSlider").value = SettingsManager.sound_volume
	if settings_panel.has_node("FullScreenBox"):
		settings_panel.get_node("FullScreenBox").button_pressed = SettingsManager.fullscreen
	if settings_panel.has_node("BrightnessSlider"):
		settings_panel.get_node("BrightnessSlider").value = SettingsManager.brightness
	if settings_panel.has_node("VhsCheckBox"):
		settings_panel.get_node("VhsCheckBox").button_pressed = SettingsManager.vhs_enabled
		
func resume_game():
	get_tree().paused = false
	pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_settings_pressed():
	settings_panel.visible = true
	main_buttons.visible = false

func _on_fog_check_box_toggled(pressed):
	var scene = get_tree().current_scene
	if scene.has_node("WorldEnvironment"):
		var env = scene.get_node("WorldEnvironment").environment
		if env:
			env.volumetric_fog_enabled = pressed

func _on_full_screen_box_toggled(pressed):
	SettingsManager.set_fullscreen(pressed)

func _on_brightness_slider_value_changed(value):
	SettingsManager.set_brightness(value)

func _on_back_button_pressed():
	settings_panel.visible = false
	controls_panel.visible = false
	main_buttons.visible = true

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menuScreen/main_menu.tscn")

func _on_controls_pressed():
	controls_panel.visible = true
	main_buttons.visible = false

func _on_sound_slider_value_changed(value):
	SettingsManager.set_sound_volume(value)

func _on_music_slider_value_changed(value):
	SettingsManager.set_music_volume(value)

func _on_vhs_check_box_toggled(pressed):
	SettingsManager.set_vhs_enabled(pressed)

func quit_game() -> void:
	get_tree().quit()
