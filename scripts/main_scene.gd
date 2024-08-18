extends Node3D

@onready var main_camera: MainCamera = $"Main Camera"
@onready var spawner_manager: SpawnerManager = $"boat/Enemy Spawners"
@onready var start_enemy = $"boat/Start Enemy"

var game_state = 'Start'

func _ready():
	pass
	
func _process(delta):
	if game_state == 'Start':
		if start_enemy == null:
			main_camera.view_game()
			spawner_manager.restart()
			game_state = 'Play'
	elif game_state == 'Play':
		pass
		#if Input.is_action_just_pressed("Q"):
			#main_camera.view_start()
			#spawner_manager.stop()
			#game_state = 'Start'

