extends AnimatedSprite3D

@onready var splash = $splash

func _ready():
	splash.playing = true

func _on_animation_finished():
	queue_free()
