extends Node2D

@export var splash_duration: float = 1.5
@onready var animtion: AnimationPlayer = $CanvasLayer/PanelContainer/AnimationPlayer

func _ready() -> void:
	animtion.play("splash")
	var timer = get_tree().create_timer(splash_duration)
	await timer.timeout
	var loading = load("res://scenes/main.tscn")
	get_tree().change_scene_to_packed(loading)
