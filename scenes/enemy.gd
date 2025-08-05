extends CharacterBody2D

@export var physics_unit: float = 100
@export var acceleration: float = 1
@export var max_speed: float = 10
@export var start_speed: float = 1

var acc:float = 0

var init_pos: Vector2

func _ready():
	add_to_group("enemy")
	init_pos = position
	reset()
	GameDataGlobal.on_game_restart.connect(reset)

## TODO：设置多个节点，可配置速度阶梯
## 简单加速
func _physics_process(delta):
	if GameDataGlobal.game_paused: return
	velocity.x = move_toward(velocity.x, max_speed * physics_unit, acc * physics_unit * delta)
	move_and_slide()

func start_run():
	acc = acceleration

func reset():
	position = init_pos
	velocity.x = start_speed * physics_unit;
	acc = 0