extends Node2D

const kill_distance = 1920
var enemy: Node2D = null

func set_enemy(target):
	enemy = target

## 自动回收
func _physics_process(_delta: float) -> void:
	if enemy != null:
		var enemy_pos = enemy.global_position.x
		var self_pos = global_position.x
		if enemy_pos - self_pos > kill_distance:
			queue_free()