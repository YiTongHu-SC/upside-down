extends Button

func _process(_delta: float) -> void:
	if GameDataGlobal.switch_view:
		text = "切换模式 - 切换视角"
	else:
		text = "切换模式 - 固定视角"