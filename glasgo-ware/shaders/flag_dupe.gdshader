shader_type canvas_item;

uniform vec4 color_field : source_color = vec4(0.01, 0.22, 0.66, 1.0); 
uniform vec4 color_cross : source_color = vec4(1.0, 1.0, 1.0, 1.0);  

uniform int tiles_x : hint_range(1, 64) = 8;
uniform int tiles_y : hint_range(1, 64) = 5;

uniform float cross_half_width : hint_range(0.005, 0.2) = 0.06;
uniform float feather          : hint_range(0.0, 0.05)  = 0.01;

uniform float wave_amp  : hint_range(0.0, 0.1)  = 0.02;
uniform float wave_freq : hint_range(0.1, 10.0) = 2.5;
uniform float wave_speed: hint_range(0.0, 10.0) = 2.0;

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

	vec2 p = vec2(pixel_uv.x * float(tiles_x), pixel_uv.y * float(tiles_y));

	float t = TIME * wave_speed;
	p.y += sin(p.x * wave_freq + t) * wave_amp;
	p.x += sin(p.y * wave_freq * 0.9 + t * 0.8) * wave_amp * 0.6;

	float inv_sqrt2 = 0.70710678;
	float d1 = abs((p.y - p.x) - round(p.y - p.x)) * inv_sqrt2;
	float d2 = abs((p.y + p.x) - round(p.y + p.x)) * inv_sqrt2;

	float band1 = 1.0 - smoothstep(cross_half_width, cross_half_width + feather, d1);
	float band2 = 1.0 - smoothstep(cross_half_width, cross_half_width + feather, d2);
	float saltire = max(band1, band2);

	vec3 rgb = mix(color_field.rgb, color_cross.rgb, saltire);
	float a  = mix(color_field.a,   color_cross.a,   saltire);

	COLOR = vec4(rgb, a);
}