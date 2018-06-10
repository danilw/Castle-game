#version 300 es
precision highp float;
uniform vec2 u_resolution;
uniform sampler2D u_texture2;
uniform float u_time;
uniform vec2 fkres;
uniform float lposx[200];
uniform float lposy[200];
uniform float ttlx[200];
uniform highp int numlgths;
out lowp vec4 glFragColor;
vec2 res;
vec2 me;

// License Creative Commons Attribution-NonCommercial-ShareAlike

// opensource
// please dont use it for sell on google/apple store thanks

//original GLSL source on my github https://github.com/danilw
//this is obfuscated/optimized source

void main ()
{
  me = vec2(0.0, 0.0);
  vec3 data_1;
  vec2 tmpvar_2;
  vec3 tmpvar_3;
  float tmpvar_4;
  highp int id_5;
  res = (fkres / fkres.y);
  highp float tmpvar_6;
  tmpvar_6 = ((gl_FragCoord.x / u_resolution.x) * 6.283159);
  highp vec2 tmpvar_7;
  tmpvar_7.x = cos(tmpvar_6);
  tmpvar_7.y = sin(tmpvar_6);
  highp int tmpvar_8;
  tmpvar_8 = int(gl_FragCoord.y);
  id_5 = tmpvar_8;
  if ((((numlgths + 4) - 1) < tmpvar_8)) {
    discard;
  };
  float tmpvar_9;
  tmpvar_9 = (float(mod (u_time, 40.0)));
  tmpvar_2 = vec2(0.0, 0.0);
  tmpvar_3 = vec3(0.0, 0.0, 0.0);
  tmpvar_4 = 0.0;
  if ((tmpvar_8 == 0)) {
    tmpvar_2 = vec2(0.45, 0.55);
    tmpvar_3 = vec3(0.19607, 0.79215, 0.56078);
    float tmpvar_10;
    tmpvar_10 = clamp ((tmpvar_9 / 5.0), 0.0, 1.0);
    float tmpvar_11;
    tmpvar_11 = clamp (((tmpvar_9 - 10.0) / -5.0), 0.0, 1.0);
    tmpvar_4 = (0.1 + ((
      (2.5 * (tmpvar_10 * (tmpvar_10 * (3.0 - 
        (2.0 * tmpvar_10)
      ))))
     * 
      (tmpvar_11 * (tmpvar_11 * (3.0 - (2.0 * tmpvar_11))))
    ) * sin(
      (1.0 + cos((u_time / 2.0)))
    )));
  } else {
    if ((tmpvar_8 == 1)) {
      tmpvar_2 = vec2(0.35, 0.55);
      tmpvar_3 = vec3(0.56078, 0.78823, 0.87843);
      float tmpvar_12;
      tmpvar_12 = clamp (((tmpvar_9 - 10.0) / 5.0), 0.0, 1.0);
      float tmpvar_13;
      tmpvar_13 = clamp (((tmpvar_9 - 20.0) / -5.0), 0.0, 1.0);
      tmpvar_4 = (0.1 + ((
        (2.5 * (tmpvar_12 * (tmpvar_12 * (3.0 - 
          (2.0 * tmpvar_12)
        ))))
       * 
        (tmpvar_13 * (tmpvar_13 * (3.0 - (2.0 * tmpvar_13))))
      ) * sin(
        (1.0 + cos(((u_time / 2.0) + 3.0)))
      )));
    } else {
      if ((tmpvar_8 == 2)) {
        tmpvar_2 = vec2(0.25, 0.55);
        tmpvar_3 = vec3(0.78431, 0.49411, 0.70196);
        float tmpvar_14;
        tmpvar_14 = clamp (((tmpvar_9 - 20.0) / 5.0), 0.0, 1.0);
        float tmpvar_15;
        tmpvar_15 = clamp (((tmpvar_9 - 30.0) / -5.0), 0.0, 1.0);
        tmpvar_4 = (0.1 + ((
          (2.5 * (tmpvar_14 * (tmpvar_14 * (3.0 - 
            (2.0 * tmpvar_14)
          ))))
         * 
          (tmpvar_15 * (tmpvar_15 * (3.0 - (2.0 * tmpvar_15))))
        ) * sin(
          (1.0 + cos(((u_time / 2.0) + 2.0)))
        )));
      } else {
        if ((tmpvar_8 == 3)) {
          tmpvar_2 = vec2(0.15, 0.55);
          tmpvar_3 = vec3(0.53725, 0.79215, 0.48627);
          float tmpvar_16;
          tmpvar_16 = clamp (((tmpvar_9 - 30.0) / 5.0), 0.0, 1.0);
          float tmpvar_17;
          tmpvar_17 = clamp (((tmpvar_9 - 40.0) / -5.0), 0.0, 1.0);
          tmpvar_4 = (0.1 + ((
            (2.5 * (tmpvar_16 * (tmpvar_16 * (3.0 - 
              (2.0 * tmpvar_16)
            ))))
           * 
            (tmpvar_17 * (tmpvar_17 * (3.0 - (2.0 * tmpvar_17))))
          ) * sin(
            (1.0 + cos(((u_time / 2.0) - 3.0)))
          )));
        } else {
          for (highp int iy_18 = 0; iy_18 < numlgths; iy_18++) {
            if ((id_5 == (iy_18 + 4))) {
              vec2 tmpvar_19;
              tmpvar_19.x = lposx[iy_18];
              tmpvar_19.y = (fkres.y - lposy[iy_18]);
              me = ((tmpvar_19 / fkres.y) - (res / 2.0));
              tmpvar_2 = me;
              tmpvar_3 = ((vec3(1.23528, 0.52941, 0.523515) * (1.0 - ttlx[iy_18])) + (vec3(0.41176, 0.53333, 0.78431) * ttlx[iy_18]));
              tmpvar_4 = (2.3 - ttlx[iy_18]);
              break;
            };
          };
        };
      };
    };
  };
  highp int tmpvar_20;
  tmpvar_20 = int(gl_FragCoord.x);
  data_1 = vec3(0.0, 0.0, 0.0);
  if ((tmpvar_20 == 0)) {
    vec3 tmpvar_21;
    tmpvar_21.z = 0.0;
    tmpvar_21.xy = tmpvar_2;
    data_1 = tmpvar_21;
  };
  if ((tmpvar_20 == 1)) {
    data_1 = (tmpvar_4 * tmpvar_3);
  };
  vec2 orig_22;
  orig_22 = tmpvar_2;
  highp vec2 dir_23;
  dir_23 = tmpvar_7;
  lowp float d_25;
  d_25 = 0.0;
  for (highp int i_24 = 0; i_24 < 68; i_24++) {
    lowp float tmpvar_26;
    lowp vec2 uv_27;
    uv_27 = ((dir_23 * d_25) - orig_22);
    uv_27.x = (uv_27.x * 0.5622255);
    uv_27 = (uv_27 + 0.5);
    tmpvar_26 = (texture (u_texture2, (1.0 - uv_27)).x / 30.0);
    d_25 = (d_25 + tmpvar_26);
    if ((tmpvar_26 < 0.0001)) {
      break;
    };
  };
  lowp vec4 tmpvar_28;
  tmpvar_28.x = d_25;
  tmpvar_28.yzw = data_1;
  glFragColor = tmpvar_28;
}

