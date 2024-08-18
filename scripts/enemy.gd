class_name Enemy extends Area3D

@onready var animation_player = $AnimationPlayer
@onready var animated_sprite_3d = $AnimatedSprite3D

@export var start_wander: bool
var state: String
var direction: Vector3
var speed: float = 0.2
# current ship bounds apprx
const X_BOUNDS = [-1, 1]
const Y_BOUNDS = [-0.1, 0.86]

var p0 = Vector3.ZERO
var p1 = Vector3.ZERO
var p2 = Vector3.ZERO

var time = 0
var in_range = false
var hit = false

func _ready():
	if start_wander:
		wander(Vector3.FORWARD)
	else:
		animation_player.play('gnome_climbing')
	SignalBus.released.connect(_calc_hit_trajectory)

func _process(delta):
	if hit:
		launch(delta)
	

func _on_area_entered(area):
	in_range = true
	set_mesh()

func _on_area_exited(area):
	in_range = false
	set_mesh()
	
func _calc_hit_trajectory(mouse_pos):
	if in_range:
		p0 = self.position
		p1 = find_mid_point(mouse_pos, self.position)
		p2 = find_mid_point(mouse_pos, self.position)*Vector3(1.5, 0, 1.5)
		animation_player.play('gnome_flying')
		hit = true

func set_mesh():
	pass
	#self.get_child(1).visible = !in_range
	#self.get_child(2).visible = in_range

func bezier(t):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r

func launch(delta):
	self.position = bezier(time)
	time += delta
	
func wander(direction: Vector3):
	state = 'Wander'
	animation_player.play('gnome_walking')
	flip(direction)

func flip(direction: Vector3):
	if state == 'Wander':
		self.direction = direction.rotated(Vector3.UP, randf_range(-PI/4, PI/4))
		if self.direction.z < 0:
			animated_sprite_3d.flip_h = true
		else:
			animated_sprite_3d.flip_h = false
		
		
	
func _physics_process(delta):
	if state == 'Wander':
		self.position += direction * speed * delta
	if time >= 1: # animation done
		queue_free()

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
	
