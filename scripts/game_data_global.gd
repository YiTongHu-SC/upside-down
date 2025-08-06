extends Node

signal on_game_restart
signal on_game_over
signal on_upside_down
signal on_game_success
signal on_add_score(value: int, screen_pos: Vector2)

var score = 0

@onready var tense = 0
@onready var game_paused = true
@onready var switch_view: bool = false

func _ready() -> void:
	on_add_score.connect(add_score)

func change_mode():
	switch_view = !switch_view
	pass

func add_score(value: int, _pos: Vector2):
	score += value