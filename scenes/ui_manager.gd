extends PanelContainer

@export var score_pk: PackedScene
@export var score_socket: Control

func _ready():
	GameDataGlobal.on_add_score.connect(_on_add_score)

func _on_add_score(value: int, pos: Vector2):
	var score = score_pk.instantiate()
	score_socket.add_child(score)
	score.set_value(value)
	score.set_flow(pos)
