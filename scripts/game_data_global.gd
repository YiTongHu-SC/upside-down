extends Node

const MAX_SCORE = 2000
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


func get_score_Level():
	if score >= MAX_SCORE: ## Master
		return 1
	elif score >= MAX_SCORE - 200: # Kung Fu Master
		return 2
	elif score >= MAX_SCORE - 500: # Expert
		return 3
	elif score >= MAX_SCORE - 1000: # Disciple
		return 4
	elif score >= MAX_SCORE - 1500: # Student
		return 5
	elif score >= MAX_SCORE - 2000: # Beginner
		return 6
	return 0