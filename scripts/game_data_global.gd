extends Node

signal on_game_restart
signal on_game_over
signal on_upside_down

@onready var game_paused = true
@onready var switch_view: bool = true

func change_mode():
	switch_view = !switch_view
	pass