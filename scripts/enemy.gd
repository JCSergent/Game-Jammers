class_name Enemy extends Area3D

var in_range = false
var state: String
var direction: Vector3
var speed: float = 0.2

func _ready():
	SignalBus.released.connect(func(): if in_range: queue_free())

func _on_area_entered(area):
	in_range = true
	set_mesh()

func _on_area_exited(area):
	in_range = false
	set_mesh()

func set_mesh():
	self.get_child(1).visible = !in_range
	self.get_child(2).visible = in_range
	
func wander(direction: Vector3):
	flip(direction)
	state = 'Wander'

func flip(direction: Vector3):
	self.direction = direction.rotated(Vector3.UP, randf_range(-PI/4, PI/4))
	
func _physics_process(delta):
	if state == 'Wander':
		self.position += direction * speed * delta

