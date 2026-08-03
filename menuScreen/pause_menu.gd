extends CanvasLayer

@onready var main_buttons = $MainButtons
@onready var settings_panel = $SettingsPanel
@onready var controls_panel = $ControlsPanel
@onready var pause_menu: CanvasLayer = %pause_menu

func _ready() -> void:
	# Reflete os valores já salvos/carregados nos controles da UI, pra não abrir
	# o menu mostrando os sliders na posição errada em relação ao que tá aplicado
	if settings_panel.has_node("MusicSlider"):
		settings_panel.get_node("MusicSlider").value = SettingsManager.music_volume
	if settings_panel.has_node("SoundSlider"):
		settings_panel.get_node("SoundSlider").value = SettingsManager.sound_volume
	if settings_panel.has_node("FullScreenBox"):
		settings_panel.get_node("FullScreenBox").button_pressed = SettingsManager.fullscreen
	if settings_panel.has_node("BrigthnessSlider"):
		settings_panel.get_node("BrigthnessSlider").value = SettingsManager.brightness
	if settings_panel.has_node("VhsCheckBox"):
		settings_panel.get_node("VhsCheckBox").button_pressed = SettingsManager.vhs_enabled
	if settings_panel.has_node("TaskCaptionCheckBox"):
		settings_panel.get_node("TaskCaptionCheckBox").button_pressed = SettingsManager.task_caption_enabled

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
	get_tree().change_scene_to_file("res://level/main_menu.tscn")

func _on_controls_pressed():
	controls_panel.visible = true
	main_buttons.visible = false

func _on_sound_slider_value_changed(value):
	SettingsManager.set_sound_volume(value)

func _on_music_slider_value_changed(value):
	SettingsManager.set_music_volume(value)

func _on_vhs_check_box_toggled(pressed):
	SettingsManager.set_vhs_enabled(pressed)

func _on_task_screen_box_toggled(pressed):
	SettingsManager.set_task_caption_enabled(pressed)

func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_quit_game_pressed() -> void:
	get_tree().quit()
