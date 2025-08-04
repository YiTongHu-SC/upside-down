extends CharacterBody2D

@export var physics_unit: float = 100
@export var acceleration: float = 1
@export var max_speed: float = 10


func _ready():
	add_to_group("enemy")
	
## TODO：设置多个节点，可配置速度阶梯
## 简单加速
func _physics_process(delta):
	velocity.x = move_toward(velocity.x, max_speed * physics_unit, acceleration * physics_unit * delta)
	move_and_slide()
