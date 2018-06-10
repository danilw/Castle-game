#version 300 es
precision highp float;
uniform vec2 u_resolution;
uniform sampler2D u_texture1;
uniform sampler2D u_texture2;
out lowp vec4 glFragColor;
vec2 hpo;

// License Creative Commons Attribution-NonCommercial-ShareAlike

// opensource
// please dont use it for sell on google/apple store thanks

//original GLSL source on my github https://github.com/danilw
//this is obfuscated/optimized source

void main ()
{
  lowp vec3 col_1;
  vec2 tmpvar_2;
  tmpvar_2.y = 5.0;
  tmpvar_2.x = u_resolution.x;
  hpo = (0.5 / tmpvar_2);
  highp vec2 tmpvar_3;
  tmpvar_3 = ((gl_FragCoord.xy / u_resolution.y) - ((u_resolution / u_resolution.y) / 2.0));
  highp vec2 uv_4;
  uv_4.y = tmpvar_3.y;
  uv_4.x = (tmpvar_3.x * (1.0/((u_resolution.x / u_resolution.y))));
  uv_4 = (uv_4 + 0.5);
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture (u_texture2, uv_4);
  lowp vec3 tmpvar_6;
  tmpvar_6.x = (tmpvar_5.y / 2.0);
  tmpvar_6.yz = tmpvar_5.yz;
  col_1 = tmpvar_6;
  highp vec2 uv_7;
  uv_7 = tmpvar_3;
  lowp vec3 b_9;
  b_9 = vec3(0.1, 0.1, 0.1);
  for (highp int i_8 = 0; i_8 < 6; i_8++) {
    lowp float l_10;
    vec2 tmpvar_11;
    tmpvar_11.x = 0.0;
    tmpvar_11.y = float(i_8);
    vec2 tmpvar_12;
    tmpvar_12.y = 5.0;
    tmpvar_12.x = u_resolution.x;
    lowp vec4 tmpvar_13;
    tmpvar_13 = texture (u_texture1, ((tmpvar_11 / tmpvar_12) + hpo));
    vec2 tmpvar_14;
    tmpvar_14.x = 1.0;
    tmpvar_14.y = float(i_8);
    vec2 tmpvar_15;
    tmpvar_15.y = 5.0;
    tmpvar_15.x = u_resolution.x;
    lowp vec4 tmpvar_16;
    tmpvar_16 = texture (u_texture1, ((tmpvar_14 / tmpvar_15) + hpo));
    lowp vec3 tmpvar_17;
    tmpvar_17.z = 0.1;
    tmpvar_17.xy = (uv_7 - tmpvar_13.yz);
    lowp float tmpvar_18;
    lowp float tmpvar_19;
    tmpvar_19 = sqrt(dot (tmpvar_17, tmpvar_17));
    tmpvar_18 = (0.01 / (tmpvar_19 * tmpvar_19));
    l_10 = tmpvar_18;
    lowp vec2 uv_20;
    uv_20 = (uv_7 - tmpvar_13.yz);
    lowp float tmpvar_21;
    lowp float tmpvar_22;
    tmpvar_22 = (min (abs(
      (uv_20.y / uv_20.x)
    ), 1.0) / max (abs(
      (uv_20.y / uv_20.x)
    ), 1.0));
    lowp float tmpvar_23;
    tmpvar_23 = (tmpvar_22 * tmpvar_22);
    tmpvar_23 = (((
      ((((
        ((((-0.01213232 * tmpvar_23) + 0.05368138) * tmpvar_23) - 0.1173503)
       * tmpvar_23) + 0.1938925) * tmpvar_23) - 0.3326756)
     * tmpvar_23) + 0.9999793) * tmpvar_22);
    tmpvar_23 = (tmpvar_23 + (float(
      (abs((uv_20.y / uv_20.x)) > 1.0)
    ) * (
      (tmpvar_23 * -2.0)
     + 1.570796)));
    tmpvar_21 = (tmpvar_23 * sign((uv_20.y / uv_20.x)));
    if ((abs(uv_20.x) > (1e-08 * abs(uv_20.y)))) {
      if ((uv_20.x < 0.0)) {
        if ((uv_20.y >= 0.0)) {
          tmpvar_21 += 3.141593;
        } else {
          tmpvar_21 = (tmpvar_21 - 3.141593);
        };
      };
    } else {
      tmpvar_21 = (sign(uv_20.y) * 1.570796);
    };
    lowp vec2 tmpvar_24;
    tmpvar_24.x = ((tmpvar_21 / 6.283159) + 0.5);
    tmpvar_24.y = (float(i_8) / 5.0);
    lowp vec4 tmpvar_25;
    tmpvar_25 = texture (u_texture1, (tmpvar_24 + hpo));
    lowp float tmpvar_26;
    tmpvar_26 = clamp (((
      sqrt(dot (uv_20, uv_20))
     - tmpvar_25.x) / (
      (tmpvar_25.x + 0.02)
     - tmpvar_25.x)), 0.0, 1.0);
    l_10 = (tmpvar_18 * (1.0 - (tmpvar_26 * 
      (tmpvar_26 * (3.0 - (2.0 * tmpvar_26)))
    )));
    b_9 = (b_9 + (tmpvar_16.yzw * l_10));
  };
  col_1 = (tmpvar_6 * b_9);
  lowp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = col_1;
  glFragColor = tmpvar_27;
}

