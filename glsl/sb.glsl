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
uniform vec2 fkres;
const int maxlgth = 200;
uniform float lposx[maxlgth];
uniform float lposy[maxlgth];
uniform float ttlx[maxlgth];
uniform int numlgths;
out vec4 glFragColor;

// License Creative Commons Attribution-NonCommercial-ShareAlike

#define iTime u_time
#define iResolution u_resolution
#define iChannel0 u_texture1
#define iChannel1 u_texture2
#define iMouse u_mouse

//1D Distance field shadow map.
//Each row is a radial shadow map for a light.
//r = distance
//gba = light info (position / color)

#define MAX_STEPS 68 // 68*steep size=maxraydist
#define INF 1e8
#define EPS 1e-4
//red
#define m1 vec3(.82352,.35294,.34901) 
//blue
#define m2 vec3(.41176,.53333,.78431)
//pink
#define m3 vec3(.78431,.49411,.70196)
//green
#define m4 vec3(.19607,.79215,.56078)

//red
#define m111 vec3(.48235,.19607,.96862) 
//blue
#define m222 vec3(.56078,.78823,.87843)
//white
#define m333 vec3(.96470,.90196,.88392)
//green
#define m444 vec3(.53725,.79215,.48627)

float tau = atan(1.0)*8.0;

//Globals
vec2 res = vec2(0);
vec2 me = vec2(0);

float Scene(vec2 uv)
{
    uv.x *=  1./(1366./768.);
    uv+=.5;
    return (texture(iChannel1,1.-uv).r)/30.;
}

float MarchShadow(vec2 orig, vec2 dir)
{
    float d = 0.0;
    
    for(int i = 0;i < MAX_STEPS;i++)
    {
        float ds = Scene(dir * d - orig);
        
        d += ds;
        
        if(ds < EPS)
        {
        	break;   
        }
    }
    
    return d;
}

//Data slots
#define SLOT_POSITION 0
#define SLOT_COLOR 1

struct Light
{
	vec2 origin;
    vec3 color;
    float brightness;
    
};

vec4 mi(in vec2 fragCoord )
{
	
    res = fkres.xy / fkres.y;  
    float a = (fragCoord.x / iResolution.x) * tau;
    vec2 dir = vec2(cos(a), sin(a));
    
    int id = int(fragCoord.y);
    if(numlgths+4-1<id)discard;
    float v=(mod(iTime,40.));
    
    Light light;
    
    light.origin = vec2(0);
    light.color = vec3(0);
    light.brightness = 0.0;
    
    vec3 c1=m4;
    vec3 c2=m222;
    vec3 c3=m3;
    vec3 c4=m444;
    
    if(id == 0)
    {
    	light.origin = vec2(0.45,0.55);
        light.color = c1;
        light.brightness = .10+2.5*smoothstep(0.,5.,v)*smoothstep(10.,5.,v)*(sin(1.+cos(iTime/2. ))) ;
    }
    else
    if(id == 1)
    {
    	light.origin = vec2(0.35,0.55);
        light.color = c2;
        light.brightness = .10+2.5*smoothstep(10.,15.,v)*smoothstep(20.,15.,v)*(sin(1.+cos(iTime/2. +3.))) ;
    }
    else
    if(id == 2)
    {
    	light.origin = vec2(0.25,0.55);
        light.color = c3;
        light.brightness = .10+2.5*smoothstep(20.,25.,v)*smoothstep(30.,25.,v)*(sin(1.+cos(iTime/2. +2.))) ;
    }
    else
    if(id == 3)
    {
        light.origin = vec2(0.15,0.55);
        light.color = c4;
        light.brightness = .10+2.5*smoothstep(30.,35.,v)*smoothstep(40.,35.,v)*(sin(1.+cos(iTime/2. -3.))) ;
    }else{
		
		for(int iy=0;iy<numlgths;iy++){
			if((id == iy+4))
			{	me = vec2(lposx[iy],fkres.y-lposy[iy]) / fkres.y - res/2.0;
				light.origin = me; 
				light.color = m1*(1.-ttlx[iy])*1.5+m2*ttlx[iy];
				light.brightness = 1.3+1.-ttlx[iy];
				break;
			}
		}
	}
    
    
    int slot = int(fragCoord.x);
    vec3 data = vec3(0);
    if(slot == SLOT_POSITION)
    {
        data = vec3(light.origin,0);
    }
    
    if(slot == SLOT_COLOR)
    {
    	data = light.brightness * light.color;   
    }
    
    float dist = MarchShadow(light.origin, dir);
     
	return vec4(dist, data);
} 



void main() {
    glFragColor=mi(vec2(gl_FragCoord.x,gl_FragCoord.y));
//glFragColor=vec4(1.,0.,0.,0.5);
}
