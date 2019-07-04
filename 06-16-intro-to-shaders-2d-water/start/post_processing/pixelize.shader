shader_type canvas_item;

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 factor = vec2(16.0, 5.0) * 30.0;
	uv = floor(uv * factor) / factor;
	vec4 color = texture(SCREEN_TEXTURE, uv);
	color.x = float(int((color.x*8.0)+0.5))/8.0;
	color.y = float(int((color.y*8.0)+0.5))/8.0;
	color.z = float(int((color.z*8.0)+0.5))/8.0;
	COLOR = color;
}