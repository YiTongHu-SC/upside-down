extends PanelContainer

@export var delay = 0.8
@export var duration = 1.5
@export var button_start: Button

func _ready() -> void:
	button_start.grab_focus()
	modulate.a = 0
	hide()
	GameDataGlobal.on_game_over.connect(trigger_game_over)

func trigger_game_over():
	show()
	GameDataGlobal.game_paused = true
	button_start.disabled = true
	set_process_input(false)
	var timer = get_tree().create_timer(delay)
	await timer.timeout
	# Re-enable input processing after delay
	button_start.disabled = false
	set_process_input(true)
	button_start.grab_focus()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, delay)

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