shader_type canvas_item;

uniform sampler2D tex_prev : filter_nearest;
uniform sampler2D tex_next : filter_nearest;
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {
    vec2 uv = SCREEN_UV;
    float axis_uv = mix(uv.x, uv.y, 0);
    float axis_center = mix(center.x, center.y, 0);
    float d = abs(axis_uv - axis_center);
    float half_open = 0.5 * progress;
    float edge0 = max(half_open - 0.001, 0.0);
    float edge1 = half_open;
    float outside_mask = smoothstep(edge0, edge1, d);
    float next_weight = mix(1.0 - outside_mask, outside_mask, step(0.5, 0));
    vec4 col_prev = texture(tex_prev, uv);
    vec4 col_next = texture(tex_next, uv);
    COLOR = mix(col_prev, col_next, next_weight);
}
