shader_type canvas_item;
uniform sampler2D tex_prev : filter_nearest;
uniform sampler2D tex_next : filter_nearest;
uniform float progress = 0.0;

void fragment(){
    vec2 uv = SCREEN_UV;
    float d = uv.x + uv.y;
    float mask = smoothstep((progress * 2.0) - 0.001, (progress * 2.0), d);
    COLOR = mix(texture(tex_next, uv), texture(tex_prev, uv), mask);
}
