extends AudioStreamPlayer2D

@export var pitch_scale_min: float = 0.9
@export var pitch_scale_max: float = 1.5

func _process(_delta: float) -> void:
	pitch_scale = lerp(pitch_scale_min, pitch_scale_max, GameDataGlobal.tense)
	pass