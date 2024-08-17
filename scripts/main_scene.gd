extends Camera3D

@onready var zone = $"../impact_zone"

var start_pos = Vector3(0,0,0)
var end_pos = Vector3(0,0,0)

func _ready():
	zone.visible = false

func _process(delta):
	if Input.is_action_just_pressed("mouseclick"):
		zone.visible = true
		var res = shoot_ray()
		if !res.is_empty():
			start_pos = res["position"]
			zone.position = start_pos
			zone.scale = Vector3(0.1, 0.1 ,0.1)

	if Input.is_action_pressed("mouseclick"):
		var res = shoot_ray()
		if !res.is_empty():
			end_pos = res["position"]
			var s = min(start_pos.distance_to(end_pos), 0.2) # limit size of cone
			zone.scale = Vector3(s,0.1,s)
			zone.look_at(Vector3(end_pos.x, start_pos.y, end_pos.z))

	if Input.is_action_just_released("mouseclick"):
		zone.visible = false
		SignalBus.released.emit()

func shoot_ray():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_len = 1000
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_len
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	return space.intersect_ray(ray_query)
