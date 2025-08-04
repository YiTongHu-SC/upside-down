extends PanelContainer

func _ready() -> void:
	modulate.a = 0
	visible = true

func trigger_game_over():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 1)