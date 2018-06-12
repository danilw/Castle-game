#version 300 es
#ifdef GL_ES
 precision highp float;
#endif
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture1;
uniform sampler2D u_texture2;
uniform sampler2D u_texture3;
uniform float u_time;
uniform float playervtime;
out vec4 glFragColor;
uniform int numlgths;
uniform int maxlgth;
uniform bool sdwsxd;
uniform bool fxaa;
uniform bool isdead;
uniform vec2 playerpos;
uniform int plhp;

// License Creative Commons Attribution-NonCommercial-ShareAlike

#define iTime u_time
#define iResolution u_resolution
#define iChannel0 u_texture1
#define iChannel1 u_texture2
#define iChannel2 u_texture3
#define iMouse u_mouse

#define maxlgth_d maxlgth+4

//Calculate the squared length of a vector
float length2(vec2 p){
    return dot(p,p);
}

//Generate some noise to scatter points.
float noise(vec2 p){
	return fract(sin(fract(sin(p.x) * (43.13311)) + p.y) * 31.0011);
}

float worley(vec2 p) {
    //Set our distance to infinity
	float d = 1e30;
    //For the 9 surrounding grid points
	for (int xo = -1; xo <= 1; ++xo) {
		for (int yo = -1; yo <= 1; ++yo) {
            //Floor our vec2 and add an offset to create our point
			vec2 tp = floor(p) + vec2(xo, yo);
            //Calculate the minimum distance for this grid point
            //Mix in the noise value too!
			d = min(d, length2(p - tp - noise(tp)));
		}
	}
	return 3.0*exp(-4.0*abs(2.5*d - 1.0));
}

float fworley(vec2 p) {
    //Stack noise layers 
    float iTime=0.31*iTime;
	return sqrt(sqrt(sqrt(
		worley(p*5.0 + 0.05*iTime) *
		sqrt(worley(p * 50.0 + 0.12 + -0.1*iTime)) *
		sqrt(sqrt(worley(p * -10.0 + 0.03*iTime))))));
}
      

vec4 mi2( in vec2 fragCoord )
{
	
    vec4 fragColor;
    vec2 uv = fragCoord.xy / iResolution.xy*1.25+0.8625;
    //Calculate an intensity
    float t = fworley(uv * iResolution.xy / 1500.0);
    //Add some gradient
    t*=exp(-length2(abs(0.7*uv - 1.0)));	
    //Make it blue!
    fragColor = vec4(t * vec3(0.1, 1.1*t, pow(t, 0.5-t)), 1.0);
	//fragColor = vec4(t * vec3(0.0, 1.8*t, 1.1 + 4.*pow(t, 2.-t)), 1.);
    //fragColor *= 1.0 - 0.8*fragColor*step(uv.y,0.33);
	fragColor *= mix(fragColor.b/2.5+fragColor.g/2.,1.0,0.);
    fragColor *= mix(fragColor.b,1.0,1.-1.);
	

    return fragColor;
}

#define PI (4.0 * atan(1.0))

float Pyramid(vec2 uv, float t)
{
    float r = 2.0*t*pow(1.0 - length(uv)/sqrt(2.0), 1.5);
    
    uv = mat2(cos(r),sin(r),-sin(r),cos(r))*uv;
    
    uv = abs(uv)/sqrt(2.0);
    return max(uv.x, uv.y);
}


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

vec4 vxc(in vec2 fragCoord ,float cs, float time) {
    time+=iTime;
    fragCoord=(fragCoord.x>iResolution.x/2.)?fragCoord+iResolution.x*0.0055:fragCoord;
    vec2 resolution=iResolution.xy;
    vec2 uv0 = 2.0*(fragCoord - 0.5*iResolution.xy)/iResolution.y+vec2(0.385250,-0.1255);
    uv0*=.79931105;
    uv0.x*=.9819981;

	vec2 p =uv0;
	float ratio = (resolution.y)/(resolution.x);
	vec2 p0 = p + vec2((0. + 0.)/3.0);
	vec2 q = mod(p0,0.2)-0.1;
	vec2 r = vec2(p.x*ratio/2.0+0.5,p.y/2.0+0.5);
	float f = 0.0002 / (abs(q.y) * abs(q.x));
	float t1 = cos(time)/2.2+01.5;
	float t2 = sin(time)/2.2+01.5;
	return vec4(vec3(f*t2,f*r.x*t1*t2,f*r.y*r.x), 1.0)*cs;
}

