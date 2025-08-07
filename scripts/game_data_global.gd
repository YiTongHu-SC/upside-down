extends Node

var WIN_GAME_SCORE = 500
var MAX_SCORE = 2500

signal on_game_restart
signal on_game_over
signal on_upside_down
signal on_game_success
signal on_add_score(value: int, screen_pos: Vector2)
signal on_refresh_localization

var score = 0
var game_success = false
var default_lang = "en"
var current_lang: String
@onready var tense = 0
@onready var game_paused = true
@onready var switch_view: bool = false

func _ready() -> void:
	on_add_score.connect(add_score)
	current_lang = default_lang
	TranslationServer.set_locale(current_lang)

func change_mode():
	switch_view = !switch_view
	pass

func add_score(value: int, _pos: Vector2):
	score += value

func get_score_Level():
	if score >= MAX_SCORE: ## Master
		return 1
	elif score >= int(MAX_SCORE * 0.8): # Kung Fu Master
		return 2
	elif score >= int(MAX_SCORE * 0.6): # Expert
		return 3
	elif score >= int(MAX_SCORE * 0.4): # Disciple
		return 4
	elif score >= int(MAX_SCORE * 0.2): # Student
		return 5
	elif score >= int(MAX_SCORE * 0): # Beginner
		return 6
	return 0

func set_lang(lang: String):
	current_lang = lang
	TranslationServer.set_locale(current_lang)
	on_refresh_localization.emit()