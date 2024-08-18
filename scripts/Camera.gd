class_name MainCamera extends Camera3D

@onready var main_camera = $"."
@onready var start_camera = $"../Start Camera"
@onready var game_camera = $"../Game Camera"

var transitioning: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	main_camera.fov = start_camera.fov
	main_camera.cull_mask = start_camera.cull_mask
	main_camera.global_transform = start_camera.global_transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func view_game():
	transition_camera3D(start_camera, game_camera)

func view_start():
	transition_camera3D(game_camera, start_camera)
	
	
func transition_camera3D(from: Camera3D, to: Camera3D, duration: float = 1.0) -> void:
	if transitioning: return
	# Copy the parameters of the first camera
	main_camera.fov = from.fov
	main_camera.cull_mask = from.cull_mask
	
	# Move our transition camera to the first camera position
	main_camera.global_transform = from.global_transform
	
	# Make our transition camera current
	main_camera.current = true
	
	transitioning = true
	
	# Move to the second camera, while also adjusting the parameters to
	# match the second camera
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(main_camera, "global_transform", to.global_transform, duration).from(main_camera.global_transform)
	tween.tween_property(main_camera, "fov", to.fov, duration).from(main_camera.fov)
	
	# Wait for the tween to complete
	await tween.finished
	
	# Make the second camera current
	to.current = true
	transitioning = false
