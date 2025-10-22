shader_type canvas_item;

uniform float pixel_size : hint_range(1.0, 64.0) = 1.0;

vec2 snap_uv(vec2 uv, float chunk, vec2 pix_size){
	vec2 step_uv = pix_size * chunk;
	return floor(uv / step_uv) * step_uv + step_uv * 0.5;
}

void fragment() {
	vec2 uv = UV;
	vec2 screen_pixel_size = SCREEN_PIXEL_SIZE;
	float chunk = max(1.0, floor(pixel_size + 0.0001));
	vec2 pixel_uv = snap_uv(uv, chunk, screen_pixel_size);
	COLOR = texture(TEXTURE, pixel_uv);
}
