extends Node3D

@export var keybind: String;
@export var deck: Node3D;
@onready var path_follow_3d = $Path3D/PathFollow3D
var stowaway = preload("res://stowaway.tscn")
var active_stowaway = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active_stowaway:
		if path_follow_3d.progress_ratio == 1:
			path_follow_3d.remove_child(active_stowaway)
			deck.add_child(active_stowaway)
			path_follow_3d.progress = 0
			active_stowaway = null
			
	elif Input.is_action_just_pressed(keybind):
		print('spawning enemy');
		active_stowaway = stowaway.instantiate()
		path_follow_3d.add_child(active_stowaway)

func _physics_process(delta):
	if path_follow_3d.get_child_count() > 0:
		const move_speed := 0.2
		path_follow_3d.progress += move_speed * delta
