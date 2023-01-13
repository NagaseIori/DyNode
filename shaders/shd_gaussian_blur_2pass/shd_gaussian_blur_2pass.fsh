#define pow2(x) (x * x)
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec4 size;//width,height,radius,sigma
uniform vec2 blur_vector;

const float pi = 6.28318530718*2.0;
int samples;
float sigma;

float gaussian(float i) {
    return 1.0 / sqrt(2.0 * pi * pow2(sigma)) * exp(-pow2(i) / (2.0 * pow2(sigma)));
}

vec3 blur(vec2 uv, vec2 scale) {
    vec3 col = vec3(0.0);
    float accum = 0.0;
    float weight;
	float offset;
    
	weight = gaussian(0.);
	col += texture2D( gm_BaseTexture, uv).rgb * weight;
	accum = weight;
	
    for (int x = 1; x < samples / 2; ++x) {
		offset = float(x);
        weight = gaussian(offset);
        col += texture2D( gm_BaseTexture, uv + scale * blur_vector * offset).rgb * weight;
		col += texture2D( gm_BaseTexture, uv - scale * blur_vector * offset).rgb * weight;
        accum += weight * 2.;
    }
    
    return col / accum;
}

void main()
{
    samples = int(size.z)+2;
	sigma = size.w;
    vec4 color;
	vec2 ps=vec2(1.0)/size.xy;
	color.rgb=blur(v_vTexcoord, ps);
	color.a=1.0;
    gl_FragColor =  color *  v_vColour;
}
