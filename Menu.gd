extends Control

func _ready():
	var box = $CenterContainer/VBoxContainer
	box.get_node("SinglePlayerButton").connect("pressed", self, "_on_single_player")
	box.get_node("LocalMultiplayerButton").connect("pressed", self, "_on_local_multiplayer")
	box.get_node("SettingsButton").connect("pressed", self, "_on_settings")
	# De moment, les opcions sense implementar queden desactivades.
	for name in ["OnlineMultiplayerButton", "HighscoresButton", "AboutButton"]:
		box.get_node(name).disabled = true
	box.get_node("SinglePlayerButton").grab_focus()

func _on_single_player():
	Global.num_players = 1
	get_tree().change_scene("res://Main.tscn")

func _on_local_multiplayer():
	Global.num_players = 2
	get_tree().change_scene("res://Main.tscn")

func _on_settings():
	get_tree().change_scene("res://Settings.tscn")
