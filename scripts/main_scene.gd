extends Node3D

@onready var music = $music
@onready var main_camera: MainCamera = $"Main Camera"
@onready var spawner_manager: SpawnerManager = $"boat/Enemy Spawners"
@onready var start_enemy: Enemy = $"boat/Start Enemy"

@onready var mesh_instance_3d = $UI/MeshInstance3D
@onready var mesh_instance_3d_3 = $UI/MeshInstance3D3
@onready var animation_player = $UI/AnimationPlayer
@onready var spawner_manager = $"boat/Enemy Spawners"
@onready var start_enemy = $"boat/Start Enemy"
@onready var enemies = $boat/enemies
@export var play_music = false

var game_state = 'Start'

func _ready():
	animation_player.play("start_game")
	if play_music:
		music.playing = true
	
func _process(delta):
	if game_state == 'Start':
		if Input.is_action_pressed("mouseclick"):
			mesh_instance_3d_3.visible = false
		else:
			mesh_instance_3d_3.visible = true
		if start_enemy == null:
			mesh_instance_3d_3.visible = false
			create_tween().tween_property(mesh_instance_3d, "transparency", 1.0, 0.5).from(0.0)
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

