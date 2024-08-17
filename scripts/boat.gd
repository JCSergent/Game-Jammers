extends StaticBody3D

@export var enemy_group: Node
@export var max_enemies: float = 110.0
@export var max_sink_offset: Vector3 = Vector3(0, -.35, 0)
var start_pos: Vector3

func _ready():
	start_pos = self.position

func _on_enemies_child_entered_tree(node):
	var offset_ratio = enemy_group.get_child_count() / max_enemies
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property(self, "position", start_pos + max_sink_offset * offset_ratio, 1.0)

func _on_enemies_child_exiting_tree(node):
	var offset_ratio = enemy_group.get_child_count() / max_enemies
	create_tween().set_trans(Tween.TRANS_BACK).tween_property(self, "position", start_pos + max_sink_offset * offset_ratio, 1.0)
