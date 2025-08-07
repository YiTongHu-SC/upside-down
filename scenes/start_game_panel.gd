extends PanelContainer

@export var button_start: Button
func _ready():
	button_start.grab_focus()
	GameDataGlobal.on_game_restart.connect(_on_game_restart)

func _input(event):
	# 检查是否是手柄按钮事件
	if event is InputEventJoypadButton:
		# 检查是否按下了A键（button_index为0）且是按下事件（不是释放）
		if event.button_index == 0 and event.pressed:
			# 获取当前焦点的控件
			var focused_item = get_viewport().gui_get_focus_owner()
			# 如果当前焦点控件是按钮，则模拟按下
			if focused_item and focused_item is Button:
				focused_item.emit_signal("pressed")
				# 标记事件已处理，防止其他地方重复处理
				get_viewport().set_input_as_handled()

func _on_game_restart():
	button_start.grab_focus()