extends Area3D

@export var direction: Vector3

func _on_area_entered(area):
	if area.flip:
		area.flip(direction)
