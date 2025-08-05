extends Node2D

var lifetime = 0.25
@onready var animation = $AnimationPlayer

func _ready() -> void:
	animation.play("explosion")
	kill_self()

func kill_self() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()