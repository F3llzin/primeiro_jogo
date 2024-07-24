extends CharacterBody2D

const gravity = 1000
const Max_vel = 600
const Flap_speed = -500
var voando = false 
var caindo = false
const Posicao_inicial = Vector2(100, 400)
# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func reset():
	caindo = false
	voando = false
	position = Posicao_inicial
	set_rotation(0)
	
func _physics_process(delta):
	if voando or caindo:
		velocity.y += gravity*delta
		
		if velocity.y > Max_vel:
			velocity.y = Max_vel
		if voando:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$AnimatedSprite2D.play()
		elif caindo:
			set_rotation(PI/2)
			$AnimatedSprite2D.stop()
		move_and_collide(velocity * delta)
	else:
		$AnimatedSprite2D.stop()

func flap():
	velocity.y = Flap_speed
