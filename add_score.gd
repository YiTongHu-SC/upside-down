extends Control

@export var move_distance: float = 100.0
@export var init_offset: float = 0
@export var tween_time: float = 1
@onready var score_label: Label = $Label

func set_flow(screen_pos):
	# Convert screen coordinates to UI coordinates
	# var ui_position = get_global_transform_with_canvas().affine_inverse() * get_viewport().get_screen_transform().affine_inverse() * screen_pos
	var ui_position = get_viewport().get_screen_transform().affine_inverse() * screen_pos
	position = ui_position
	position.y -= init_offset
	var target_pos = position - Vector2(0, move_distance)
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", target_pos, tween_time)
	# # tween alpha of this node 
	tween.tween_property(self, "modulate:a", 0, tween_time).from(1.0)
	await get_tree().create_timer(tween_time).timeout
	queue_free()
	pass

func set_value(num: int):
	score_label.text = "+%d" % num
