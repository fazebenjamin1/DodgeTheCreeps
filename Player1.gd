extends Area2D
signal hit
export var speed = 400 # A quina velocitat es mourà el jugador (píxels/seg).
export var player_id = 1 # 1 = fletxes, 2 = WASD
var screen_size # Mida de la finestra de joc.

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2.ZERO # Vector de moviment del jugador.
	if Input.is_action_pressed("p%d_right" % player_id):
		velocity.x += 1
	if Input.is_action_pressed("p%d_left" % player_id):
		velocity.x -= 1
	if Input.is_action_pressed("p%d_down" % player_id):
		velocity.y += 1
	if Input.is_action_pressed("p%d_up" % player_id):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(body):
	disable() # El jugador desapareix després de ser impactat.
	emit_signal("hit")

func disable():
	hide()
	set_process(false)
	# S'ha d'ajornar, ja que no podem canviar les propietats físiques en una crida de retorn de física.
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	set_process(true)
	$CollisionShape2D.disabled = false

func _on_Player_hit():
	pass # Aquesta connexió ve de Player.tscn, la deixem.
