shader_type canvas_item;

uniform sampler2D screen_tex:hint_screen_texture,repeat_disable,filter_nearest;
uniform bool upside_down = false;

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV;
	if (upside_down){
		uv.y = 1.0 - uv.y;
	}
	COLOR = texture(screen_tex,uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
