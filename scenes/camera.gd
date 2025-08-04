extends Camera2D

@export var follow_target: Node2D
@export var follow_offset: Vector2 = Vector2(0, 0)
@export var right_threshold: float = 300.0
@export var left_threshold: float = 100.0

## 相机跟随
func _process(_delta):
	if follow_target:
		# 获取目标相对于相机当前位置的坐标
		var target_pos = follow_target.global_position
		var camera_pos = global_position
		
		# 计算目标相对于相机中心的偏移
		var offset_x = target_pos.x - camera_pos.x
		
		# 只在水平方向上检查阈值并跟随
		if offset_x > right_threshold:
			# 目标超过右阈值，向右跟随
			global_position.x = target_pos.x - right_threshold + follow_offset.x
		elif offset_x < -left_threshold:
			# 目标超过左阈值，向左跟随
			global_position.x = target_pos.x + left_threshold + follow_offset.x
		# 在垂直方向上保持当前位置不变
	if Input.is_action_just_pressed("SWITCH"):
		scale.y = -1