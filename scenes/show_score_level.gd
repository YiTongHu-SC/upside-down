extends Control
@export var delay = 0.5
@export var duration: float = 2
@export var progress: ProgressBar
@export var level_label: RichTextLabel
@export var desc_label: Label

var level_text: String
var level_desc: String

func _ready() -> void:
	hide()
	GameDataGlobal.on_game_over.connect(show_level)
	GameDataGlobal.on_game_success.connect(show_level)
	GameDataGlobal.on_game_restart.connect(reset)

func reset():
	hide()
	level_label.text = ""
	desc_label.clear()

func show_level():
	print("show_level")
	show()
	level_label.hide()
	desc_label.hide()
	progress.hide()
	progress.value = 0
	var target_value = float(GameDataGlobal.score) / GameDataGlobal.MAX_SCORE
	target_value *= 100
	await get_tree().create_timer(delay).timeout
	progress.show()
	level_label.show()
	desc_label.show()
	var tween: Tween = create_tween()
	tween.tween_property(progress, "value", target_value, duration).from(0)
	await get_tree().create_timer(duration).timeout
	update_level()
	level_label.text = level_text
	desc_label.set_local(level_desc)
	pass

func update_level():
	match GameDataGlobal.get_score_Level():
		0:
			level_text = ""
			level_desc = ""
		1:
			## BBCode format
			level_text = "[color=#ffff4d]S[/color]"
			level_desc = "level_S"
		2:
			level_text = "[color=#ffa929]A[/color]"
			level_desc = "level_A"
		3:
			level_text = "[color=#ff8161]B[/color]"
			level_desc = "level_B"
		4:
			level_text = "[color=#ff75bc]C[/color]"
			level_desc = "level_C"
		5:
			level_text =  "[color=#7a9cff]D[/color]"
			level_desc = "level_D"
		6:
			level_text =  "[color=#b1ff8c]E[/color]"
			level_desc = "level_E"
