class_name ImpactZone extends Node3D

@export var area_3d: Area3D

func disable():
	self.visible = false
	area_3d.monitorable = false
	
func enable():
	self.visible = true
	area_3d.monitorable = true
