shader_type canvas_item;

uniform vec2 tiled_factor = vec2(5.0, 5.0);
uniform float aspect_ratio = 0.5;
uniform vec2 offset_scale = vec2(2.0, 2.0);
uniform vec2 amplitude = vec2(0.05, 0.1);
uniform vec2 time_scale = vec2(1.0, 1.0);

void fragment() {
	vec2 tiled_uvs = UV * tiled_factor;
	tiled_uvs.y *= aspect_ratio;
	
	vec2 waves_uv_offset;
	waves_uv_offset.x = cos(TIME * time_scale.x + (tiled_uvs.x + tiled_uvs.y) * offset_scale.x);
	waves_uv_offset.y = sin(TIME * time_scale.y + (tiled_uvs.x + tiled_uvs.y) * offset_scale.y);
	
	COLOR = texture(TEXTURE, tiled_uvs + waves_uv_offset * amplitude);
//	COLOR = vec4(waves_uv_offset / 0.05, 0.0, 1.0);
//	COLOR = vec4(tiled_uvs, 0.0, 1.0);
}