class_name Enemy extends Area3D

var in_range = false
var state: String
var direction: Vector3
var speed: float = 0.2
# current ship bounds apprx
const X_BOUNDS = [-0.5, 0.5]
const Y_BOUNDS = [-1, 1]
const INITIAL_Y = 0.26945611834526 # idk where this number comes from

var p0 = Vector3.ZERO
var p1 = Vector3.ZERO
var p2 = Vector3.ZERO

var time = 0
var hit = false

func _ready():
	SignalBus.released.connect(_calc_hit_trajectory)

func _on_area_entered(area):
	in_range = true
	set_mesh()

func _on_area_exited(area):
	in_range = false
	set_mesh()
	
func _calc_hit_trajectory(mouse_pos, power):
	if in_range:
		var diff = (mouse_pos - self.global_position)*Vector3(1,0,1) 
		
		# the ship is rotated 90deg in y axis so I'm hacking this together rather than changing it
		# this gets the distance between the base of the cone and the enemy to calc the vector the enemy trajectory should follow
		var rot = Vector3(diff.z, 0, -diff.x).normalized()
		p0 = self.position
		p1 = self.position + rot*power + Vector3(0,0.4,0)
		p2 = self.position + rot*power + Vector3(0,self.position.y, 0)
		
		if !in_bounds(p2):
			p2 *= Vector3(1,0,1)
		hit = true
	

func set_mesh():
	self.get_child(1).visible = !in_range
	self.get_child(2).visible = in_range

func bezier(t):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r

func launch(delta):
	self.position = bezier(time)
	time += delta
	
func wander(direction: Vector3):
	flip(direction)
	state = 'Wander'

func flip(direction: Vector3):
	self.direction = direction.rotated(Vector3.UP, randf_range(-PI/4, PI/4))
	
func _physics_process(delta):
	if hit:
		launch(delta)
		if in_bounds(p2) and self.position.y < INITIAL_Y:
			self.position.y = INITIAL_Y
			hit = false
			time = 0
		elif !in_bounds(p2) and self.position.y == 0:
			queue_free()
	if state == 'Wander' and !hit:
		self.position += direction * speed * delta
		
func in_bounds(pos):
	return pos.x > X_BOUNDS[0] and pos.x < X_BOUNDS[1] and pos.z > Y_BOUNDS[0] and pos.z < Y_BOUNDS[1]
		
func find_mid_point(mouse_pos, enemy_pos):
	var slope = (mouse_pos.z - enemy_pos.z) / (mouse_pos.x - enemy_pos.x)
	var y0 = mouse_pos.z
	var x0 = mouse_pos.x
	
	for xc in X_BOUNDS:
		var y1 = -1*slope*(x0 - xc) + y0
		var tmp = Vector3(xc, 1, y1)
		if y1 >= Y_BOUNDS[0] and y1 <= Y_BOUNDS[1] and tmp.distance_to(mouse_pos) > tmp.distance_to(enemy_pos):
			return tmp
	for yc in Y_BOUNDS:
		var x1 = ((y0 - yc) - slope*x0) / -slope
		var tmp = Vector3(x1, 1, yc)
		if x1 >= X_BOUNDS[0] and x1 <= X_BOUNDS[1] and tmp.distance_to(mouse_pos) > tmp.distance_to(enemy_pos):
			# for visual effects / camera angle
			if yc == -0.1:
				tmp -= Vector3(0,0,0.4)
			return tmp

	return Vector3.ZERO
	
