extends Node

const SAVE_PATH = "user://settings.cfg"

var num_players = 1

# Ajustos (valors per defecte)
var volume = 100.0 # 0-100 %
var muted = false
var fullscreen = false
var difficulty = 1 # 0 = Easy, 1 = Normal, 2 = Hard
var zen_mode = false

# Segons la dificultat: multiplicador de velocitat i temps entre creeps.
var mob_speed_mult = [0.75, 1.0, 1.4]
var mob_wait_time = [0.8, 0.5, 0.3]

func _ready():
	load_settings()
	apply_settings()

func apply_settings():
	var master = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master, muted)
	if volume <= 0:
		AudioServer.set_bus_volume_db(master, -80.0)
	else:
		AudioServer.set_bus_volume_db(master, linear2db(volume / 100.0))
	OS.window_fullscreen = fullscreen

func save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "volume", volume)
	config.set_value("audio", "muted", muted)
	config.set_value("video", "fullscreen", fullscreen)
	config.set_value("game", "difficulty", difficulty)
	config.set_value("game", "zen_mode", zen_mode)
	config.save(SAVE_PATH)

func load_settings():
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return # Primera execució: ens quedem amb els valors per defecte.
	volume = config.get_value("audio", "volume", 100.0)
	muted = config.get_value("audio", "muted", false)
	fullscreen = config.get_value("video", "fullscreen", false)
	difficulty = config.get_value("game", "difficulty", 1)
	zen_mode = config.get_value("game", "zen_mode", false)
