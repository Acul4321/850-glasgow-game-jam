shader_type canvas_item;

uniform bool enabled = true;
uniform float border_width = 0.02; // Border thickness in UV space
uniform float blur = 0.01; // Blur amount for all edges (0.0 = sharp, >0.0 = softer)
uniform float corner_radius = 0.05; // Corner radius in UV space (0.0 = sharp, >0.0 = rounded)
uniform float dash_length = 0.1; // Length of each dash in UV space
uniform float dash_gap = 0.05; // Gap between dashes in UV space
uniform float speed = 1.0; // Animation speed
uniform vec4 border_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Border color

void fragment() {
	if (enabled) {
    vec2 uv = UV;
    vec2 center = vec2(0.5, 0.5);
    vec2 size = vec2(0.5, 0.5); // Rectangle half-size (width, height) in UV space

    // Calculate signed distance to a rounded rectangle
    vec2 d = abs(uv - center) - size + vec2(corner_radius);
    float dist = min(max(d.x, d.y), 0.0) + length(max(d, 0.0)) - corner_radius;

    // Calculate perimeter position for continuous dashing
    vec2 pos = uv - center;
    float t = 0.0;
    float perimeter = 2.0 * (size.x + size.y); // Approximate perimeter (adjusted for rounding)

    // Determine the segment and compute normalized perimeter position
    vec2 abs_pos = abs(pos);
    float u = 0.0;
    if (abs_pos.x > abs_pos.y) {
        if (pos.x > 0.0) {
            // Right edge
            u = (pos.y + size.y) + size.x;
        } else {
            // Left edge
            u = (size.y - pos.y) + 3.0 * size.x;
        }
    } else {
        if (pos.y > 0.0) {
            // Top edge
            u = (size.x - pos.x);
        } else {
            // Bottom edge
            u = (pos.x + size.x) + 2.0 * size.x;
        }
    }

    // Adjust perimeter for rounded corners (approximation)
    perimeter += 2.0 * 3.141592 * corner_radius * 0.5; // Add corner arc lengths
    u = fract(u / perimeter + TIME * speed);

    // Dash pattern
    float dash_cycle = dash_length + dash_gap;
    float pattern_pos = mod(u * perimeter, dash_cycle);

    // Apply blur to all edges of the border
    float edge_alpha = smoothstep(border_width + blur, border_width - blur, abs(dist));

    // Ensure the border is fully blurred across its width
    float border_mask = step(abs(dist), border_width + blur);

    // Combine dash pattern and blurred border
    if (pattern_pos < dash_length && border_mask > 0.0) {
        COLOR.rgb = border_color.rgb;
        COLOR.a = border_color.a * edge_alpha;
    } else {
        COLOR.a = 0.0; // Transparent for gaps and outside border
    }
	}
}