vec4 vxc2(in vec2 fragCoord ,float time) {
    time+=iTime;
    //fragCoord=(fragCoord.x>iResolution.x/2.)?fragCoord+iResolution.x*0.0055:fragCoord;
    vec2 resolution=iResolution.xy;
    vec2 uv0 = 2.0*(fragCoord - 0.5*iResolution.xy)/iResolution.y+vec2(0.378250,-0.1255);
    uv0*=.79931105;
    uv0.x*=.9819981;

	vec2 p =uv0;
	float ratio = (resolution.y)/(resolution.x);
	vec2 p0 = p + vec2((0. + 0.)/3.0);
	vec2 q = mod(p0,0.2)-0.1;
	vec2 r = vec2(p.x*ratio/2.0+0.5,p.y/2.0+0.5);
	float f = 0.0002 / (abs(q.y) * abs(q.x));
	float t1 = cos(time)/2.2+01.5;
	float t2 = sin(time)/2.2+01.5;
	return vec4(vec3(f*t2,f*r.x*t1*t2,f*r.y*r.x), 1.0);
}

float rayStrength(vec2 raySource, vec2 rayRefDirection, vec2 coord, float seedA, float seedB, float speed)
{
	vec2 sourceToCoord = coord - raySource;
	float cosAngle = dot(normalize(sourceToCoord), rayRefDirection);
	
	return clamp(
		(0.45 + 0.15 * sin(cosAngle * seedA + iTime * speed)) +
		(0.3 + 0.2 * cos(-cosAngle * seedB + iTime * speed)),
		0.0, 1.0) *
		clamp((iResolution.x - length(sourceToCoord)) / iResolution.x, 0.5, 1.0);
}

vec4 zxc(in vec2 fragCoord)
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	uv.y = 1.0 - uv.y;
	vec2 coord = vec2(fragCoord.x, iResolution.y - fragCoord.y);
	
	
	// Set the parameters of the sun rays
	vec2 rayPos1 = vec2(iResolution.x * 0.7, iResolution.y * -0.4);
	vec2 rayRefDir1 = normalize(vec2(1.0, -0.116));
	float raySeedA1 = 36.2214;
	float raySeedB1 = 21.11349;
	float raySpeed1 = .5;
	
	vec2 rayPos2 = vec2(iResolution.x * 0.8, iResolution.y * -0.6);
	vec2 rayRefDir2 = normalize(vec2(1.0, 0.241));
	const float raySeedA2 = 22.39910;
	const float raySeedB2 = 18.0234;
	const float raySpeed2 = .1;
	
	// Calculate the colour of the sun rays on the current fragment
	vec4 rays1 =
		vec4(1.0, 1.0, 1.0, 1.0) *
		rayStrength(rayPos1, rayRefDir1, coord, raySeedA1, raySeedB1, raySpeed1);
	 
	vec4 rays2 =
		vec4(1.0, 1.0, 1.0, 1.0) *
		rayStrength(rayPos2, rayRefDir2, coord, raySeedA2, raySeedB2, raySpeed2);
	
	vec4 fragColor = rays1 * 0.5 + rays2 * 0.4;
	
	// Attenuate brightness towards the bottom, simulating light-loss due to depth.
	// Give the whole thing a blue-green tinge as well.
	float brightness = 1.0 - (coord.y / iResolution.y);
	fragColor.x *= 0.01 + (brightness * 0.8);
	fragColor.y *= -0.13 + (brightness * 01.16);
	fragColor.z *= 0.15 + (brightness * 01.285);
    fragColor += fragColor;
    return fragColor;
}




