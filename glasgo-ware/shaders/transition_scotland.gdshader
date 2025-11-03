shader_type canvas_item;
uniform sampler2D tex_prev : filter_nearest;
uniform sampler2D tex_next : filter_nearest;
uniform float progress = 0.0;
uniform vec2 center = vec2(0.5, 0.5);
uniform float thickness = 0.1;

void fragment(){
    vec2 uv = SCREEN_UV - center;
    float d1 = abs(uv.x - uv.y);
    float d2 = abs(uv.x + uv.y);
    float mask_line = min(d1, d2);
	float mult = 7.0;
    float stripe = smoothstep(thickness * clamp(progress, 0, 1) * mult, thickness * (clamp(progress, 0, 1) + 0.001) * mult, mask_line);
    COLOR = mix(texture(tex_next, SCREEN_UV), texture(tex_prev, SCREEN_UV), stripe);
}
