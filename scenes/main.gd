extends Node2D

@export var ui_panel: Container
@export var hero_pk: PackedScene
@export var hero_socket: Node2D
@export var level_pk: PackedScene
@export var level_socket: Node2D
@export var width: int = 1920
@export var enemy: CharacterBody2D
@export var start_level: Node2D
@export var checkpoint_width: int = 0
@export var start_game_panel: Container
@export var game_over_panel: Container
@export var hero_spawn_at: Node2D
@export var camera: Camera2D

var hero: CharacterBody2D
var last_point: Vector2
var hero_pos: Vector2

func _ready() -> void:
	restart_game()

func _generate_new_level():
	print("generating new level")
	var level = level_pk.instantiate()
	level_socket.add_child(level)
	level.set_enemy(enemy)
	level.position = last_point + Vector2(width, 0)
	last_point = level.position

func _physics_process(_delta: float) -> void:
	if not hero: return
	if hero.position.x > last_point.x - checkpoint_width:
		_generate_new_level()
	## 检查角色位置，超过一定阈值时，敌人开始追击
	if hero.global_position.x > start_level.global_position.x:
		enemy.start_run()

func start_game():
	GameDataGlobal.game_paused = false
	ui_panel.show()
	start_game_panel.hide()
	game_over_panel.hide()
	game_over_panel.modulate.a = 0

func change_mode():
	GameDataGlobal.change_mode()

func restart_game():
	GameDataGlobal.score = 0
	last_point = start_level.position
	hero_pos = hero_spawn_at.position
	GameDataGlobal.game_paused = true
	ui_panel.hide()
	start_game_panel.show()
	game_over_panel.hide()
	if hero:
		hero.kill_self()
	hero = hero_pk.instantiate()
	hero_socket.add_child(hero)
	hero.position = hero_pos
	camera.set_target(hero)
	GameDataGlobal.on_game_restart.emit()
