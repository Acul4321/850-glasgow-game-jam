shader_type canvas_item;

uniform bool enabled = true;
uniform float border_width = 0.02;
uniform float blur = 0.01;
uniform float corner_radius = 0.05;
uniform float dash_length = 0.1;
uniform float dash_gap = 0.05;
uniform float speed = 1.0;
uniform vec4 border_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	if (enabled) {
	    vec2 uv = UV;
	    vec2 center = vec2(0.5, 0.5);
	    vec2 size = vec2(0.5, 0.5);

	    vec2 d = abs(uv - center) - size + vec2(corner_radius);
	    float dist = min(max(d.x, d.y), 0.0) + length(max(d, 0.0)) - corner_radius;

	    vec2 pos = uv - center;
	    float t = 0.0;
	    float perimeter = 2.0 * (size.x + size.y);

	    vec2 abs_pos = abs(pos);
	    float u = 0.0;
	    if (abs_pos.x > abs_pos.y) {
	        if (pos.x > 0.0) {
	            u = (pos.y + size.y) + size.x;
	        } else {
	            u = (size.y - pos.y) + 3.0 * size.x;
	        }
	    } else {
	        if (pos.y > 0.0) {
	            u = (size.x - pos.x);
	        } else {
	            u = (pos.x + size.x) + 2.0 * size.x;
	        }
	    }

	    perimeter += 2.0 * 3.141592 * corner_radius * 0.5;
	    u = fract(u / perimeter + TIME * speed);

	    float dash_cycle = dash_length + dash_gap;
	    float pattern_pos = mod(u * perimeter, dash_cycle);
	    float edge_alpha = smoothstep(border_width + blur, border_width - blur, abs(dist));
	    float border_mask = step(abs(dist), border_width + blur);

	    if (pattern_pos < dash_length && border_mask > 0.0) {
	        COLOR.rgb = border_color.rgb;
	        COLOR.a = border_color.a * edge_alpha;
	    } else {
	        COLOR.a = 0.0;
	    }
	}
}