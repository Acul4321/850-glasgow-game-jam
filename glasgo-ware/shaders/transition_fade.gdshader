shader_type canvas_item;

uniform sampler2D tex_prev : filter_nearest;
uniform sampler2D tex_next : filter_nearest;
uniform float progress = 0.0;

void fragment() {
    vec2 uv = SCREEN_UV;
	vec4 prev_color = texture(tex_prev, uv);
	vec4 next_color = texture(tex_next, uv);
    COLOR = mix(prev_color, next_color, progress);
}
