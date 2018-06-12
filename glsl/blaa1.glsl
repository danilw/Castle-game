#version 300 es
#ifdef GL_ES
 precision highp float;
#endif
uniform float rot;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture1;
uniform float u_time;
uniform vec2 pos;
out vec4 glFragColor;

#define iTime u_time
#define iResolution u_resolution
#define iChannel0 u_texture1
#define iMouse u_mouse

// Horizontal bloom blur

// Dedicated to the public domain under CC0 1.0 Universal
//  https://creativecommons.org/publicdomain/zero/1.0/legalcode

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec3 acc = vec3(0.0);
    
    vec2 uv = fragCoord.xy / iResolution.xy;
    
    // Manually expanded weights/iteration to please inferior shader compilers
    const int steps = 7;
    const float weights0 = 0.00598;
    const float weights1 = 0.060626;
    const float weights2 = 0.241843;
    const float weights3 = 0.383103;
    const float weights4 = 0.241843;
    const float weights5 = 0.060626;
    const float weights6 = 0.00598;
    
    vec2 direction = vec2(1.0, 0.0);
    
    vec2 offset0 = direction * float(0 - steps / 2) / iResolution.xy;
    acc += texture(iChannel0, uv + offset0).xyz * weights0;
    vec2 offset1 = direction * float(1 - steps / 2) / iResolution.xy;
    acc += texture(iChannel0, uv + offset1).xyz * weights1;
    vec2 offset2 = direction * float(2 - steps / 2) / iResolution.xy;
    acc += texture(iChannel0, uv + offset2).xyz * weights2;
    vec2 offset3 = direction * float(3 - steps / 2) / iResolution.xy;
    acc += texture(iChannel0, uv + offset3).xyz * weights3;
    vec2 offset4 = direction * float(4 - steps / 2) / iResolution.xy;
    acc += texture(iChannel0, uv + offset4).xyz * weights4;
    vec2 offset5 = direction * float(5 - steps / 2) / iResolution.xy;
    acc += texture(iChannel0, uv + offset5).xyz * weights5;
    vec2 offset6 = direction * float(6 - steps / 2) / iResolution.xy;
    acc += texture(iChannel0, uv + offset6).xyz * weights6;
    
    fragColor = vec4(acc, 1.0);
}

void main() {
	vec4 fc;
	mainImage(fc,vec2(gl_FragCoord.x,gl_FragCoord.y));
	glFragColor=fc;
}
