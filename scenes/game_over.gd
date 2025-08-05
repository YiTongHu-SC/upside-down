extends PanelContainer

@export var delay = 0.8
@export var duration = 1.5

func _ready() -> void:
	modulate.a = 0
	visible = true
	GameDataGlobal.on_game_over.connect(trigger_game_over)

func trigger_game_over():
	GameDataGlobal.game_paused = true
	var timer = get_tree().create_timer(delay)
	await timer.timeout
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, delay)
