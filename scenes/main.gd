extends Node2D

@export var level_pk: PackedScene
@export var level_socket: Node2D
@export var width: int = 1920
@export var hero: Node2D
@export var enemy: Node2D
@export var start_level: Node2D
@export var checkpoint_width: int = 0

var last_point: Vector2

func _ready() -> void:
	last_point = start_level.position
	print("last point: ", last_point)

func _generate_new_level():
	print("generating new level")
	var level = level_pk.instantiate()
	level_socket.add_child(level)
	level.position = last_point + Vector2(width, 0)
	last_point = level.position

func _physics_process(_delta: float) -> void:
	if hero.position.x > last_point.x - checkpoint_width:
		_generate_new_level()
	pass
