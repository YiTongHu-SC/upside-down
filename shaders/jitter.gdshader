shader_type canvas_item;

// 颜色调整
uniform float brightness : hint_range(0.0, 2.0) = 1.0;
// 效果参数
// 抖动由两个随机扰动叠加，大扰动 + 细微扰动
// 两个扰动的计算逻辑是相同的。只是参数上的不同
// 噪声图像
uniform sampler2D NOISE_TEXTURE: repeat_enable;
uniform float step_interval = 1;
// 大扰动
uniform float strength: hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float uv_scaling: hint_range (0.0, 10.0, 0.05) = 1.0;
uniform float movement_speed:hint_range(0, 5, 1) = 1;
// 细微扰动
uniform float strength_micro: hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float uv_scaling_micro: hint_range (0.0, 10.0, 0.05) = 1.0;
uniform float movement_speed_micro: hint_range (0.0, 5.0, 0.01) = 0.1;
// 常数
// 放大参数,将参数放大到合适范围内，便于调试
const float scale_pix = 1.0;
const float strength_scale = 0.01;
// 随机数产生方向
const vec2 movement_direction1 = vec2(1, 0);
const vec2 movement_direction2 = vec2(0, 1);
const vec2 movement_direction3 = vec2(1, 1);
const vec2 movement_direction4 = vec2(1, -1);

void fragment() {

	// 噪声速度,阶梯函数
	vec2 movement_factor1 = movement_direction1 * movement_speed * floor(TIME/step_interval) * step_interval;
	vec2 movement_factor2 = movement_direction2 * movement_speed * floor(TIME/step_interval) * step_interval;
	vec2 movement_factor3 = movement_direction3 * movement_speed_micro * floor(TIME/step_interval) * step_interval;
	vec2 movement_factor4 = movement_direction4 * movement_speed_micro * floor(TIME/step_interval) * step_interval;

	// 根据图片尺寸归一化，保证xy两个方向一致性
	vec2 scale_unit = vec2(1, TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x);
	vec2 scale_unit_noise = vec2(1, TEXTURE_PIXEL_SIZE.x / TEXTURE_PIXEL_SIZE.y);
	// 噪声值
	float noise_value1 = texture(NOISE_TEXTURE, scale_pix * uv_scaling * UV * scale_unit_noise + movement_factor1 * scale_unit_noise).r - 0.5;
	float noise_value2 = texture(NOISE_TEXTURE, scale_pix * uv_scaling * UV * scale_unit_noise  + movement_factor2 * scale_unit_noise).r - 0.5;
	float noise_value3 = texture(NOISE_TEXTURE, scale_pix * uv_scaling_micro * UV  + movement_factor3).r - 0.5;
	float noise_value4 = texture(NOISE_TEXTURE, scale_pix * uv_scaling_micro * UV  + movement_factor4).r - 0.5;
	// 计算UV扰动

	vec2 uv = UV + strength_scale * strength * vec2(noise_value1,noise_value2) * scale_unit;
	vec2 uv_micro = strength_scale * strength_micro * scale_unit * vec2(noise_value3,noise_value4);
	// 两个扰动叠加
	COLOR = texture(TEXTURE, uv + uv_micro);
	COLOR.rgb *= brightness;
}