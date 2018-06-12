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
uniform vec2 playerpos;

#define iTime u_time
#define iResolution u_resolution
#define iChannel0 u_texture1
#define iMouse u_mouse

#define rot2d(a) mat2(cos(a), -sin(a), sin(a), cos(a))

#define PI (4.0 * atan(1.0))
#define TWO_PI PI*2.

// License Creative Commons Attribution-NonCommercial-ShareAlike

float shapeb(vec2 uv, int v)
{
  int N=4;
  vec2 uv2=uv;
  vec3 c=vec3(1.);
  if(v==2){N=3;uv*=.7;}
  if(v==1){N=4;uv*=.5;}
  if(v==0){N=104;uv*=.5;}
  float color = 0.0;
  float d = 0.0;
  float a = atan(uv.x,uv.y)+PI;
  float rx = TWO_PI/float(N);
  d = cos(floor(.5+a/rx)*rx-a)*length(uv);
  color = smoothstep(.154,.4865,d);
  return color;
}


float opU(float a, float b)
{
	return min(a, b);   
}

vec4 mi(vec2 fc){
	vec4 rt= vec4(.5,0.,0.,1.);
	fc*=3.;
	vec2 pfc=-vec2(playerpos.x,iResolution.y-playerpos.y)*3.+iResolution.xy/2.;
	fc+=pfc;
	vec2 res = iResolution.xy / iResolution.y;
	vec2 uv = fc.xy / iResolution.y - res/2.0;
	float d = 0.5;
	float fg2=shapeb((uv)*rot2d(-rot),0);
	d=opU(fg2,d);
	rt.r=d;
	return rt;
}

void main() {
glFragColor=mi(vec2(gl_FragCoord.x,gl_FragCoord.y));
}
