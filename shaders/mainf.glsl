#version 300 es
precision highp float;
uniform vec2 u_resolution;
uniform float u_time;
uniform sampler2D u_texture1;
uniform sampler2D u_texture2;
uniform bool backgroundVisible;
uniform vec4 backgroundclicktimer;
uniform float backgroundtime;
uniform vec2 backgoundClickpos1;
uniform vec2 backgoundClickpos2;
uniform vec2 backgoundClickpos3;
uniform vec2 backgoundClickpos4;
out lowp vec4 glFragColor;

// License Creative Commons Attribution-NonCommercial-ShareAlike

// opensource
// please dont use it for sell on google/apple store thanks

//original GLSL source on my github https://github.com/danilw
//this is obfuscated/optimized source

void main ()
{
  lowp vec4 tmpvar_1;
  lowp vec2 uv_2;
  lowp vec2 tmpvar_3;
  tmpvar_3 = (gl_FragCoord.xy / u_resolution);
  uv_2 = tmpvar_3;
  if (backgroundVisible) {
    lowp vec3 col_4;
    lowp float n_5;
    lowp float t_6;
    highp vec2 pos_7;
    highp vec2 tmpvar_8;
    highp vec2 tmpvar_9;
    tmpvar_9 = (2.0 * gl_FragCoord.xy);
    tmpvar_8 = ((-(u_resolution) + tmpvar_9) / u_resolution.y);
    pos_7.x = tmpvar_8.x;
    pos_7.y = (tmpvar_8.y + -0.5);
    pos_7 = (pos_7 * (1.5 - (0.3 * pos_7.y)));
    highp vec2 p_10;
    p_10 = (12.0 * pos_7);
    highp vec2 tmpvar_11;
    tmpvar_11.x = (1.154701 * p_10.x);
    tmpvar_11.y = (p_10.y + (p_10.x * 0.5773503));
    highp vec2 tmpvar_12;
    tmpvar_12 = floor(tmpvar_11);
    highp vec2 tmpvar_13;
    tmpvar_13 = fract(tmpvar_11);
    highp float tmpvar_14;
    tmpvar_14 = (float(mod ((tmpvar_12.x + tmpvar_12.y), 3.0)));
    highp float tmpvar_15;
    tmpvar_15 = float((tmpvar_14 >= 1.0));
    highp float tmpvar_16;
    tmpvar_16 = float((tmpvar_14 >= 2.0));
    highp vec2 tmpvar_17;
    tmpvar_17.x = float((tmpvar_13.y >= tmpvar_13.x));
    tmpvar_17.y = float((tmpvar_13.x >= tmpvar_13.y));
    highp float tmpvar_18;
    tmpvar_18 = dot (tmpvar_17, ((
      (1.0 - tmpvar_13.yx)
     + 
      (tmpvar_15 * ((tmpvar_13.x + tmpvar_13.y) - 1.0))
    ) + (tmpvar_16 * 
      (tmpvar_13.yx - (2.0 * tmpvar_13))
    )));
    highp vec2 tmpvar_19;
    tmpvar_19.x = (tmpvar_11.x + floor((0.5 + 
      (p_10.y / 1.5)
    )));
    tmpvar_19.y = ((4.0 * p_10.y) / 3.0);
    p_10 = ((tmpvar_19 * 0.5) + 0.5);
    highp float tmpvar_20;
    highp vec2 x_21;
    x_21 = ((fract(p_10) - 0.5) * vec2(1.0, 0.85));
    tmpvar_20 = sqrt(dot (x_21, x_21));
    highp vec4 tmpvar_22;
    tmpvar_22.xy = ((tmpvar_12 + tmpvar_15) - (tmpvar_16 * tmpvar_17));
    tmpvar_22.z = tmpvar_18;
    tmpvar_22.w = tmpvar_20;
    vec2 tmpvar_23;
    tmpvar_23.y = 0.0;
    tmpvar_23.x = (u_time * 0.7);
    highp vec3 tmpvar_24;
    tmpvar_24.z = 0.0;
    tmpvar_24.xy = ((0.3 * tmpvar_22.xy) + tmpvar_23);
    highp vec3 f_25;
    highp vec3 tmpvar_26;
    tmpvar_26 = floor(tmpvar_24);
    highp vec3 tmpvar_27;
    tmpvar_27 = fract(tmpvar_24);
    f_25 = ((tmpvar_27 * tmpvar_27) * (3.0 - (2.0 * tmpvar_27)));
    lowp vec2 tmpvar_28;
    tmpvar_28 = textureLod (u_texture1, (((
      (tmpvar_26.xy + (vec2(37.0, 17.0) * tmpvar_26.z))
     + f_25.xy) + 0.5) / 256.0), 0.0).yx;
    vec2 cx_29;
    cx_29.x = backgoundClickpos1.x;
    cx_29.y = (u_resolution.y - backgoundClickpos1.y);
    highp vec2 x_30;
    x_30 = (((tmpvar_9 - u_resolution) / u_resolution.y) - ((
      (2.0 * cx_29)
     - u_resolution) / u_resolution.y));
    float tmpvar_31;
    tmpvar_31 = (4.0 / u_resolution.y);
    highp float tmpvar_32;
    tmpvar_32 = clamp (((
      (abs((sqrt(
        dot (x_30, x_30)
      ) - (0.3 * backgroundclicktimer.x))) + ((0.14 * backgroundclicktimer.x) / 2.0))
     - tmpvar_31) / (
      (0.05 + (0.6 * backgroundclicktimer.x))
     - tmpvar_31)), 0.0, 1.0);
    float tmpvar_33;
    tmpvar_33 = clamp (((backgroundclicktimer.x - 2.2) / -1.7), 0.0, 1.0);
    vec2 cx_34;
    cx_34.x = backgoundClickpos2.x;
    cx_34.y = (u_resolution.y - backgoundClickpos2.y);
    highp vec2 x_35;
    x_35 = (((tmpvar_9 - u_resolution) / u_resolution.y) - ((
      (2.0 * cx_34)
     - u_resolution) / u_resolution.y));
    highp float tmpvar_36;
    tmpvar_36 = clamp (((
      (abs((sqrt(
        dot (x_35, x_35)
      ) - (0.3 * backgroundclicktimer.y))) + ((0.14 * backgroundclicktimer.y) / 2.0))
     - tmpvar_31) / (
      (0.05 + (0.6 * backgroundclicktimer.y))
     - tmpvar_31)), 0.0, 1.0);
    float tmpvar_37;
    tmpvar_37 = clamp (((backgroundclicktimer.y - 2.2) / -1.7), 0.0, 1.0);
    vec2 cx_38;
    cx_38.x = backgoundClickpos3.x;
    cx_38.y = (u_resolution.y - backgoundClickpos3.y);
    highp vec2 x_39;
    x_39 = (((tmpvar_9 - u_resolution) / u_resolution.y) - ((
      (2.0 * cx_38)
     - u_resolution) / u_resolution.y));
    highp float tmpvar_40;
    tmpvar_40 = clamp (((
      (abs((sqrt(
        dot (x_39, x_39)
      ) - (0.3 * backgroundclicktimer.z))) + ((0.14 * backgroundclicktimer.z) / 2.0))
     - tmpvar_31) / (
      (0.05 + (0.6 * backgroundclicktimer.z))
     - tmpvar_31)), 0.0, 1.0);
    float tmpvar_41;
    tmpvar_41 = clamp (((backgroundclicktimer.z - 2.2) / -1.7), 0.0, 1.0);
    vec2 cx_42;
    cx_42.x = backgoundClickpos4.x;
    cx_42.y = (u_resolution.y - backgoundClickpos4.y);
    highp vec2 x_43;
    x_43 = (((tmpvar_9 - u_resolution) / u_resolution.y) - ((
      (2.0 * cx_42)
     - u_resolution) / u_resolution.y));
    highp float tmpvar_44;
    tmpvar_44 = clamp (((
      (abs((sqrt(
        dot (x_43, x_43)
      ) - (0.3 * backgroundclicktimer.w))) + ((0.14 * backgroundclicktimer.w) / 2.0))
     - tmpvar_31) / (
      (0.05 + (0.6 * backgroundclicktimer.w))
     - tmpvar_31)), 0.0, 1.0);
    float tmpvar_45;
    tmpvar_45 = clamp (((backgroundclicktimer.w - 2.2) / -1.7), 0.0, 1.0);
    highp float tmpvar_46;
    tmpvar_46 = max (max (max (
      (((1.0 - (tmpvar_32 * 
        (tmpvar_32 * (3.0 - (2.0 * tmpvar_32)))
      )) * (1.0 - tmpvar_20)) * (tmpvar_33 * (tmpvar_33 * (3.0 - 
        (2.0 * tmpvar_33)
      ))))
    , 
      (((1.0 - (tmpvar_36 * 
        (tmpvar_36 * (3.0 - (2.0 * tmpvar_36)))
      )) * (1.0 - tmpvar_20)) * (tmpvar_37 * (tmpvar_37 * (3.0 - 
        (2.0 * tmpvar_37)
      ))))
    ), (
      ((1.0 - (tmpvar_40 * (tmpvar_40 * 
        (3.0 - (2.0 * tmpvar_40))
      ))) * (1.0 - tmpvar_20))
     * 
      (tmpvar_41 * (tmpvar_41 * (3.0 - (2.0 * tmpvar_41))))
    )), ((
      (1.0 - (tmpvar_44 * (tmpvar_44 * (3.0 - 
        (2.0 * tmpvar_44)
      ))))
     * 
      (1.0 - tmpvar_20)
    ) * (tmpvar_45 * 
      (tmpvar_45 * (3.0 - (2.0 * tmpvar_45)))
    )));
    n_5 = (mix (tmpvar_28.x, tmpvar_28.y, f_25.z) + tmpvar_46);
    t_6 = ((0.8 * (1.0 - 
      pow (tmpvar_3.y, 0.5)
    )) + (0.2 * (1.0 - n_5)));
    col_4 = (0.5 * abs(sin(
      (vec3(2.6, 2.6, 2.6) + (fract((
        sin(dot (tmpvar_22.xy, vec2(127.1, 311.7)))
       * 43758.55)) * 0.4))
    )));
    lowp float tmpvar_47;
    tmpvar_47 = clamp (((tmpvar_18 - t_6) / (
      (0.1 + t_6)
     - t_6)), 0.0, 1.0);
    col_4 = (col_4 * (tmpvar_47 * (tmpvar_47 * 
      (3.0 - (2.0 * tmpvar_47))
    )));
    col_4 = (col_4 * (1.0 + (
      (0.5 * tmpvar_18)
     * n_5)));
    col_4 = (col_4 * (1.0 + (0.5 * 
      (vec3(0.5, 0.5, 0.5) + (vec3(0.5, 0.5, 0.5) * cos((6.283159 * 
        ((u_time * vec3(0.0, 0.02, 0.04)) + vec3(0.25, 0.2, 0.55))
      ))))
    )));
    col_4 = (col_4 * (0.7 + (0.3 * 
      (vec3(0.5, 0.5, 0.5) + (vec3(0.5, 0.5, 0.5) * cos((6.283159 * 
        ((vec3(0.3, 1.0, 1.0) * ((tmpvar_3.y - 0.8) - (u_time * 0.05))) + vec3(0.0, 0.25, 0.325))
      ))))
    )));
    col_4 = (col_4 * pow ((
      (((16.0 * tmpvar_3.x) * (1.0 - tmpvar_3.x)) * tmpvar_3.y)
     * 
      (1.0 - tmpvar_3.y)
    ), 0.4));
    uv_2 = (0.5 + ((tmpvar_3 - 0.5) * (0.83 - 
      (n_5 * 0.2)
    )));
    lowp vec4 tmpvar_48;
    tmpvar_48.w = 1.0;
    tmpvar_48.xyz = (vec3(0.41176, 0.53333, 0.78431) * min (vec3(8.0, 8.0, 8.0), (col_4 * 8.5)));
    lowp vec2 tmpvar_49;
    tmpvar_49.x = (uv_2.x + 0.0023);
    tmpvar_49.y = uv_2.y;
    col_4.x = (texture (u_texture2, tmpvar_49).x * (1.0 - (n_5 / 2.5)));
    col_4.y = (texture (u_texture2, uv_2).y * (1.0 - (n_5 / 2.5)));
    lowp vec2 tmpvar_50;
    tmpvar_50.x = (uv_2.x - 0.0023);
    tmpvar_50.y = uv_2.y;
    col_4.z = (texture (u_texture2, tmpvar_50).z * (1.0 - (n_5 / 2.5)));
    col_4 = (clamp ((
      (col_4 * 0.5)
     + 
      ((0.6 * col_4) * col_4)
    ), 0.0, 1.0) * (0.5 + (
      (((8.0 * uv_2.x) * uv_2.y) * (1.0 - uv_2.x))
     * 
      (1.0 - uv_2.y)
    )));
    col_4 = (col_4 * vec3(0.95, 1.05, 0.95));
    col_4 = (col_4 * (0.9 + (0.1 * 
      sin(((10.0 * u_time) + (uv_2.y * 1000.0)))
    )));
    col_4 = (col_4 * (0.99 + (0.01 * 
      sin(u_time)
    )));
    float tmpvar_51;
    float tmpvar_52;
    tmpvar_52 = clamp (((
      (1.0 - backgroundtime)
     - 0.2) / 0.5), 0.0, 1.0);
    tmpvar_51 = (tmpvar_52 * (tmpvar_52 * (3.0 - 
      (2.0 * tmpvar_52)
    )));
    lowp vec3 tmpvar_53;
    tmpvar_53 = mix (col_4, texture (u_texture2, tmpvar_3).xyz, clamp ((
      (-2.0 + (2.0 * tmpvar_3.x))
     + 
      (3.0 * tmpvar_51)
    ), 0.0, 1.0));
    col_4 = tmpvar_53;
    lowp vec4 tmpvar_54;
    tmpvar_54.w = 1.0;
    tmpvar_54.xyz = tmpvar_53;
    tmpvar_1 = (((tmpvar_48 * 
      (n_5 * 1.5)
    ) * (1.0 - 
      clamp (((-2.0 + (2.0 * tmpvar_3.x)) + (3.0 * tmpvar_51)), 0.0, 1.0)
    )) + tmpvar_54);
  } else {
    tmpvar_1 = texture (u_texture2, uv_2);
  };
  glFragColor = tmpvar_1;
}

