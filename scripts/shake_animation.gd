extends Node

var sprite
var x_max = 1.5
var r_max = 10
const STOP_THRESHOLD = 0.1
const TWEEN_DURATION = 0.05
const RECOVERY_FACTOR = 2.0/3
const TRANSITION_TYPE = Tween.TRANS_SINE

signal tween_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	var host = get_parent()
	if host.has_node("Sprite"):
		sprite = host.get_node("Sprite")

func start():
	create_new_tween(self)
	#var x = x_max
	#var r = r_max
	#while x > STOP_THRESHOLD:
		## left
		#var tween = _tilt_left(x, r)
		#await tween.tween_completed
		#tween.queue_free()
		#x *= RECOVERY_FACTOR
		#r *= RECOVERY_FACTOR
		#_recenter()
		#
		## right
		#tween = _tilt_right(x, r)
		#await tween.tween_completed
		#tween.queue_free()
		#x *= RECOVERY_FACTOR
		#r *= RECOVERY_FACTOR
		#_recenter()
	#emit_signal("tween_complete")
	
func _tilt_left(x,r):
	var tween = create_new_tween(self)
	
	tween.interpolate_property(
		sprite, 
		"position:x", 
		0, 
		-x, 
		TWEEN_DURATION, 
		TRANSITION_TYPE, 
		Tween.EASE_OUT
	)
	
	tween.interpolate_property(
		sprite,
		"rotation_degrees",
		0,
		r,
		TWEEN_DURATION,
		TRANSITION_TYPE,
		Tween.EASE_OUT
	)
	
	tween.start()
	return tween
	
func _tilt_right(x,r):
	var tween = create_new_tween(self)
	
	tween.interpolate_property(
		sprite, 
		"position:x", 
		0, 
		x, 
		TWEEN_DURATION, 
		TRANSITION_TYPE, 
		Tween.EASE_OUT
	)
	
	tween.interpolate_property(
		sprite,
		"rotation_degrees",
		0,
		-r,
		TWEEN_DURATION,
		TRANSITION_TYPE,
		Tween.EASE_OUT
	)
	
	tween.start()
	return tween

func _recenter():
	var tween = create_new_tween(self)
	
	tween.interpolate_property(
		sprite,
		"position:x",
		sprite.position.x,
		0,
		TWEEN_DURATION, TRANSITION_TYPE, Tween.EASE_IN
	)
	
	tween.interpolate_property(
		sprite,
		"rotation_degrees",
		sprite.rotation_degrees,
		0,
		TWEEN_DURATION, TRANSITION_TYPE, Tween.EASE_IN
	)
	
	tween.start()
	return tween
	
func create_new_tween(parent):
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color.RED, 1)

	









