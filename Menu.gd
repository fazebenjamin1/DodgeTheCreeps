extends Control

func _ready():
	var box = $CenterContainer/VBoxContainer
	box.get_node("SinglePlayerButton").connect("pressed", self, "_on_single_player")
	box.get_node("LocalMultiplayerButton").connect("pressed", self, "_on_local_multiplayer")
	box.get_node("OnlineMultiplayerButton").connect("pressed", self, "_go_to", ["res://OnlineMultiplayer.tscn"])
	box.get_node("SettingsButton").connect("pressed", self, "_go_to", ["res://Settings.tscn"])
	box.get_node("HighscoresButton").connect("pressed", self, "_go_to", ["res://Highscores.tscn"])
	box.get_node("AboutButton").connect("pressed", self, "_go_to", ["res://About.tscn"])
	box.get_node("SinglePlayerButton").grab_focus() # Permet navegar amb el teclat.

func _on_single_player():
	Global.num_players = 1
	get_tree().change_scene("res://Main.tscn")

func _on_local_multiplayer():
	Global.num_players = 2
	get_tree().change_scene("res://Main.tscn")

func _go_to(path):
	get_tree().change_scene(path)