#define NUM_LIGHTS numlgths
#define WALL_COLOR vec3(1.0, 0.5, 0.1)
#define FLOOR_COLOR vec3(0.4, 0.4, 0.4)
#define AMBIENT_LIGHT vec3(0.1, 0.1, 0.1)

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
	return texture(iChannel0,vec2(0, float(id))/vec2(iResolution.x,maxlgth_d) + hpo).yz;   
}

vec3 LightColor(int id)
{
	return texture(iChannel0,vec2(1, float(id))/vec2(iResolution.x,maxlgth_d) + hpo).yzw;   
}

float SampleShadow(int id, vec2 uv)
{
    float a = atan(uv.y, uv.x)/tau + 0.5;
    float r = length(uv);
    
    float idn = float(id)/float(maxlgth_d);
    
    float s = texture(iChannel0, vec2(a, idn) + hpo).x;
    
    return 1.0-smoothstep(s, s+0.02, length(uv));    
}

//Reads lights from light buffer and combines them.
vec3 MixLights(vec2 uv, float vf,out vec3 shd2)
{
    vec3 b = AMBIENT_LIGHT;
    shd2 = AMBIENT_LIGHT;
    
	for(int i = 0;i < NUM_LIGHTS+4;i++)
    {
        vec2 o = LightOrigin(i);
        vec3 c = LightColor(i);
        float l=0.;
        float vx=SampleShadow(i, uv-o);
        if(i<4)
        {
        l = 0.01 / pow(length(vec3(uv - o, 0.1))*vf/2., vf/2.*3.050);
        l *= vx+1.*smoothstep(vx/2.,vf,1.-vf);
        l*=vf;
        l+=vf/3.;
        b += c * l;
        }
        else
        {
        l = 0.01 / pow(length(vec3(uv - o, 0.1)), 2.0);
        l *= vx;
        shd2 += c * l;
        }
        
    }
    
    return b;
}

vec4 mi(in vec2 fragCoord ,out vec4 shadow, float vf, out vec3 shd2x)
{
    hpo = 0.5 / vec2(iResolution.x,float(maxlgth_d));
    res = iResolution.xy / iResolution.y;
	vec2 uv = fragCoord.xy / iResolution.y - res/2.0;
    vec3 col = vec3(0);
    vec3 tx = Scene(uv);
    vec3 cxx=vec3(tx.g/2.,tx.gb);
    col=cxx;
    if(sdwsxd)shadow = vec4(MixLights(uv,vf,shd2x),1.);
	return vec4(col, 1.0);
} 

vec3 Scene3(vec2 uv)
{
    uv.x *=  1./(iResolution.x / iResolution.y);
    uv+=.5;
    return texture(iChannel2,uv).rgb;
}

vec4 milg(in vec2 fragCoord)
{
	vec2 uv = fragCoord.xy / iResolution.y - res/2.0;
    vec3 col = Scene3(uv);
	return vec4(col, 1.0);
} 





// created by florian berger (flockaroo) - 2016
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

//using https://www.shadertoy.com/view/Mt3XW8
//using https://www.shadertoy.com/view/Mts3zM

#define show_spawn
#define sfanimtime 3.
#define sanimtime 3.

float rectMask(float b, float w, vec2 uv)
{
	vec4 e=smoothstep(vec4(-b-.005*w),vec4(-b+.5*w),vec4(uv,vec2(1)-uv));
    return e.x*e.y*e.z*e.w;
}

float getVign(vec2 fragCoord)
{
	float rs=length(fragCoord-iResolution.xy*.5)/iResolution.x;
    return .8-rs*rs*rs;
}

#define PI (4.0 * atan(1.0))
#define TWO_PI PI*2.
float shape(vec2 uv, float r, int v)
{
  int N=0;
  uv=uv-r;
  if(v==2){N=3;uv*=2.7;}
  if(v==1){N=4;uv*=1.8;}
  if(v==0){N=104;uv*=1.8;}
  float color = 0.0;
  float d = 0.0;
  float a = atan(uv.x,uv.y)+PI;
  float rx = TWO_PI/float(N);
  d = cos(floor(.5+a/rx)*rx-a)*length(uv);
  color = 1.-smoothstep(.354,.641,d);
  return color;
}

