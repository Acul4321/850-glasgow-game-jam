shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform bool  shaking       = true;
uniform float jitter_pixels = 1.0;
uniform float pixel_size    = 1.0; 
uniform float noise_scale   = 20.0;
uniform float noise_speed   = 20.0;

float hash(vec2 p){ return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123); }

float noise2d(vec2 p){
    vec2 i = floor(p), f = fract(p);
    float a = hash(i + vec2(0,0));
    float b = hash(i + vec2(1,0));
    float c = hash(i + vec2(0,1));
    float d = hash(i + vec2(1,1));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a,b,u.x) + (c-a)*u.y*(1.0-u.x) + (d-b)*u.x*u.y;
}

vec2 snap_uv(vec2 uv, float chunk, vec2 pix_size){
    vec2 step_uv = pix_size * chunk;
    return floor(uv / step_uv) * step_uv + step_uv * 0.5;
}

void fragment(){
    vec2 uv = SCREEN_UV;
    vec2 screen_pixel_size = SCREEN_PIXEL_SIZE;

    float chunk = max(1.0, floor(pixel_size + 0.0001));
    vec2 pixel_uv = snap_uv(uv, chunk, screen_pixel_size);

    if (!shaking){
        COLOR = texture(SCREEN_TEXTURE, pixel_uv);
    } else {
        float t  = TIME * noise_speed;
        float n  = noise2d(uv * noise_scale + vec2(t, 0.0));
        int dir_idx = int(floor(n * 4.0)) % 4;
        vec2 dir = vec2(0.0);
        if      (dir_idx == 0) dir = vec2( 1.0,  0.0);
        else if (dir_idx == 1) dir = vec2(-1.0,  0.0);
        else if (dir_idx == 2) dir = vec2( 0.0,  1.0);
        else                   dir = vec2( 0.0, -1.0);

        float jp = round(jitter_pixels);
        vec2 jitter_uv = pixel_uv + dir * jp * screen_pixel_size * chunk;
        jitter_uv = snap_uv(jitter_uv, chunk, screen_pixel_size);

        COLOR = texture(SCREEN_TEXTURE, jitter_uv);
    }
}
