extends Node3D

func _process(delta):
	self.position.y -= delta

	if self.position.y < 0:
		queue_free()
