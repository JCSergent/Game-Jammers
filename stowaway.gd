class_name Stowaway extends Node3D

@export var actor: CharacterBody3D
@export var max_speed: float = 1.0
var state: String;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_state(new_state: String):
	print(new_state)
	if new_state == 'Wander':
		actor.velocity = Vector3.BACK.rotated(Vector3.BACK, randf_range(0, TAU)) * max_speed
		print(actor.velocity)
	state = new_state


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == 'Wander':
		pass
		
func _physics_process(delta):
	if state == 'Wander':
		var collision = actor.move_and_collide(actor.velocity * delta)
		if collision:
			var bounce_velocity = actor.velocity.bounce(collision.get_normal())
