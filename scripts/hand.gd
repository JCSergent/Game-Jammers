extends AnimatedSprite3D

@onready var timer = $Timer

func start_timer():
	timer.start()
	
func _on_timer_timeout():
	if self.animation == "flick":
		self.visible = false
