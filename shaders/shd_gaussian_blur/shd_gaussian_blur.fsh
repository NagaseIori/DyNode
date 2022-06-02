//
// Simple passthrough fragment shader
//
#define pow2(x) (x * x)
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec3 size;//width,height,radius

const float pi = 6.28318530718*2.0;
int samples;
float sigma;

float gaussian(vec2 i) {
    return 1.0 / (2.0 * pi * pow2(sigma)) * exp(-((pow2(i.x) + pow2(i.y)) / (2.0 * pow2(sigma))));
}

vec3 blur(vec2 uv, vec2 scale) {
    vec3 col = vec3(0.0);
    float accum = 0.0;
    float weight;
    vec2 offset;
    
    for (int x = -samples / 2; x < samples / 2; ++x) {
        for (int y = -samples / 2; y < samples / 2; ++y) {
            offset = vec2(x, y);
            weight = gaussian(offset);
            col += texture2D( gm_BaseTexture, uv + scale * offset).rgb * weight;
            accum += weight;
        }
    }
    
    return col / accum;
}

void main()
{
    samples = int(size.z)+2;
	sigma = float(samples) * 0.25;
    vec4 color;
	vec2 ps=vec2(1.0)/size.xy;
	color.rgb=blur(v_vTexcoord, ps);
	color.a=1.0;
    gl_FragColor =  color *  v_vColour;
}