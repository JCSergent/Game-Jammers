class_name Enemy extends Area3D

@onready var animation_player = $AnimationPlayer
@onready var animated_sprite_3d = $AnimatedSprite3D
@onready var audio = $audio_effects

@export var starter: bool

var splash = preload("res://scenes/splash.tscn")
var in_range = false
var state: String = ''
var direction: Vector3
var speed: float = 0.1
# current ship bounds apprx
const X_BOUNDS = [-0.45, 0.45]
const Y_BOUNDS = [-1.3, 0.6] # this is really z bounds :) 
const LANDING_OFFSET = 0.2 # for avoiding clipping
const INITIAL_Y = 0.375 # idk where this number comes from

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
		audio.pitch_scale = 0.8 + float(randi() % 12) / 10
		audio.playing = true
		var diff = (mouse_pos - self.global_position)*Vector3(1,0,1)
		if starter:
			power = 1.2

		# the ship is rotated 90deg in y axis so I'm hacking this together rather than changing it
		# this gets the distance between the base of the cone and the enemy to calc the vector the enemy trajectory should follow
		var rot = Vector3(diff.z, 0, -diff.x).normalized()
		p0 = self.position
		p1 = self.position + rot*power + Vector3(0,0.4,0)
		p2 = self.position + rot*power*2

		if starter:
			p1 += Vector3(0,0.6,0)
		if !in_bounds(p2):
			p1 = Vector3(p2.x, p1.y, p2.z)
			p2 *= Vector3(1,0,1)
			#land far enough away so we don't see clipping through boat
			if p2.x < X_BOUNDS[0]:
				p2.x = min(p2.x, X_BOUNDS[0] - LANDING_OFFSET)
			elif p2.x > X_BOUNDS[1]:
				p2.x = max(p2.x, X_BOUNDS[1] + LANDING_OFFSET)
			
			if p2.z < Y_BOUNDS[0]:
				p2.z = min(p2.z, Y_BOUNDS[0] - LANDING_OFFSET)
			elif p2.z > Y_BOUNDS[1]:
				p2.z = max(p2.z, Y_BOUNDS[1] + LANDING_OFFSET)
				
		state = 'Flying'

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
		self.position.y = INITIAL_Y
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
			add_splash(self.global_position)
			queue_free()
			SignalBus.gnome_death.emit()
	elif state == 'Walking':
		self.position += direction * speed * delta
		
func in_bounds(pos):
	return pos.x > X_BOUNDS[0] and pos.x < X_BOUNDS[1] and pos.z > Y_BOUNDS[0] and pos.z < Y_BOUNDS[1]
	
func add_splash(position):
	var new_splash = splash.instantiate()
	new_splash.global_position = Vector3(position.x, 0.1, position.z)
	new_splash.scale *= 0.05
	new_splash.rotation = Vector3(80, 0, 0)
	get_tree().get_root().add_child(new_splash)
