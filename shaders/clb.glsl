#version 300 es
precision highp float;
uniform float rot;
uniform vec2 u_resolution;
out highp vec4 glFragColor;
uniform vec2 playerpos;

// License Creative Commons Attribution-NonCommercial-ShareAlike

// opensource
// please dont use it for sell on google/apple store thanks

//original GLSL source on my github https://github.com/danilw
//this is obfuscated/optimized source

void main ()
{
  highp vec2 fc_1;
  highp vec4 rt_2;
  rt_2 = vec4(0.5, 0.0, 0.0, 1.0);
  fc_1 = (gl_FragCoord.xy * 3.0);
  vec2 tmpvar_3;
  tmpvar_3.x = playerpos.x;
  tmpvar_3.y = (u_resolution.y - playerpos.y);
  fc_1 = (fc_1 + ((
    -(tmpvar_3)
   * 3.0) + (u_resolution / 2.0)));
  mat2 tmpvar_4;
  float tmpvar_5;
  tmpvar_5 = -(rot);
  tmpvar_4[uint(0)].x = cos(tmpvar_5);
  tmpvar_4[uint(0)].y = -(sin(tmpvar_5));
  tmpvar_4[1u].x = sin(tmpvar_5);
  tmpvar_4[1u].y = cos(tmpvar_5);
  highp vec2 uv_6;
  uv_6 = (((fc_1 / u_resolution.y) - (
    (u_resolution / u_resolution.y)
   / 2.0)) * tmpvar_4);
  highp float d_7;
  uv_6 = (uv_6 * 0.5);
  d_7 = 0.0;
  highp float tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = (min (abs(
    (uv_6.x / uv_6.y)
  ), 1.0) / max (abs(
    (uv_6.x / uv_6.y)
  ), 1.0));
  highp float tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_9);
  tmpvar_10 = (((
    ((((
      ((((-0.01213232 * tmpvar_10) + 0.05368138) * tmpvar_10) - 0.1173503)
     * tmpvar_10) + 0.1938925) * tmpvar_10) - 0.3326756)
   * tmpvar_10) + 0.9999793) * tmpvar_9);
  tmpvar_10 = (tmpvar_10 + (float(
    (abs((uv_6.x / uv_6.y)) > 1.0)
  ) * (
    (tmpvar_10 * -2.0)
   + 1.570796)));
  tmpvar_8 = (tmpvar_10 * sign((uv_6.x / uv_6.y)));
  if ((abs(uv_6.y) > (1e-08 * abs(uv_6.x)))) {
    if ((uv_6.y < 0.0)) {
      if ((uv_6.x >= 0.0)) {
        tmpvar_8 += 3.141593;
      } else {
        tmpvar_8 = (tmpvar_8 - 3.141593);
      };
    };
  } else {
    tmpvar_8 = (sign(uv_6.x) * 1.570796);
  };
  highp float tmpvar_11;
  tmpvar_11 = (tmpvar_8 + 3.14158);
  d_7 = (cos((
    (floor((0.5 + (tmpvar_11 / 0.06041499))) * 0.06041499)
   - tmpvar_11)) * sqrt(dot (uv_6, uv_6)));
  highp float tmpvar_12;
  tmpvar_12 = clamp (((d_7 - 0.154) / 0.3325), 0.0, 1.0);
  rt_2.x = min ((tmpvar_12 * (tmpvar_12 * 
    (3.0 - (2.0 * tmpvar_12))
  )), 0.5);
  glFragColor = rt_2;
}

