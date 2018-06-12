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
uniform int viuu;
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
  if(v==2){N=3;uv*=.7;}
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

float shape(vec2 uv, int v)
{
  int N=4;
  uv*=33.85;
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
  color = smoothstep(.1824,.465,d);
  return color;
}

float opU(float a, float b)
{
	return min(a, b);   
}

float line(vec2 p, vec2 a, vec2 b)
{
     p*=3.;
     a*=2.58/33.85;
     b*=2.58/33.85;
     vec2 a2b = b - a;
     vec2 a2p = p - a;     
     float h = clamp( dot(a2p,a2b)/dot(a2b,a2b), 0.0, 1.0 );
     vec2 p1 = mix( a, b, h );
     return length( p1 - p )/5.;
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
        
        float fg2=shapeb((uv+im+im*vec2(0.,0.1213)/33.85)*rot2d(-rot),viuu);
        float fg=0.;
        if(viuu==2){fg=shapeb((uv+im)*rot2d(-rot),1);d=opU(fg2/1.5+fg/20.,d);}else{d=opU(fg2,d);}
        if(viuu==2)if(d>0.2448)discard;
        if(d>0.448)discard;
        vec2 col=vec2(0.);
        col=vec2(d,d);
        if(viuu==1)
        {
            uv=(uv+im)*rot2d(-rot);
            fg=shape(uv,viuu);
            float t = line(abs(uv), vec2(1.,1.),vec2(0.,1.0));
            float t2= line(abs(uv), vec2(1.,1.),vec2(1.,0.0));
            col = vec2(0.15, 1.0)*0.02/t;
            col += vec2(0.15, 1.0)*0.02/t2;
            col*=smoothstep(.40,0.,(d)*fg)*2.*smoothstep(.0,0.25,(1.-d)*fg);
        }else
        if(viuu==2)
        {       
            uv=(uv+im+im*vec2(0.,0.1213)/33.85)*rot2d(-rot);
            fg=shape(uv,viuu);
            float t = line((uv), vec2(-1.,-1.),vec2(1.,-1.));
            float t2= line(vec2(abs(uv.x),uv.y), vec2(1.,-1.),vec2(.0,1.));
            col = vec2(0.15, 1.0)*0.02/t;
            col += vec2(0.15, 1.0)*0.02/t2;
            col*=smoothstep(.21,0.,(d)*fg)*2.*smoothstep(.0,0.2,(1.-d)*fg);
            
        }else
        if(viuu==0)
        {
            uv=(uv+im)*rot2d(-rot);
            col=vec2(0.815,3.5);
            col=5.*col*smoothstep(1./38.*0.6,1./38.*0.7,length(uv))*smoothstep(1./38.*1.,1./38.*0.85,length(uv));
        }
        
	return vec4(d,col,1.);

    }
	discard;
}

void main() {
    glFragColor=mi2(vec2(gl_FragCoord.x,u_resolution.y-gl_FragCoord.y));
//glFragColor=vec4(1.,0.,0.,0.5);
}