vec4 shapeb(vec2 uv, int v)
{
  uv*=iResolution.xy;
  int N=4;
  uv = ( 2.* uv - iResolution.xy ) /iResolution.y;
  uv.y+=0.05;
  uv.x+=0.05;
  uv*=1.85;
  vec2 uv2=uv;
  vec3 c=vec3(0.);
  if(v==2){N=3;uv.y+=0.213;uv*=.7;c=m4-0.5*m444;}
  if(v==1){N=4;uv*=.5;c=m333-m3;}
  if(v==0){N=104;uv*=.5;c=m2-m1;}
  float color = 0.0;
  float d = 0.0;
  float a = atan(uv.x,uv.y)+PI;
  float rx = TWO_PI/float(N);
  d = cos(floor(.5+a/rx)*rx-a)*length(uv);
  color = smoothstep(.24,.44,d);
  return vec4((1.-color)*c,1.-color);
}

float Mask(vec2 uv,float y, float i1, float i2, int v)
{
    float r1=.45;
    float r2=.45;
    r1*=0.1+i1;
    r2*=0.1+i2;
    return shape(uv+vec2(0,y-1.),r1,v)+shape(uv+vec2(0,y),r2,v);
}

vec4 mi( in vec2 fragCoord )
{
    vec4 fragColor=vec4(0.);
    int DFrame=60;//set this to make animation slower
    
    //fame
    //int actFrame=(iFrame/DFrame)*DFrame;
    
    //time
    int FPS=60;
    int iFrame=int(playervtime*float(FPS));
    #ifdef show_spawn
    	if(iTime<(sanimtime+sfanimtime))
        {
            iFrame=0;
        }
    #endif
    int actFrame=(iFrame/DFrame)*DFrame;
    
    vec4 rand = vec4(0.);
    vec2 TileSize =vec2(54.5*sqrt(iResolution.y/1080.));
    vec2 uvQ = (floor(fragCoord/TileSize)*TileSize)/iResolution.xy+vec2(0.,-.8/iResolution.y);//+-1+half pixel
    vec2 uv = fragCoord/iResolution.xy;
    vec2 duv = (uv-uvQ)*(iResolution.xy-iResolution.xy*vec2(0.,.051))/TileSize;
    rand=vec4(uvQ,1.,1.);
    float y=-rand.x*2.+3.*float(iFrame-actFrame)/float(DFrame);
    y=clamp(y,0.,1.);
    y*=y;
    float r = 0.*fract(rand.y+float(actFrame/DFrame)*.25);
    float thr=1.-duv.y;
    float i1=1.;
    float i2=1.;
    int v=int(mod(float(iFrame/DFrame),3.)*(1.-smoothstep(y-.01,y+.01,thr)));
    v+=int(mod(float(iFrame/DFrame)-1.,3.)*(smoothstep(y-.01,y+.01,thr)));
    vec4 c1=shapeb(uvQ,v);
    fragColor=c1;
    fragColor.rgba *= .5+.5*rectMask(.2*(dot(fragColor.xyz,vec3(.333))),.7,duv);
    float spec = 0.0+clamp((Mask(duv-.102,y,i1,i2,v)-Mask(duv+.02,y,i1,i2,v)),-.4,1.);
    fragColor.rgb += .935*spec*fragColor.rgb;
    fragColor.rgba *= 1.2*getVign(fragCoord);
    if(isdead)fragColor.rgb=vec3(max(max(fragColor.r,fragColor.g),fragColor.b));
    return fragColor;
}

mat2 mm2(in float a){float cx = cos(a), s = sin(a);return mat2(cx,-s,s,cx);}
float tri(in float x){return abs(fract(x)-.5);}
vec2 tri2(in vec2 p){return vec2(tri(p.x+tri(p.y*2.)),tri(p.y+tri(p.x*2.)));}
mat2 m22 = mat2( 0.970,  0.242, -0.242,  0.970 );

