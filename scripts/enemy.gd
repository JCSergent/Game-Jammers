class_name Enemy extends Area3D

@onready var animation_player = $AnimationPlayer
@onready var animated_sprite_3d = $AnimatedSprite3D

@export var starter: bool
var in_range = false
var state: String = 'Climbing'
var direction: Vector3
var speed: float = 0.2
# current ship bounds apprx
const X_BOUNDS = [-0.5, 0.5]
const Y_BOUNDS = [-1, 1]
const INITIAL_Y = 0.375 # idk where this number comes from
#var INITIAL_Y: float = 0.0

var p0 = Vector3.ZERO
var p1 = Vector3.ZERO
var p2 = Vector3.ZERO

var time = 0

func _ready():
	if starter:
		animation_player.play("gnome_idle")
	else:
		animation_player.play('gnome_climbing')
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
		if starter:
			power = 0.9

		# the ship is rotated 90deg in y axis so I'm hacking this together rather than changing it
		# this gets the distance between the base of the cone and the enemy to calc the vector the enemy trajectory should follow
		var rot = Vector3(diff.z, 0, -diff.x).normalized()
		p0 = self.position
		p1 = self.position + rot*power + Vector3(0,0.4,0)
		p2 = self.position + rot*power + Vector3(0,self.position.y, 0)
		
		if starter:
			p1 += Vector3(0,0.4,0)
		if !in_bounds(p2):
			p2 *= Vector3(1,0,1)
			
		state = 'Flying'
		animation_player.play('gnome_flying')

func set_mesh():
	pass

func bezier(t):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r

func launch(delta):
	self.position = bezier(time)
	time += delta
	
func wander(direction: Vector3):
	self.position.y = INITIAL_Y
	state = 'Walking'
	animation_player.play('gnome_walking')
	flip(direction)

func flip(direction: Vector3):
	if state == 'Walking':
		self.direction = direction.rotated(Vector3.UP, randf_range(-PI/4, PI/4))
		if self.direction.z < 0:
			animated_sprite_3d.flip_h = true
		else:
			animated_sprite_3d.flip_h = false
	
func _physics_process(delta):
	if state == 'Flying':
		launch(delta)
		if in_bounds(p2) and self.position.y < INITIAL_Y -0.01:
			self.position.y = INITIAL_Y
			time = 0
			state = ''
			var new_direction = Vector3(p2.x-p0.x, 0, p2.z-p0.z).normalized()
			get_tree().create_timer(randf_range(0,0.4)).timeout.connect(func get_up(): wander(new_direction))
		elif !in_bounds(p2) and self.position.y == 0:
			queue_free()
	elif state == 'Walking':
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
	
