extends Node3D

const DEAD_GNOME = preload("res://scenes/dead_gnome.tscn")
@onready var boat = $"../boat"
@onready var final_score = $"../UI/final_score"

var dead_gnome_count: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.gnome_death.connect(func increase_count(): dead_gnome_count += 1)

	
func spawn_dead_gnomes():
	await get_tree().create_timer(1.5).timeout
	final_score.visible = true
	for i in range(dead_gnome_count):
		await get_tree().create_timer(max(0.001, 0.2 - i/500.0)).timeout
		var gnome = DEAD_GNOME.instantiate()
		gnome.position = Vector3(0.5, 1.5, (randi() % 3000) / 1000.0 - 1.9)
		gnome.scale = Vector3.ONE*0.15
		boat.add_child(gnome)
		final_score.text = "Gnomes flung:\n" + str(i+1)
	await get_tree().create_timer(2).timeout
	SignalBus.restart_game.emit()
