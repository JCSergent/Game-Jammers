extends Node3D

@onready var music = $music
@onready var main_camera: MainCamera = $"Main Camera"
@onready var spawner_manager = $"boat/Enemy Spawners"
@onready var start_enemy = $"boat/Start Enemy"
@onready var zone = $"../impact_zone"
@onready var enemies = $boat/enemies
@export var play_music = false

var game_state = 'Start'

func _ready():
	if play_music:
		music.playing = true
	
func _process(delta):
	if game_state == 'Start':
		if start_enemy == null:
			main_camera.view_game()
			spawner_manager.restart()
			game_state = 'Play'
	elif game_state == 'Play':
		pass
	# speed up audio for more enemies
	music.pitch_scale = min(1.8, 1 + 0.025*int(enemies.get_child_count() / 5))
	if !music.playing and play_music:
		music.playing = true
		
		#if Input.is_action_just_pressed("Q"):
			#main_camera.view_start()
			#spawner_manager.stop()
			#game_state = 'Start'

