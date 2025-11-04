shader_type canvas_item;
render_mode unshaded;

// Circle parameters
uniform vec2 center = vec2(0.5, 0.5);
uniform float radius : hint_range(0.0, 1.0) = 0.25;
uniform float smoothness : hint_range(0.0, 0.5) = 0.02;

// Aspect correction
uniform float ratio_width : hint_range(0.0, 4.0) = 1.0;
uniform float ratio_height : hint_range(0.0, 4.0) = 1.0;

void fragment() {
    // Use SCREEN_UV for full-screen consistent coordinates
    vec2 uv = SCREEN_UV;

    // Center and scale
    vec2 centered = uv - center;

    // Apply ratio adjustments — correct ellipse distortion
    centered.x *= ratio_width;
    centered.y *= ratio_height;

    // Distance from center
    float dist = length(centered);

    // Smooth edge (0 = inside/transparent, 1 = outside/black)
    float alpha = smoothstep(radius - smoothness, radius, dist);

    // Black overlay with transparent circle
    COLOR = vec4(0.0, 0.0, 0.0, alpha);
}
