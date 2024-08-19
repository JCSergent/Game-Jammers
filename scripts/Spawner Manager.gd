class_name SpawnerManager extends Node3D

var timer: float = 0.0;
var max_time: float = 1200;
var active = false;
var group_increase_rate: int = 10;

var start_delay: int = 4

func _process(delta):
	if active:
		timer += delta;
		
		for child in get_children():
			if child.group * group_increase_rate - group_increase_rate - timer <= 0:
				child.spawn_enemy(max(start_delay - timer/60,0))

func restart():
	timer = 0
	active = true

func stop():
	active = false
	for child in get_children():
		child.stop()
		
