extends Node
export(PackedScene) var mob_scene
var score1 = 0
var score2 = 0
var alive1 = true
var alive2 = true

func _ready():
	randomize()
	$Player1.connect("hit", self, "_on_Player1_hit")
	$Player2.connect("hit", self, "_on_Player2_hit")
	new_game()

func _on_MobTimer_timeout():
	# Crea una nova instància de l'escena Mob.
	var mob = mob_scene.instance()
	# Trieu una ubicació aleatòria a Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	# Estableix la direcció de la multitud perpendicular a la direcció del camí.
	var direction = mob_spawn_location.rotation + PI / 2
	# Estableix la posició de la multitud a una ubicació aleatòria.
	mob.position = mob_spawn_location.position
	# Afegeix una mica d'aleatorietat a la direcció.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Tria la velocitat de la multitud.
	var velocity = Vector2(rand_range(150.0, 250.0) * Global.mob_speed_mult[Global.difficulty], 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	# Va fer que la multitud s'afegís a l'escena principal.
	add_child(mob)

func _on_Player1_hit():
	alive1 = false
	check_game_over()

func _on_Player2_hit():
	alive2 = false
	check_game_over()

func check_game_over():
	# La partida acaba quan han mort tots dos.
	if not alive1 and not alive2:
		game_over()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	get_tree().call_group("mobs", "queue_free")
	$Music.stop()
	$DeathSound.play()
	$HUD.show_game_over(score1, score2)

func new_game():
	score1 = 0
	score2 = 0
	alive1 = true
	alive2 = (Global.num_players == 2)
	$Player1.start($StartPosition1.position)
	if Global.num_players == 2:
		$Player2.start($StartPosition2.position)
	else:
		$Player2.disable() # Mode single player: el segon jugador no existeix.
	if Global.zen_mode:
		# Mode Zen: sense col·lisions, ningú pot morir.
		$Player1/CollisionShape2D.set_deferred("disabled", true)
		$Player2/CollisionShape2D.set_deferred("disabled", true)
	$MobTimer.wait_time = Global.mob_wait_time[Global.difficulty]
	$StartTimer.start()
	$HUD.update_score1(score1)
	$HUD.update_score2(score2)
	if Global.zen_mode:
		$HUD.show_message("Zen mode")
	else:
		$HUD.show_message("Get Ready")
	$Music.play()

func _input(event):
	# Escape torna al menú.
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://Menu.tscn")

func _on_ScoreTimer_timeout():
	if Global.zen_mode:
		return # Mode Zen: no hi ha puntuació.
	# Cada jugador només suma mentre està viu.
	if alive1:
		score1 += 1
		$HUD.update_score1(score1)
	if alive2:
		score2 += 1
		$HUD.update_score2(score2)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
