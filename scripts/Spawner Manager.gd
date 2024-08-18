extends Node3D

var timer: float = 0.0;
var max_time: float = 1200;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta;
	
	for child in get_children():
		if randf_range(0, max_time - min(timer, max_time-1)) <= 10:
			child.spawn_enemy()



