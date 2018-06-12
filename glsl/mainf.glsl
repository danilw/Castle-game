#version 300 es
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform sampler2D u_texture1;
uniform sampler2D u_texture2;
uniform	bool backgroundVisible;
uniform	vec4 backgroundclicktimer;
uniform	float backgroundtime;
uniform vec2 backgoundClickpos1;
uniform vec2 backgoundClickpos2;
uniform vec2 backgoundClickpos3;
uniform vec2 backgoundClickpos4;
out vec4 glFragColor;

// License Creative Commons Attribution-NonCommercial-ShareAlike

#define PI (4.0 * atan(1.0))
#define TAU (2.*PI)
#define rotate2d(a) mat2(cos(a), -sin(a), sin(a), cos(a))

#define iTime u_time
#define iResolution u_resolution
#define iChannel0 u_texture1
#define iChannel1 u_texture2
#define iMouse vec2(500.,500.)

// copied from iq
vec3 iq_color_palette(vec3 a, vec3 b, vec3 c, vec3 d, float t)
{
    return a + b * cos(TAU * (c*t + d));
}

// copied from iq
// https://www.shadertoy.com/view/Xd2GR3
// { 2d cell id, distance to border, distance to center )
vec4 hexagon( vec2 p ) 
{
	vec2 q = vec2( p.x*2.0*0.5773503, p.y + p.x*0.5773503 );
	
	vec2 pi = floor(q);
	vec2 pf = fract(q);

	float v = mod(pi.x + pi.y, 3.0);

	float ca = step(1.0,v);
	float cb = step(2.0,v);
	vec2  ma = step(pf.xy,pf.yx);
	float e = dot( ma, 1.0-pf.yx + ca*(pf.x+pf.y-1.0) + cb*(pf.yx-2.0*pf.xy) );
	p = vec2( q.x + floor(0.5+p.y/1.5), 4.0*p.y/3.0 )*0.5 + 0.5;
	float f = length( (fract(p) - 0.5)*vec2(1.0,0.85) );		
	
	return vec4( pi + ca - cb*ma, e, f );
}

// copied from iq
float hash1( vec2  p ) { float n = dot(p,vec2(127.1,311.7) ); return fract(sin(n)*43758.5453); }

// copied from iq
float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);
	f = f*f*(3.0-2.0*f);
	vec2 uv = (p.xy+vec2(37.0,17.0)*p.z) + f.xy;
	vec2 rg = textureLod( iChannel0, (uv+0.5)/256.0, 0.0 ).yx;
	return mix( rg.x, rg.y, f.z );
}

float ring(vec2 px,vec2 cx,float timex){
    float radius=0.3*timex;
    vec2 p = ( 2.*px - iResolution.xy ) / iResolution.y;
    cx.y=iResolution.y-cx.y;
    vec2 center = ( 2.*cx.xy - iResolution.xy ) / iResolution.y;
    float u_Thickness = -0.+0.14*timex;
    float l = length(p - center);        
    float a = 1.-smoothstep( 4./ iResolution.y, 0.05+0.6*timex, abs(l-radius) + u_Thickness/2. ); 
    return a;
}
#define m2 vec3(.41176,.53333,.78431)
vec4 menubackground( in vec2 fragCoord ) 
{
    vec2 uv = (fragCoord.xy/iResolution.xy);
    if(backgroundVisible){
    
	vec2 pos = (-iResolution.xy + 2.0*fragCoord.xy)/iResolution.y;
	
    float t = .8 * (1. - pow(uv.y, .5));
    pos.y += -.5;
    pos *= 1.5 - 0.3*pos.y;
    
    vec4 h = vec4(0.);
    float n = 0.;
    vec3 col = vec3(0.);

	h = hexagon(12.0*pos);
    n = noise( vec3(0.3*h.xy+vec2(iTime*.7, 0.),0.) );
    float ax=ring(fragCoord,backgoundClickpos1,backgroundclicktimer.x)*(1.-h.a)*smoothstep(2.2,0.5,backgroundclicktimer.x);
    ax=max(ax,ring(fragCoord,backgoundClickpos2,backgroundclicktimer.y)*(1.-h.a)*smoothstep(2.2,0.5,backgroundclicktimer.y));
    ax=max(ax,ring(fragCoord,backgoundClickpos3,backgroundclicktimer.z)*(1.-h.a)*smoothstep(2.2,0.5,backgroundclicktimer.z));
    ax=max(ax,ring(fragCoord,backgoundClickpos4,backgroundclicktimer.a)*(1.-h.a)*smoothstep(2.2,0.5,backgroundclicktimer.a));
    n+=ax;
    t += .2 * (1. - n);
    
	col = .5 * abs(sin( hash1(h.xy)*.4 + 1.6 + vec3(1.) ));
	col *= smoothstep( 0.0+t, 0.1+t, h.z );
	col *= 1. + 0.5*h.z*n;        	
    col *= 1. + .5 * iq_color_palette(vec3(0.5, 0.5, 0.5),
                                 vec3(0.5, 0.5, 0.5),
                                 vec3(.0, 1.0, 2.0),
                                 vec3(0.25, 0.2, 0.55),
                                 iTime *.02);
    col *= .7 + .3 * iq_color_palette(vec3(.5, .5, .5),
                                      vec3(.5, .5, .5),
                                      vec3(.3, 1., 1.),
                                      vec3(0., .25, .325),                               
	        uv.y-.8-iTime*.05);
	col *= pow( 16.0*uv.x*(1.0-uv.x)*uv.y*(1.0-uv.y), 0.4 );    
    
    vec2 q = uv;
    uv = 0.5 + (q-0.5)*(0.830 - 0.1*(n*2.));
    vec4 tc=vec4( m2*min(vec3(8.),col*8.5), 1.0 )*(n*1.5);

    vec3 oricol = texture( iChannel1, vec2(q.x,q.y) ).xyz;
    
    col.r = texture(iChannel1,vec2(uv.x+0.0023,uv.y)).x*(1.-n/2.5);
    col.g = texture(iChannel1,vec2(uv.x+0.000,uv.y)).y*(1.-n/2.5);
    col.b = texture(iChannel1,vec2(uv.x-0.0023,uv.y)).z*(1.-n/2.5);

    col = clamp(col*0.5+0.5*col*col*1.2,0.0,1.0);

    col *= 0.5 + 0.5*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y);

    col *= vec3(0.95,01.05,0.95);

    col *= 0.9+0.1*sin(10.0*iTime+uv.y*1000.0);

    col *= 0.99+0.01*sin(1.0*iTime);
    

    float comp = smoothstep( 0.2, 0.7, 1.-backgroundtime);
    col = mix( col, oricol, clamp(-2.0+2.0*q.x+3.0*comp,0.0,1.0) );
    return tc*(1.-clamp(-2.0+2.0*q.x+3.0*comp,0.0,1.0))+vec4(col,1.0);
    
}
    return texture(iChannel1,vec2(uv.x,uv.y));
}



void main() {
    glFragColor=menubackground(gl_FragCoord.xy);
}
