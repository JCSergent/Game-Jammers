class_name SpawnerManager extends Node3D

var timer: float = 0.0;
var max_time: float = 1200;
var active = false;

func _process(delta):
	if active:
		timer += delta;
		
		for child in get_children():
			if randf_range(0, max_time - min(timer, max_time-1)) <= 1:
				child.spawn_enemy()

func restart():
	timer = 0
	active = true

func stop():
	active = false
