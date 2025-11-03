shader_type canvas_item;

uniform sampler2D tex_prev : filter_nearest;
uniform sampler2D tex_next : filter_nearest;
uniform float progress = 0.0;
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {
    vec2 uv = SCREEN_UV;
    float d = length(uv - center);
    float mask = smoothstep(progress - 0.001, progress, d);
    COLOR = mix(texture(tex_next, uv), texture(tex_prev, uv), mask);
}