//Animated triangle noise, cheap and pretty decent looking.
float triangleNoise(in vec2 p)
{
    float z=1.5;
    float z2=1.5;
	float rz = 0.;
    vec2 bp = p;
	for (float i=0.; i<=3.; i++ )
	{
        vec2 dg = tri2(bp*2.)*.8;
        dg *= mm2(iTime*.2);
        p += dg/z2;
        bp *= 1.6;
        z2 *= .6;
		z *= 1.8;
		p *= 1.2;
        p*= m22;
        rz+= (tri(p.x+tri(p.y)))/z;
	}
	return rz;
}

vec4 z(in vec2 fragCoord , vec2 pfc)
{
    vec2 uv = fragCoord/iResolution.xy;
    vec2 ouv = fragCoord/iResolution.xy;
    vec2 p = (2.0*fragCoord.xy-iResolution.xy)/iResolution.y*.845;
    float a = atan(p.x,p.y);
    float r = length(p)*0.75;
    uv = vec2(a/TWO_PI,r);
 	uv = (2.0 * uv) - 1.0;
    float segm=mod((abs(uv.x-20.5))*6.,2.)*(mod((uv.x+20.5)*6.,2.));
	vec3 hc = vec3(0.125, 0.125, 0.125);
	float segm2=mod((uv.x+.5)*1.,24.); 
	float val=float(plhp);
    #ifdef show_spawn
    if(iTime<(sanimtime+sfanimtime))
    {
        val=mod(iTime,24.)*(24./sanimtime);
        hc = vec3(0.0, 0.0, 0.0);
    }
    #endif
    segm2=floor(((segm2>4.)?((segm2<19.)?4.:segm2-16.):segm2)*3.); 
    if(segm2<val+1.)
    {
        hc=vec3(1.-segm2/20.,segm2/20.,0.);
    	#ifdef show_spawn
    	if(iTime<(sanimtime+sfanimtime))
    	{
            float v2=smoothstep(sanimtime+sfanimtime,sanimtime+sfanimtime/2.,iTime);
            float v1=smoothstep(sanimtime,sanimtime+sfanimtime/2.,iTime);
        	hc = vec3(0.125, 0.125, 0.125)*(1.-v1)+vec3(5.0, 5.0, 5.0)*v1*v2+hc*(1.-v2)*v1;
    	}
    	#endif
    }
   	float bw = min(15.8,(1.2) * abs(1.0 / (30.0 * uv.y)));
    vec3 col=bw*hc*vec3(smoothstep(-0.215,-0.1,uv.y-0.15)*smoothstep(0.215,-0.1,uv.y-0.15)*segm);
    if(int(segm2)==10){uv=(gl_FragCoord.xy*3.+pfc)/iResolution.xy*TWO_PI;};
    col=col/3.+col*2.*triangleNoise(uv);
    return vec4(col,max(max(col.r,col.b),col.g));
}

vec3 c(vec2 fragCoord){
    vec2 uv = (2.0*fragCoord.xy-iResolution.xy)/iResolution.y;
    uv*=1.2;
    float r = length( uv );
    return mix( vec3(0.), vec3(0.9-0.4*pow(r,4.0)), 1.0-smoothstep(0.94,0.95,r) );
}

#define PI (4.0 * atan(1.0))
#define TWO_PI PI*2.
#define rot2d(a) mat2(cos(a), -sin(a), sin(a), cos(a))

float angle(vec2 p1, vec2 p2) {
    return atan(p1.y - p2.y, p1.x - p2.x);
}

float drawtriangle(vec2 fc){
    vec2 res = iResolution.xy / iResolution.y;
    vec2 uv = (fc.xy) / iResolution.y - res/2.0;
    uv+=0.5;
    uv.x-=.0;
    uv = uv *2.-1.;
    uv*=20.;
    vec2 imx = iMouse.xy / iResolution.y - res/2.0;
    vec2 uvz = playerpos.xy / iResolution.y - res/2.0;
    uv=(uv)*rot2d(PI+angle(uvz,imx));
    uv.x-=018.5;
    uv=(uv)*rot2d(PI/6.);
    int N = 3;
    float a = atan(uv.x,uv.y);
    float r = TWO_PI/float(N);
    return (1.0-smoothstep(.54,.8541,cos(floor(.5+a/r)*r-a)*length(uv)))/1.5;
}

