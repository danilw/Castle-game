#version 300 es
#ifdef GL_ES
 precision highp float;
#endif
uniform float rot;
uniform float ttl;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture1;
uniform float u_time;
uniform vec2 pos;
uniform int viuu;
uniform bool isspwnr;
out vec4 glFragColor;

// License Creative Commons Attribution-NonCommercial-ShareAlike

#define iTime u_time
#define iResolution u_resolution
#define iChannel0 u_texture1
#define iMouse u_mouse

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


#define rot2d(a) mat2(cos(a), -sin(a), sin(a), cos(a))

#define PI (4.0 * atan(1.0))
#define TWO_PI PI*2.

float shapeb(vec2 uv, int v)
{
  int N=4;
  uv*=33.85;
  vec2 uv2=uv;
  vec3 c=vec3(1.);
  if(v==2){N=3;uv.y+=0.213;uv*=.7;}
  if(v==1){N=4;uv*=.5;}
  if(v==0){N=104;uv*=.5;}
  float color = 0.0;
  float d = 0.0;
  float a = atan(uv.x,uv.y)+PI;
  float rx = TWO_PI/float(N);
  d = cos(floor(.5+a/rx)*rx-a)*length(uv);
  color = smoothstep(.24,.65,d);
  return color;
}

float opU(float a, float b)
{
	return min(a, b);   
}

vec4 uuu(vec2 U)
{
    vec4 O=vec4(0.,0.,0.,1.);
    vec2 uv =U*33.85;
	vec3 light_color = vec3(0.09, 0.065, 0.185);
	float light = 0.0;
	
	light = 01.1 / distance(normalize(uv), uv);


	O = vec4(vec3(light_color.rg,light*light_color.b), 1.0);
    return O;
}

#define MAX_ITER 8
vec4 cvb( vec2 fc ) {
    vec2 p=fc*33.85;
	vec2 i = p;
	float c = 0.2;
	float inten = 1.0;
    float time=iTime/1.5;

	for (int n = 1; n < MAX_ITER; n++) {
		float t = time * (1.0 - (1.0 / float(n+1)));
		i = p + vec2(
			cos(t - i.x) + sin(t + i.x), 
			sin(t - i.x) + cos(t + i.y)
		);
		c += 1.0/length(vec2(
			p.x / (sin(i.x+t)/inten),
			p.y / (cos(i.y+t)/inten)
			)
		);
	}
	c /= float(MAX_ITER);
	
	return vec4(vec3(pow(c,3.7))*vec3(0.44, 0.65, 1.53), 1.45)*smoothstep(1.,.58,length(p));
}



vec4 mi2( in vec2 fragCoord )
{
    vec2 res = iResolution.xy / iResolution.y;
    vec2 uv = (fragCoord.xy) / iResolution.y - res/2.0;
    vec2 im=(pos)/iResolution.xy;
    im-=.5;
    im.x *=  (iResolution.x / iResolution.y);
    {
        float d=0.45;
        float fg2=shapeb((uv+im)*rot2d(-rot),0);
        d=opU(fg2,d);
        vec3 col=vec3(0.);
        col=(cvb((uv+im)*rot2d(-rot))).rgb;
        col=col.bgr*vec3(1.,1.,-1.);
        col.b+=col.r*ttl*1.3;
        col.r+=-0.25*col.r*ttl;
        if(isspwnr)col*=ttl;
        if(d>0.448)discard;
	return vec4(col,1.);

    }
	discard;
}

void main() {
    glFragColor=mi2(vec2(gl_FragCoord.x,u_resolution.y-gl_FragCoord.y));
//glFragColor=vec4(1.,0.,0.,0.5);
}
