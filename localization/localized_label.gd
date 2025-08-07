extends Label

@export var local_key: String

func _ready() -> void:
	refresh()
	GameDataGlobal.on_refresh_localization.connect(refresh)

func refresh():
	text = tr(local_key)