vec4 pl1m( in vec2 fragCoord , vec4 bgc)
{	
	fragCoord*=3.;
	float rx=iResolution.x/2.242990;
	vec2 pfc=-vec2(playerpos.x,iResolution.y-playerpos.y)*3.+iResolution.xy/2.;
	fragCoord.xy+=pfc;
	if (!(1. - step(rx/1.45, length(fragCoord - rx/1.45-vec2(rx/2.25,-rx/15.))) > 0.)) {
		return bgc;
	}
	
	vec2 uv =  fragCoord.xy/iResolution.xy;
    vec4 cx=vec4(c(fragCoord),1.);
    
    #ifdef show_spawn
    cx.a=smoothstep(0.0,0.752,cx.r);
    	if(iTime<(sanimtime+sfanimtime))
    	{
            float v2=smoothstep(sanimtime+sfanimtime,sanimtime+sfanimtime/2.,iTime);
            float v1=smoothstep(sanimtime,sanimtime+sfanimtime/2.,iTime);
            float v0=smoothstep(0.,sanimtime,iTime)*(v2);
            float vx=triangleNoise(uv)*cx.a;
        	cx = vec4(m111*vx*(v0)+vx*m222.rgb*v1*v2+cx.rgb*(1.-v2)*v1,cx.a);
    	}
    #endif
    cx.a=smoothstep(0.0,0.752,cx.r);
    if(fxaa)cx.rgb=cx.rgb/1.5;
    vec4 fragColor= mi(fragCoord);
    fragColor.rgb*=0.8;
    float x= fragColor.a;
    #ifdef show_spawn
    	if(iTime<(sanimtime+sfanimtime))
    	{
            float v2=smoothstep(sanimtime+sfanimtime,sanimtime+sfanimtime/2.,iTime);
            float v1=smoothstep(sanimtime,sanimtime+sfanimtime/2.,iTime);
            float v0=smoothstep(0.,sanimtime,iTime);
            float vx=triangleNoise(uv)*(x);
        	vec3 fx= m222*vx*(v0*v2)+vx*m333.rgb*v1*v2+fragColor.rgb*(1.-v2)*v1;
            fragColor=vec4(fx,x*v0);
            x=fragColor.a;
    	}
    #endif
    cx.rgb*=0.8;
    fragColor=cx*(1.-x)+fragColor;
    fragColor.a=1.-fragColor.a;
    fragColor+=z(fragCoord,pfc);
    fragColor+=bgc*(fragColor.a);
    fragColor+=drawtriangle(fragCoord)*vec4(1.-1.*distance(vec2(playerpos.x,playerpos.y)/iResolution.xy,iMouse.xy/iResolution.xy),1.*distance(vec2(playerpos.x,playerpos.y)/iResolution.xy,iMouse.xy/iResolution.xy),.0,1.);
    return fragColor;
}





