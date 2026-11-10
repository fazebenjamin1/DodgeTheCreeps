extends CanvasLayer
signal start_game

func _ready():
	# En single player només es veu el primer marcador.
	$ScoreLabel2.visible = (Global.num_players == 2)

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over(score1, score2):
	var text = "Game Over"
	if Global.num_players == 2:
		if score1 > score2:
			text += "\nP1 wins!"
		elif score2 > score1:
			text += "\nP2 wins!"
		else:
			text += "\nDraw!"
	show_message(text)
	# Espereu fins que el MessageTimer hagi acabat de comptar.
	yield($MessageTimer, "timeout")
	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	# Feu un temporitzador one-shot i espereu que acabi.
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()

func update_score1(score):
	$ScoreLabel1.text = str(score)

func update_score2(score):
	$ScoreLabel2.text = str(score)

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Message.hide()
