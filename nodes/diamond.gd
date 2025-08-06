extends Area2D

@export var reward_value = 100

@onready var is_dead = false
func _ready():
	# 连接信号：玩家进入金币范围时调用 collect()
	body_entered.connect(_on_body_entered)
	add_to_group("reward")

func _on_body_entered(body: Node):
	if is_dead: return
	if body.is_in_group("hero"): # 确保进入的是玩家
		kill_self()

func kill_self():
	if is_dead: return
	is_dead = true
	var screen_pos = get_viewport().get_screen_transform() * get_canvas_transform() * global_position
	GameDataGlobal.on_add_score.emit(reward_value, screen_pos)
	queue_free()
