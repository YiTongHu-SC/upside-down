extends ColorRect

func _ready() -> void:
	set_upside_down(false)
	GameDataGlobal.on_upside_down.connect(self.set_upside_down)

## 设置material的参数值，其中材质由shader定义，定义了bool upside_down
func set_upside_down(value: bool):
	if material is ShaderMaterial:
		material.set_shader_parameter("upside_down", value)
