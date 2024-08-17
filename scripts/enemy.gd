extends Area3D

@onready var camera = $"../../Camera3D"

var in_range = false

func _ready():
	camera.released.connect(func(): if in_range: queue_free())

func _on_area_entered(area):
	in_range = true
	set_mesh()

func _on_area_exited(area):
	in_range = false
	set_mesh()

func set_mesh():
	self.get_child(1).visible = !in_range
	self.get_child(2).visible = in_range
	

