extends Control

onready var box = $CenterContainer/VBoxContainer
onready var volume_slider = box.get_node("VolumeSlider")
onready var volume_label = box.get_node("VolumeLabel")
onready var mute_check = box.get_node("MuteCheck")
onready var fullscreen_check = box.get_node("FullscreenCheck")
onready var difficulty_option = box.get_node("DifficultyOption")
onready var zen_check = box.get_node("ZenCheck")
onready var back_button = box.get_node("BackButton")

func _ready():
	# Primer posem els valors actuals i després connectem els senyals,
	# així no es dispara cap canvi en carregar la pantalla.
	volume_slider.value = Global.volume
	update_volume_label()
	mute_check.pressed = Global.muted
	fullscreen_check.pressed = Global.fullscreen
	difficulty_option.add_item("Easy")
	difficulty_option.add_item("Normal")
	difficulty_option.add_item("Hard")
	difficulty_option.select(Global.difficulty)
	zen_check.pressed = Global.zen_mode

	volume_slider.connect("value_changed", self, "_on_volume_changed")
	mute_check.connect("toggled", self, "_on_mute_toggled")
	fullscreen_check.connect("toggled", self, "_on_fullscreen_toggled")
	difficulty_option.connect("item_selected", self, "_on_difficulty_selected")
	zen_check.connect("toggled", self, "_on_zen_toggled")
	back_button.connect("pressed", self, "_back")
	back_button.grab_focus()

func update_volume_label():
	volume_label.text = "Volume: %d%%" % volume_slider.value

func _on_volume_changed(value):
	Global.volume = value
	update_volume_label()
	Global.apply_settings() # S'aplica en temps real.
	Global.save_settings()

func _on_mute_toggled(pressed):
	Global.muted = pressed
	Global.apply_settings()
	Global.save_settings()

func _on_fullscreen_toggled(pressed):
	Global.fullscreen = pressed
	Global.apply_settings()
	Global.save_settings()

func _on_difficulty_selected(index):
	Global.difficulty = index
	Global.save_settings()

func _on_zen_toggled(pressed):
	Global.zen_mode = pressed
	Global.save_settings()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_back()

func _back():
	get_tree().change_scene("res://Menu.tscn")
