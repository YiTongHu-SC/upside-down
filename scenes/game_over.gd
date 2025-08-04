extends PanelContainer

func _ready() -> void:
	modulate.a = 0
	visible = true
	GameDataGlobal.on_game_over.connect(trigger_game_over)

func trigger_game_over():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 1)