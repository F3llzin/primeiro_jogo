extends Node

@export var pipe_scene : PackedScene 

var game_running : bool
var game_over : bool
var scroll : int
var score : int
const Scroll_Speed = 4
var screen_size : Vector2i
var ground_heigth : int
var pipes : Array
const pipe_delay = 100
const pipe_range = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	ground_heigth = $chao.get_node("Sprite2D").texture.get_height()
	new_game()

func new_game():
	var _game_running = false
	var _game_over = false
	var _scroll = 0
	var _score = 0
	$score.text = "PONTOS: " + str(score)
	$gameover.hide()
	pipes.clear()
	generate_pipes()
	$Passaro.reset()
	
func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if $Passaro.voando:
						$Passaro.flap()
						check_top()

func start_game():
	game_running = true
	$Passaro.voando = true
	$Passaro.flap()
	$PipeTimer.start()

func _process(_delta):
	if game_running:
		scroll += Scroll_Speed
		#reseta scroll
		if scroll >= screen_size.x: 
			scroll = 0
		#mover node do chao
		$chao.position.x = -scroll
		for pipe in pipes:
			pipe.position.x -= Scroll_Speed


func _on_pipe_timer_timeout():
	generate_pipes()
	
func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + pipe_delay
	pipe.position.y = (screen_size.y - ground_heigth) / 2 + randi_range(-pipe_range, pipe_range)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)

func scored():
	score += 1
	$score.text = "PONTOS: " + str(score)

func check_top():
	if $Passaro.position.y < 0:
		$Passaro.caindo = true
		stop_game()

func stop_game():
	$PipeTimer.stop()
	$gameover.show()
	$Passaro.voando = false
	game_running = false
	game_over = true

func bird_hit():
	$Passaro.caindo = true
	stop_game()


func _on_chao_hit():
	$Passaro.caindo = false
	stop_game()


func _on_gameover_restart():
	get_tree().reload_current_scene()
	new_game()
