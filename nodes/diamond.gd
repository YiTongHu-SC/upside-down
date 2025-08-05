extends CharacterBody2D

@export var reward_value = 100

@onready var is_dead = false
func _ready():
	add_to_group("reward")

func kill_self():
	if is_dead: return
	is_dead = true
	GameDataGlobal.score += reward_value
	queue_free()