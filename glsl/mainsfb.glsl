#version 300 es
#ifdef GL_ES
 precision highp float;
#endif
uniform float rot;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture1;
uniform sampler2D u_texture2;
uniform float u_time;
uniform vec2 pos;
out vec4 glFragColor;

// License Creative Commons Attribution-NonCommercial-ShareAlike

#define iTime u_time
#define iResolution u_resolution
#define iChannel0 u_texture1
#define iChannel1 u_texture2
#define iMouse u_mouse

//https://www.shadertoy.com/view/XsK3RR

#define NUM_LIGHTS 6
#define WALL_COLOR vec3(1.0, 0.5, 0.1)
#define FLOOR_COLOR vec3(0.4, 0.4, 0.4)
#define AMBIENT_LIGHT vec3(0.1, 0.1, 0.1)
//#define SHOW_SHADOWMAP

#define INF 1e8
#define EPS 1e-3
float tau = atan(1.0)*8.0;

//Globals
vec2 res = vec2(0); //Y-Normalized resolution
float psz = 0.0; //Pixel size
vec2 hpo = vec2(0); //Half pixel offset

vec3 Scene(vec2 uv)
{
    uv.x *=  1./(iResolution.x / iResolution.y);
    uv+=.5;
    return texture(iChannel1,uv).rgb;
}

vec2 LightOrigin(int id)
{
	return texture(iChannel0,vec2(0, float(id))/vec2(iResolution.x,5.) + hpo).yz;   
}

vec3 LightColor(int id)
{
	return texture(iChannel0,vec2(1, float(id))/vec2(iResolution.x,5.) + hpo).yzw;   
}

float SampleShadow(int id, vec2 uv)
{
    float a = atan(uv.y, uv.x)/tau + 0.5;
    float r = length(uv);
    
    float idn = float(id)/5.;
    
    float s = texture(iChannel0, vec2(a, idn) + hpo).x;
    
    return 1.0-smoothstep(s, s+0.02, length(uv));    
}

//Reads lights from light buffer and combines them.
vec3 MixLights(vec2 uv)
{
    vec3 b = AMBIENT_LIGHT;
    
	for(int i = 0;i < NUM_LIGHTS;i++)
    {
        vec2 o = LightOrigin(i);
        vec3 c = LightColor(i);
        
        float l = 0.01 / pow(length(vec3(uv - o, 0.1)), 2.0);
        l *= SampleShadow(i, uv-o);
        b += c * l;
    }
    
    return b;
}

vec4 mi(in vec2 fragCoord )
{
    hpo = 0.5 / vec2(iResolution.x,5.);
    res = iResolution.xy / iResolution.y;
    psz = 0.001;
	vec2 uv = fragCoord.xy / iResolution.y - res/2.0;
    
    
    vec3 col = vec3(0);
    
    vec3 tx = Scene(uv);
    float d = tx.r;
    vec3 cxx=vec3(tx.g/2.,tx.gb);
    col=cxx;
    col *= MixLights(uv);
    
    #ifdef SHOW_SHADOWMAP
    col = texture(iChannel0, fragCoord/iResolution.xy).rgb;
    #endif
	return vec4(col, 1.0);
} 


void main() {
    glFragColor=mi(vec2(gl_FragCoord.x,gl_FragCoord.y));
}
