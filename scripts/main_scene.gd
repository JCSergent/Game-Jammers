extends Node3D

@onready var music = $music
@onready var main_camera: MainCamera = $"Main Camera"
@onready var spawner_manager = $"boat/Enemy Spawners"
@onready var start_enemy: Enemy = $"boat/Start Enemy"
@onready var ship_top = $"boat/Ship Top"
@onready var boat = $boat
@onready var graveyard = $Graveyard

@onready var mesh_instance_3d = $UI/MeshInstance3D
@onready var mesh_instance_3d_3 = $UI/MeshInstance3D3
@onready var animation_player = $UI/AnimationPlayer
@onready var enemies = $boat/enemies
@export var play_music = false

const ENEMY = preload("res://scenes/enemy.tscn")
var game_state =  'Start'
var init_state = false

func _ready():
	print(start_enemy.global_position)
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
		music.pitch_scale = min(1.8, 1 + 0.025*int(enemies.get_child_count() / 5))
		if !music.playing and play_music:
			music.playing = true
		if ship_top.global_position.y < 0:
			spawner_manager.stop()
			for child in enemies.get_children():
				child.queue_free()
			main_camera.view_start()
			#graveyard.spawn_dead_gnomes()
			game_state = 'End'
			init_state = true
	elif game_state == 'End':
		if init_state:
			get_tree().create_timer(2).timeout.connect(func reset():
				mesh_instance_3d_3.visible = true
				create_tween().tween_property(mesh_instance_3d, "transparency", 0.0, 0.5).from(1.0)
				start_enemy = ENEMY.instantiate()
				start_enemy.starter = true
				boat.add_child(start_enemy)
				start_enemy.global_position = Vector3(-0.312661, 0.660876, .612377)
				start_enemy.scale = Vector3(0.1,0.1,0.1)
				game_state = 'Start'
			)
			init_state = false


