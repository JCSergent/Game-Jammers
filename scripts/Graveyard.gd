extends Node3D

const DEAD_GNOME = preload("res://scenes/dead_gnome.tscn")

var dead_gnome_count: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.gnome_death.connect(func increase_count(): dead_gnome_count += 1)
	pass # Replace with function body.
	
func spawn_dead_gnomes():
	while dead_gnome_count > 0:
		var spawner = get_child(randi_range(0,get_child_count()-1))
		print(spawner)
		spawner.add_child(DEAD_GNOME.instantiate())
		dead_gnome_count -= 1
	
