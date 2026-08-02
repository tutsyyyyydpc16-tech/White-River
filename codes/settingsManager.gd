extends Node

## Autoload central de configurações. Guarda o estado atual de tudo que é
## configurável, salva/carrega num arquivo em disco, e sabe como aplicar
## cada configuração no jogo (áudio, tela cheia, brilho, shader VHS/CRT).

const SETTINGS_PATH := "user://settings.cfg"

var music_volume: float = 1.0
var sound_volume: float = 1.0
var fullscreen: bool = false
var brightness: float = 1.0
var vhs_enabled: bool = true

func _ready() -> void:
	load_settings()
	_apply_audio()
	_apply_fullscreen()

## Carrega as configurações salvas do disco. Se não existir arquivo ainda
## (primeira vez rodando o jogo), mantém os valores padrão definidos acima.
func load_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load(SETTINGS_PATH)
	if err != OK:
		return

	music_volume = config.get_value("audio", "music_volume", music_volume)
	sound_volume = config.get_value("audio", "sound_volume", sound_volume)
	fullscreen = config.get_value("display", "fullscreen", fullscreen)
	brightness = config.get_value("display", "brightness", brightness)
	vhs_enabled = config.get_value("display", "vhs_enabled", vhs_enabled)

## Salva as configurações atuais no disco
func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sound_volume", sound_volume)
	config.set_value("display", "fullscreen", fullscreen)
	config.set_value("display", "brightness", brightness)
	config.set_value("display", "vhs_enabled", vhs_enabled)
	config.save(SETTINGS_PATH)

func _apply_audio() -> void:
	var music_bus := AudioServer.get_bus_index("Music")
	if music_bus != -1:
		AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_volume))

	var sfx_bus := AudioServer.get_bus_index("SFX")
	if sfx_bus != -1:
		AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sound_volume))

func _apply_fullscreen() -> void:
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

## Aplica brilho + visibilidade do shader VHS/CRT na cena atualmente carregada.
## Chame isso sempre que uma cena nova terminar de carregar, e sempre que
## essas configurações mudarem enquanto o jogo já está rodando.
func apply_scene_settings() -> void:
	var scene := get_tree().current_scene
	if not scene:
		return

	if scene.has_node("WorldEnvironment"):
		var world_env: WorldEnvironment = scene.get_node("WorldEnvironment")
		if world_env.environment:
			world_env.environment.adjustment_enabled = true
			world_env.environment.adjustment_brightness = brightness

	for shader_node_name in ["CRT", "Barrel", "Pixel"]:
		var node := scene.find_child(shader_node_name, true, false)
		if node:
			node.visible = vhs_enabled

func set_music_volume(value: float) -> void:
	music_volume = value
	_apply_audio()
	save_settings()

func set_sound_volume(value: float) -> void:
	sound_volume = value
	_apply_audio()
	save_settings()

func set_fullscreen(value: bool) -> void:
	fullscreen = value
	_apply_fullscreen()
	save_settings()

func set_brightness(value: float) -> void:
	brightness = value
	apply_scene_settings()
	save_settings()

func set_vhs_enabled(value: bool) -> void:
	vhs_enabled = value
	apply_scene_settings()
	save_settings()
