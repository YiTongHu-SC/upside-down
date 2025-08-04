extends Sprite2D

var acceleration = 100
@onready var velocity: Vector2 = Vector2.ZERO

## TODO：设置多个节点，可配置速度阶梯
## 简单加速
func _physics_process(delta):
	position += velocity * delta
	velocity += Vector2.RIGHT * acceleration * delta