vec4 mi3( in vec2 fragCoord )
{
    float t = 0.0001*iTime;
    vec2 uv0 = 2.0*(fragCoord - 0.5*iResolution.xy)/iResolution.y+vec2(0.25,0.);
    uv0.x*=.981;
    vec2 uv00 = fragCoord/iResolution.xy;
    vec2 uv = (uv0+vec2(1.0))/2.0;
    vec4 fragColor=vec4(0.);
    
    float eps = 1.0/iResolution.y;
    uv*= 8.0;
    vec2 uvi = floor(uv);
    uv = 2.0*fract(uv)-vec2(1.0);
    
	vec2 iMouse=vec2(iMouse.x,iResolution.y-iMouse.y);
    t =  (playerpos.x/iResolution.x-0.5-0.765)/1.1/2.25;
    t = t+ uvi.x/8.0 + uvi.y/2.0;
    t = 2.0*abs(fract(t)-0.5);
    t = 2.0*smoothstep(0., 1., t) - 1.0;

    vec2 h = vec2(4.0*eps, 0);
    vec2 grad = vec2(
        Pyramid(uv + h.xy, t) - Pyramid(uv - h.xy, t),
        Pyramid(uv + h.yx, t) - Pyramid(uv - h.yx, t)) / (2.0*h.x);

    vec3 n = cross(vec3(1.0, 0.0, grad.x), vec3(0.0, 1.0, grad.y));
    n = normalize(n);
    
    vec3 l = normalize(vec3(0.0, -3.0, 1.0));
    l = normalize(vec3(1.+6.*distance(uv00,iMouse.xy/iResolution.xy),-1.-6.*distance(uv00,iMouse.xy/iResolution.xy),1.));
    float cs = dot(l,n);
  
    float c;
    c = 0.7*max(0.0, cs) + 0.07*max(0.0, -cs);
    c += 0.1*pow(max(0.0, -cs), 0.5);
    
    c = pow(c, 0.8);
	
    uv = abs(uv);
    c *= smoothstep(0.0, 0.2, pow(1.0-max(uv.x, uv.y)/sqrt(2.0), 2.0));
     
    c *= mix(0.3, 1.3, pow((uv0.y + 1.0)/2.0, 1.5));
    
    uv0+=-vec2(0.25,0.);
    float v1=1.-step(abs(uv0.x), 1.50);
    c *= v1;
    cs*=v1;
    
    vec3 color;
    color = vec3(c);
        
	float rand = fract(sin((iTime + dot(fragCoord.xy, vec2(12.9898, 78.233))))* 43758.5453);
    color = (floor(90.0*color) + step(rand, fract(90.0*color)))/90.0;
    
    
    fragColor = vec4(color*m2,1.0);
    vec4 miu=mi2(fragCoord+iResolution.xy*cs/10.)*vec4(m2,1.); //bg
    vec4 shadow;
    vec4 mii=zxc(fragCoord+iResolution.xy*cs/10.);//rays
    vec3 shd2x;
    vec4 boxes=mi(fragCoord+iResolution.xy*cs/10.,shadow,mii.b,shd2x);//shadow
	boxes=boxes.bgra/3.;
	boxes.r*=0.4675;
	boxes.b*=0.835;
	boxes+=milg(fragCoord+iResolution.xy*cs/10.);
    if(sdwsxd)mii=(miu.bgra)*(vec4(shd2x,1.))*2.+min(vec4(1.),vec4(shd2x,1.))*(1.-mii)/4.3*(miu.bgra)*(vec4(shd2x,1.))*2.+(miu)*shadow+min(vec4(1.),shadow).rbga*mii/1.3;
    else mii=mii/3.+miu/3.;
    vec4 c1=fragColor+fragColor*miu*v1*3.;
    
    fragColor=miu*(1.-v1);
    c1+=min(vec4(1.),vxc(fragCoord-iResolution.xy*cs/50.,v1,l.y*50.).grra/2.);
    vec4 xx=min(vec4(1.),vxc2(fragCoord,l.x*50.).grra/2.*(1.-v1))*(smoothstep(0.8838,1.,abs(uv0.y))+smoothstep(01.3838,1.5,abs(uv0.x)));
    fragColor=mii*(1.-v1)+mii*v1/1.+fragColor.bgga*xx*20.;
    fragColor+=c1+miu*(v1);
    vec4 vxxz;
    if(sdwsxd)vxxz=boxes*miu*3.+boxes*mii*2.;
    else {vxxz=boxes.ggra/2.2+boxes.ggra*miu/2.+miu/3.+boxes*mii/2.;vxxz*=0.5;};
    fragColor=fragColor+vxxz;
    fragColor.rgb=min(vec3(1.),fragColor.rgb);
    fragColor.rgb=max(vec3(0.),fragColor.rgb);
    fragColor.a=1.;
    fragColor=pl1m(fragCoord,fragColor);
    return fragColor;
}



void main() {
    glFragColor=mi3(vec2(gl_FragCoord.x,gl_FragCoord.y));
}
