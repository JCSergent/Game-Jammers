class_name ImpactZone extends Node3D

@export var area_3d: Area3D
@onready var main_camera: MainCamera = $"../Main Camera"
@onready var hand = $"../hand"

@export var pull_difficulty = 0.3
var start_pos = Vector3(0,0,0)
var end_pos = Vector3(0,0,0)

func _ready():
	disable()

func _process(delta):
	if Input.is_action_just_pressed("mouseclick"):
		enable()
		var res = shoot_ray()
		if !res.is_empty():
			start_pos = res["position"]
			self.position = start_pos
			self.scale = Vector3(0.1, 0.1 ,0.1)
			
			hand.visible = true
			hand.position = start_pos + Vector3(0,0.1,0)

	if Input.is_action_pressed("mouseclick"):
		var res = shoot_ray()
		if !res.is_empty():
			end_pos = res["position"]
			var d2 = Vector3(start_pos.x, end_pos.y, start_pos.z).distance_to(end_pos)
			var s = min(d2 * pull_difficulty, 0.2) # limit size of cone
			self.scale = Vector3(s,0.1,s)
			self.look_at(end_pos)
			self.position.y = end_pos.y
			
			var sc = 0.1
			hand.position = Vector3(start_pos.x + sc*(end_pos.x - start_pos.x), hand.position.y, start_pos.z + sc*(end_pos.z - start_pos.z))
			var start_flat = Vector2(start_pos.x, start_pos.z)
			var end_flat = Vector2(end_pos.x, end_pos.z)
			var angle = atan2(start_flat.y - end_flat.y, start_flat.x - end_flat.x) # radians
			var frame = int(angle / (PI/6)) + 5 
			hand.frame = frame

	if Input.is_action_just_released("mouseclick"):
		disable()
		hand.visible = false
		self.scale = Vector3(0.01,0.01,0.01) # hot fix for weird bug
		SignalBus.released.emit(start_pos, start_pos.distance_to(end_pos))

func shoot_ray():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_len = 1000
	var from = main_camera.project_ray_origin(mouse_pos)
	var to = from + main_camera.project_ray_normal(mouse_pos) * ray_len
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	return space.intersect_ray(ray_query)

func disable():
	self.visible = false
	area_3d.monitorable = false

func enable():
	self.visible = true
	area_3d.monitorable = true
