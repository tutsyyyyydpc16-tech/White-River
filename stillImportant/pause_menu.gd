extends CanvasLayer

@onready var main_buttons = $MainButtons
@onready var settings_panel = $SettingsPanel
@onready var controls_panel = $ControlsPanel
var brilho_atual = 1.0
	
func _ready():
	#var valor = $SettingsPanel/VolumeSlider.value
	#AudioServer.set_bus_volume_db(0, linear_to_db(valor))
	var env = get_env()
	if env:
		env.adjustment_enabled = true
		
func _on_settings_pressed():
	settings_panel.visible = true
	main_buttons.visible = false
	
func get_env():
	var scene = get_tree().current_scene
	if scene.has_node("WorldEnvironment"):
		return
	scene.get_node("WorldEnvironment").environment
	return null
		
func _on_fog_check_box_toggled(pressed):
	var env = get_env()
	if env:
		env.volumetric_fog_enabled = pressed
		
func _on_full_screen_box_toggled(pressed):
	if pressed:
		
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
			
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
func _on_brightness_slider_value_changed(value):
	brilho_atual = value
	var env = get_env()
	if env:
		env.adjustment_enabled = true
		env.adjustment_brightness = value
		
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
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	
func _on_music_slider_value_changed(value):
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
