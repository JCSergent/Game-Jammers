class_name EnemySpawner extends Node3D

@export var keybind: String
@export var new_parent: Node
@export var landing_point: Marker3D
@export var landing_point2: Marker3D
@onready var path_follow_3d = $Path3D/PathFollow3D
var enemy = preload("res://scenes/enemy.tscn")
var active_enemy: Enemy = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed(keybind):
		spawn_enemy()
	if active_enemy:
		if path_follow_3d.progress_ratio == 1:
			path_follow_3d.remove_child(active_enemy)
			new_parent.add_child(active_enemy)
			active_enemy.global_position = landing_point.global_position
			var forward = landing_point2.global_position - landing_point.global_position
			active_enemy.wander(forward.normalized())
			path_follow_3d.progress = 0
			active_enemy = null

func _physics_process(delta):
	if active_enemy:
		const move_speed := 0.2
		path_follow_3d.progress += move_speed * delta
		
func spawn_enemy():
	if active_enemy == null:
		active_enemy = enemy.instantiate()
		path_follow_3d.add_child(active_enemy)
