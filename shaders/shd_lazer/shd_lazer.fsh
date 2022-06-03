//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	vec2 uv = v_vTexcoord;
	vec4 base_col = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	// Linear Drop
	float bri = uv.y;
	base_col = vec4(1., 1., 1., bri);
	//base_col *= v_vColour;
	
    gl_FragColor = base_col;
}
