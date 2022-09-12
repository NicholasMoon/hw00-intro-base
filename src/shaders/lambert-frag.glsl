#version 300 es

// This is a fragment shader. If you've opened this file first, please
// open and read lambert.vert.glsl before reading on.
// Unlike the vertex shader, the fragment shader actually does compute
// the shading of geometry. For every pixel in your program's output
// screen, the fragment shader is run for every bit of geometry that
// particular pixel overlaps. By implicitly interpolating the position
// data passed into the fragment shader by the vertex shader, the fragment shader
// can compute what color to apply to its pixel based on things like vertex
// position, light position, and vertex color.
precision highp float;
precision highp int;

uniform vec4 u_Color; // The color with which to render this instance of geometry.
uniform int u_Time;

// These are the interpolated values out of the rasterizer, so you can't know
// their specific values without knowing the vertices that contributed to them
in vec4 fs_Pos;
in vec4 fs_Nor;
in vec4 fs_LightVec;
in vec4 fs_Col;

out vec4 out_Col; // This is the final output color that you will see on your
                  // screen for the pixel that is currently being processed.
				  
float noiseFunction3(vec3 input_vals) {
	return fract(sin(dot(input_vals, vec3(1340.11f, 1593.46f, 942.25f))) * 38945.13f);
}


		

void main()
{
	float myTime = float(u_Time) / 50.0f;

    // Material base color (before shading)
		//float noise_Pos = vec3(1,1,1);
		//vec3 noise_Pos_vec3 = vec3(noise_Pos, noise_Pos, noise_Pos);
        vec4 diffuseColor = vec4(u_Color.xyz, 1.0f);
		//vec4 diffuseColor = vec4(u_Color.xyz, 1.0f);
		
        // Calculate the diffuse term for Lambert shading
        float diffuseTerm = dot(normalize(fs_Nor), normalize(fs_LightVec));

        float ambientTerm = 0.2;

        float lightIntensity = diffuseTerm + ambientTerm;   //Add a small float value to the color multiplier
                                                            //to simulate ambient lighting. This ensures that faces that are not
                                                            //lit by our point light are not completely black.

        // Compute final shaded color
        out_Col = vec4(diffuseColor.rgb * lightIntensity, diffuseColor.a);
}
