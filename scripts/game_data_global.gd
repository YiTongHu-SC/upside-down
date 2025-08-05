extends Node

signal on_game_restart
signal on_game_over
signal on_upside_down

var score = 0

@onready var game_paused = true
@onready var switch_view: bool = false

func change_mode():
	switch_view = !switch_view
	pass