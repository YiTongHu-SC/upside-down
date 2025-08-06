extends Node2D

const kill_distance = 1920
var enemy: Node2D = null

@export var diamond_sockets: Array[Node2D]
@export var diamond_pk: PackedScene

@onready var init_exist = true

func _ready():
	GameDataGlobal.on_game_restart.connect(reset)

func set_enemy(target):
	enemy = target
	init_exist = false

## 自动回收
func _physics_process(_delta: float) -> void:
	if enemy != null:
		var enemy_pos = enemy.global_position.x
		var self_pos = global_position.x
		if enemy_pos - self_pos > kill_distance:
			queue_free()

func reset():
	if not init_exist:
		queue_free()
	for socket in diamond_sockets:
		var diamond = diamond_pk.instantiate()
		socket.add_child(diamond)
	pass