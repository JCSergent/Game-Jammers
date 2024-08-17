extends Node3D

@export var keybind: String
@export var new_parent: Node
@export var landing_point: Marker3D
@onready var path_follow_3d = $Path3D/PathFollow3D
var enemy = preload("res://scenes/enemy.tscn")
var active_enemy = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active_enemy:
		if path_follow_3d.progress_ratio == 1:
			path_follow_3d.remove_child(active_enemy)
			new_parent.add_child(active_enemy)
			active_enemy.global_position = landing_point.global_position
			#active_enemy.change_state('Wander')
			path_follow_3d.progress = 0
			active_enemy = null
	elif Input.is_action_just_pressed(keybind):
		print('spawning enemy');
		active_enemy = enemy.instantiate()
		path_follow_3d.add_child(active_enemy)

func _physics_process(delta):
	if path_follow_3d.get_child_count() > 0:
		const move_speed := 0.2
		path_follow_3d.progress += move_speed * delta
