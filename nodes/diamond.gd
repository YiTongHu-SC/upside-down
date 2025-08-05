extends CharacterBody2D

@onready var is_dead = false

func _ready():
	print("Diamond ready")
	add_to_group("reward")

func kill_self():
	if is_dead: return
	is_dead = true
	print("Diamond dead")
	queue_free()