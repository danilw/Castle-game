#version 300 es
precision highp float;
uniform float rot;
uniform float ttl;
uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 pos;
uniform bool isspwnr;
out highp vec4 glFragColor;

// License Creative Commons Attribution-NonCommercial-ShareAlike

// opensource
// please dont use it for sell on google/apple store thanks

//original GLSL source on my github https://github.com/danilw
//this is obfuscated/optimized source

void main ()
{
  highp vec2 tmpvar_1;
  tmpvar_1.x = gl_FragCoord.x;
  tmpvar_1.y = (u_resolution.y - gl_FragCoord.y);
  highp vec3 col_2;
  vec2 im_3;
  highp vec2 tmpvar_4;
  tmpvar_4 = ((tmpvar_1 / u_resolution.y) - ((u_resolution / u_resolution.y) / 2.0));
  im_3 = ((pos / u_resolution) - 0.5);
  im_3.x = (im_3.x * (u_resolution.x / u_resolution.y));
  mat2 tmpvar_5;
  float tmpvar_6;
  tmpvar_6 = -(rot);
  tmpvar_5[uint(0)].x = cos(tmpvar_6);
  tmpvar_5[uint(0)].y = -(sin(tmpvar_6));
  tmpvar_5[1u].x = sin(tmpvar_6);
  tmpvar_5[1u].y = cos(tmpvar_6);
  highp vec2 uv_7;
  uv_7 = ((tmpvar_4 + im_3) * tmpvar_5);
  highp float d_8;
  uv_7 = (uv_7 * 33.85);
  uv_7 = (uv_7 * 0.5);
  d_8 = 0.0;
  highp float tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = (min (abs(
    (uv_7.x / uv_7.y)
  ), 1.0) / max (abs(
    (uv_7.x / uv_7.y)
  ), 1.0));
  highp float tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_10);
  tmpvar_11 = (((
    ((((
      ((((-0.01213232 * tmpvar_11) + 0.05368138) * tmpvar_11) - 0.1173503)
     * tmpvar_11) + 0.1938925) * tmpvar_11) - 0.3326756)
   * tmpvar_11) + 0.9999793) * tmpvar_10);
  tmpvar_11 = (tmpvar_11 + (float(
    (abs((uv_7.x / uv_7.y)) > 1.0)
  ) * (
    (tmpvar_11 * -2.0)
   + 1.570796)));
  tmpvar_9 = (tmpvar_11 * sign((uv_7.x / uv_7.y)));
  if ((abs(uv_7.y) > (1e-08 * abs(uv_7.x)))) {
    if ((uv_7.y < 0.0)) {
      if ((uv_7.x >= 0.0)) {
        tmpvar_9 += 3.141593;
      } else {
        tmpvar_9 = (tmpvar_9 - 3.141593);
      };
    };
  } else {
    tmpvar_9 = (sign(uv_7.x) * 1.570796);
  };
  highp float tmpvar_12;
  tmpvar_12 = (tmpvar_9 + 3.14158);
  d_8 = (cos((
    (floor((0.5 + (tmpvar_12 / 0.06041499))) * 0.06041499)
   - tmpvar_12)) * sqrt(dot (uv_7, uv_7)));
  highp float tmpvar_13;
  tmpvar_13 = clamp (((d_8 - 0.24) / 0.41), 0.0, 1.0);
  highp float tmpvar_14;
  tmpvar_14 = min ((tmpvar_13 * (tmpvar_13 * 
    (3.0 - (2.0 * tmpvar_13))
  )), 0.45);
  col_2 = vec3(0.0, 0.0, 0.0);
  mat2 tmpvar_15;
  float tmpvar_16;
  tmpvar_16 = -(rot);
  tmpvar_15[uint(0)].x = cos(tmpvar_16);
  tmpvar_15[uint(0)].y = -(sin(tmpvar_16));
  tmpvar_15[1u].x = sin(tmpvar_16);
  tmpvar_15[1u].y = cos(tmpvar_16);
  float time_18;
  highp float c_19;
  highp vec2 i_20;
  highp vec2 p_21;
  highp vec2 tmpvar_22;
  tmpvar_22 = (((tmpvar_4 + im_3) * tmpvar_15) * 33.85);
  p_21 = tmpvar_22;
  i_20 = tmpvar_22;
  c_19 = 0.2;
  time_18 = (u_time / 1.5);
  for (highp int n_17 = 1; n_17 < 8; n_17++) {
    float tmpvar_23;
    tmpvar_23 = (time_18 * (1.0 - (1.0/(
      float((n_17 + 1))
    ))));
    highp vec2 tmpvar_24;
    tmpvar_24.x = (cos((tmpvar_23 - i_20.x)) + sin((tmpvar_23 + i_20.x)));
    tmpvar_24.y = (sin((tmpvar_23 - i_20.x)) + cos((tmpvar_23 + i_20.y)));
    i_20 = (p_21 + tmpvar_24);
    highp vec2 tmpvar_25;
    tmpvar_25.x = (p_21.x / sin((i_20.x + tmpvar_23)));
    tmpvar_25.y = (p_21.y / cos((i_20.y + tmpvar_23)));
    c_19 = (c_19 + inversesqrt(dot (tmpvar_25, tmpvar_25)));
  };
  c_19 = (c_19 / 8.0);
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.45;
  tmpvar_26.xyz = (vec3(pow (c_19, 3.7)) * vec3(0.44, 0.65, 1.53));
  highp float tmpvar_27;
  tmpvar_27 = clamp (((
    sqrt(dot (tmpvar_22, tmpvar_22))
   - 1.0) / -0.42), 0.0, 1.0);
  col_2 = ((tmpvar_26 * (tmpvar_27 * 
    (tmpvar_27 * (3.0 - (2.0 * tmpvar_27)))
  )).zyx * vec3(1.0, 1.0, -1.0));
  col_2.z = (col_2.z + ((col_2.x * ttl) * 1.3));
  col_2.x = (col_2.x + ((-0.25 * col_2.x) * ttl));
  if (isspwnr) {
    col_2 = (col_2 * ttl);
  };
  if ((tmpvar_14 > 0.448)) {
    discard;
  };
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = col_2;
  glFragColor = tmpvar_28;
}

