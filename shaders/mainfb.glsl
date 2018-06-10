#version 300 es
precision highp float;
uniform float rot;
uniform vec2 u_resolution;
uniform vec2 pos;
uniform highp int viuu;
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
  highp vec2 col_2;
  highp float d_3;
  vec2 im_4;
  highp vec2 uv_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((tmpvar_1 / u_resolution.y) - ((u_resolution / u_resolution.y) / 2.0));
  uv_5 = tmpvar_6;
  im_4 = ((pos / u_resolution) - 0.5);
  im_4.x = (im_4.x * (u_resolution.x / u_resolution.y));
  d_3 = 0.45;
  mat2 tmpvar_7;
  float tmpvar_8;
  tmpvar_8 = -(rot);
  tmpvar_7[uint(0)].x = cos(tmpvar_8);
  tmpvar_7[uint(0)].y = -(sin(tmpvar_8));
  tmpvar_7[1u].x = sin(tmpvar_8);
  tmpvar_7[1u].y = cos(tmpvar_8);
  highp vec2 uv_9;
  uv_9 = (((tmpvar_6 + im_4) + (
    (im_4 * vec2(0.0, 0.1213))
   / 33.85)) * tmpvar_7);
  highp float d_10;
  highp int N_11;
  N_11 = 4;
  uv_9 = (uv_9 * 33.85);
  if ((viuu == 2)) {
    N_11 = 3;
    uv_9 = (uv_9 * 0.7);
  };
  if ((viuu == 1)) {
    N_11 = 4;
    uv_9 = (uv_9 * 0.5);
  };
  if ((viuu == 0)) {
    N_11 = 104;
    uv_9 = (uv_9 * 0.5);
  };
  d_10 = 0.0;
  highp float tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (min (abs(
    (uv_9.x / uv_9.y)
  ), 1.0) / max (abs(
    (uv_9.x / uv_9.y)
  ), 1.0));
  highp float tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_13);
  tmpvar_14 = (((
    ((((
      ((((-0.01213232 * tmpvar_14) + 0.05368138) * tmpvar_14) - 0.1173503)
     * tmpvar_14) + 0.1938925) * tmpvar_14) - 0.3326756)
   * tmpvar_14) + 0.9999793) * tmpvar_13);
  tmpvar_14 = (tmpvar_14 + (float(
    (abs((uv_9.x / uv_9.y)) > 1.0)
  ) * (
    (tmpvar_14 * -2.0)
   + 1.570796)));
  tmpvar_12 = (tmpvar_14 * sign((uv_9.x / uv_9.y)));
  if ((abs(uv_9.y) > (1e-08 * abs(uv_9.x)))) {
    if ((uv_9.y < 0.0)) {
      if ((uv_9.x >= 0.0)) {
        tmpvar_12 += 3.141593;
      } else {
        tmpvar_12 = (tmpvar_12 - 3.141593);
      };
    };
  } else {
    tmpvar_12 = (sign(uv_9.x) * 1.570796);
  };
  highp float tmpvar_15;
  tmpvar_15 = (tmpvar_12 + 3.14158);
  float tmpvar_16;
  tmpvar_16 = (6.283159 / float(N_11));
  d_10 = (cos((
    (floor((0.5 + (tmpvar_15 / tmpvar_16))) * tmpvar_16)
   - tmpvar_15)) * sqrt(dot (uv_9, uv_9)));
  highp float tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = clamp (((d_10 - 0.24) / 0.41), 0.0, 1.0);
  tmpvar_17 = (tmpvar_18 * (tmpvar_18 * (3.0 - 
    (2.0 * tmpvar_18)
  )));
  if ((viuu == 2)) {
    mat2 tmpvar_19;
    float tmpvar_20;
    tmpvar_20 = -(rot);
    tmpvar_19[uint(0)].x = cos(tmpvar_20);
    tmpvar_19[uint(0)].y = -(sin(tmpvar_20));
    tmpvar_19[1u].x = sin(tmpvar_20);
    tmpvar_19[1u].y = cos(tmpvar_20);
    highp vec2 uv_21;
    uv_21 = ((tmpvar_6 + im_4) * tmpvar_19);
    highp float d_22;
    uv_21 = (uv_21 * 33.85);
    uv_21 = (uv_21 * 0.5);
    d_22 = 0.0;
    highp float tmpvar_23;
    highp float tmpvar_24;
    tmpvar_24 = (min (abs(
      (uv_21.x / uv_21.y)
    ), 1.0) / max (abs(
      (uv_21.x / uv_21.y)
    ), 1.0));
    highp float tmpvar_25;
    tmpvar_25 = (tmpvar_24 * tmpvar_24);
    tmpvar_25 = (((
      ((((
        ((((-0.01213232 * tmpvar_25) + 0.05368138) * tmpvar_25) - 0.1173503)
       * tmpvar_25) + 0.1938925) * tmpvar_25) - 0.3326756)
     * tmpvar_25) + 0.9999793) * tmpvar_24);
    tmpvar_25 = (tmpvar_25 + (float(
      (abs((uv_21.x / uv_21.y)) > 1.0)
    ) * (
      (tmpvar_25 * -2.0)
     + 1.570796)));
    tmpvar_23 = (tmpvar_25 * sign((uv_21.x / uv_21.y)));
    if ((abs(uv_21.y) > (1e-08 * abs(uv_21.x)))) {
      if ((uv_21.y < 0.0)) {
        if ((uv_21.x >= 0.0)) {
          tmpvar_23 += 3.141593;
        } else {
          tmpvar_23 = (tmpvar_23 - 3.141593);
        };
      };
    } else {
      tmpvar_23 = (sign(uv_21.x) * 1.570796);
    };
    highp float tmpvar_26;
    tmpvar_26 = (tmpvar_23 + 3.14158);
    d_22 = (cos((
      (floor((0.5 + (tmpvar_26 / 1.57079))) * 1.57079)
     - tmpvar_26)) * sqrt(dot (uv_21, uv_21)));
    highp float tmpvar_27;
    tmpvar_27 = clamp (((d_22 - 0.24) / 0.41), 0.0, 1.0);
    d_3 = min (((tmpvar_17 / 1.5) + (
      (tmpvar_27 * (tmpvar_27 * (3.0 - (2.0 * tmpvar_27))))
     / 20.0)), 0.45);
  } else {
    d_3 = min (tmpvar_17, d_3);
  };
  if (((viuu == 2) && (d_3 > 0.2448))) {
    discard;
  };
  if ((d_3 > 0.448)) {
    discard;
  };
  highp vec2 tmpvar_28;
  tmpvar_28.x = d_3;
  tmpvar_28.y = d_3;
  col_2 = tmpvar_28;
  if ((viuu == 1)) {
    mat2 tmpvar_29;
    float tmpvar_30;
    tmpvar_30 = -(rot);
    tmpvar_29[uint(0)].x = cos(tmpvar_30);
    tmpvar_29[uint(0)].y = -(sin(tmpvar_30));
    tmpvar_29[1u].x = sin(tmpvar_30);
    tmpvar_29[1u].y = cos(tmpvar_30);
    uv_5 = ((tmpvar_6 + im_4) * tmpvar_29);
    highp vec2 uv_31;
    highp float d_32;
    highp int N_33;
    N_33 = 4;
    uv_31 = (uv_5 * 33.85);
    if ((viuu == 2)) {
      N_33 = 3;
      uv_31 = (uv_31 * 0.7);
    };
    if ((viuu == 1)) {
      N_33 = 4;
      uv_31 = (uv_31 * 0.5);
    };
    if ((viuu == 0)) {
      N_33 = 104;
      uv_31 = (uv_31 * 0.5);
    };
    d_32 = 0.0;
    highp float tmpvar_34;
    highp float tmpvar_35;
    tmpvar_35 = (min (abs(
      (uv_31.x / uv_31.y)
    ), 1.0) / max (abs(
      (uv_31.x / uv_31.y)
    ), 1.0));
    highp float tmpvar_36;
    tmpvar_36 = (tmpvar_35 * tmpvar_35);
    tmpvar_36 = (((
      ((((
        ((((-0.01213232 * tmpvar_36) + 0.05368138) * tmpvar_36) - 0.1173503)
       * tmpvar_36) + 0.1938925) * tmpvar_36) - 0.3326756)
     * tmpvar_36) + 0.9999793) * tmpvar_35);
    tmpvar_36 = (tmpvar_36 + (float(
      (abs((uv_31.x / uv_31.y)) > 1.0)
    ) * (
      (tmpvar_36 * -2.0)
     + 1.570796)));
    tmpvar_34 = (tmpvar_36 * sign((uv_31.x / uv_31.y)));
    if ((abs(uv_31.y) > (1e-08 * abs(uv_31.x)))) {
      if ((uv_31.y < 0.0)) {
        if ((uv_31.x >= 0.0)) {
          tmpvar_34 += 3.141593;
        } else {
          tmpvar_34 = (tmpvar_34 - 3.141593);
        };
      };
    } else {
      tmpvar_34 = (sign(uv_31.x) * 1.570796);
    };
    highp float tmpvar_37;
    tmpvar_37 = (tmpvar_34 + 3.14158);
    float tmpvar_38;
    tmpvar_38 = (6.283159 / float(N_33));
    d_32 = (cos((
      (floor((0.5 + (tmpvar_37 / tmpvar_38))) * tmpvar_38)
     - tmpvar_37)) * sqrt(dot (uv_31, uv_31)));
    highp float tmpvar_39;
    highp float tmpvar_40;
    tmpvar_40 = clamp (((d_32 - 0.1824) / 0.2826), 0.0, 1.0);
    tmpvar_39 = (tmpvar_40 * (tmpvar_40 * (3.0 - 
      (2.0 * tmpvar_40)
    )));
    highp vec2 p_41;
    p_41 = (abs(uv_5) * 3.0);
    highp vec2 x_42;
    x_42 = (mix (vec2(0.07621861, 0.07621861), vec2(0.0, 0.07621861), clamp (
      (dot ((p_41 - vec2(0.07621861, 0.07621861)), vec2(-0.07621861, 0.0)) / 0.005809277)
    , 0.0, 1.0)) - p_41);
    highp vec2 p_43;
    p_43 = (abs(uv_5) * 3.0);
    highp vec2 x_44;
    x_44 = (mix (vec2(0.07621861, 0.07621861), vec2(0.07621861, 0.0), clamp (
      (dot ((p_43 - vec2(0.07621861, 0.07621861)), vec2(0.0, -0.07621861)) / 0.005809277)
    , 0.0, 1.0)) - p_43);
    col_2 = (vec2(0.003, 0.02) / (sqrt(
      dot (x_42, x_42)
    ) / 5.0));
    col_2 = (col_2 + (vec2(0.003, 0.02) / (
      sqrt(dot (x_44, x_44))
     / 5.0)));
    highp float tmpvar_45;
    tmpvar_45 = clamp (((
      (d_3 * tmpvar_39)
     - 0.4) / -0.4), 0.0, 1.0);
    highp float tmpvar_46;
    tmpvar_46 = clamp (((
      (1.0 - d_3)
     * tmpvar_39) / 0.25), 0.0, 1.0);
    col_2 = (col_2 * ((
      (tmpvar_45 * (tmpvar_45 * (3.0 - (2.0 * tmpvar_45))))
     * 2.0) * (tmpvar_46 * 
      (tmpvar_46 * (3.0 - (2.0 * tmpvar_46)))
    )));
  } else {
    if ((viuu == 2)) {
      mat2 tmpvar_47;
      float tmpvar_48;
      tmpvar_48 = -(rot);
      tmpvar_47[uint(0)].x = cos(tmpvar_48);
      tmpvar_47[uint(0)].y = -(sin(tmpvar_48));
      tmpvar_47[1u].x = sin(tmpvar_48);
      tmpvar_47[1u].y = cos(tmpvar_48);
      uv_5 = (((uv_5 + im_4) + (
        (im_4 * vec2(0.0, 0.1213))
       / 33.85)) * tmpvar_47);
      highp vec2 uv_49;
      highp float d_50;
      highp int N_51;
      N_51 = 4;
      uv_49 = (uv_5 * 33.85);
      if ((viuu == 2)) {
        N_51 = 3;
        uv_49 = (uv_49 * 0.7);
      };
      if ((viuu == 1)) {
        N_51 = 4;
        uv_49 = (uv_49 * 0.5);
      };
      if ((viuu == 0)) {
        N_51 = 104;
        uv_49 = (uv_49 * 0.5);
      };
      d_50 = 0.0;
      highp float tmpvar_52;
      highp float tmpvar_53;
      tmpvar_53 = (min (abs(
        (uv_49.x / uv_49.y)
      ), 1.0) / max (abs(
        (uv_49.x / uv_49.y)
      ), 1.0));
      highp float tmpvar_54;
      tmpvar_54 = (tmpvar_53 * tmpvar_53);
      tmpvar_54 = (((
        ((((
          ((((-0.01213232 * tmpvar_54) + 0.05368138) * tmpvar_54) - 0.1173503)
         * tmpvar_54) + 0.1938925) * tmpvar_54) - 0.3326756)
       * tmpvar_54) + 0.9999793) * tmpvar_53);
      tmpvar_54 = (tmpvar_54 + (float(
        (abs((uv_49.x / uv_49.y)) > 1.0)
      ) * (
        (tmpvar_54 * -2.0)
       + 1.570796)));
      tmpvar_52 = (tmpvar_54 * sign((uv_49.x / uv_49.y)));
      if ((abs(uv_49.y) > (1e-08 * abs(uv_49.x)))) {
        if ((uv_49.y < 0.0)) {
          if ((uv_49.x >= 0.0)) {
            tmpvar_52 += 3.141593;
          } else {
            tmpvar_52 = (tmpvar_52 - 3.141593);
          };
        };
      } else {
        tmpvar_52 = (sign(uv_49.x) * 1.570796);
      };
      highp float tmpvar_55;
      tmpvar_55 = (tmpvar_52 + 3.14158);
      float tmpvar_56;
      tmpvar_56 = (6.283159 / float(N_51));
      d_50 = (cos((
        (floor((0.5 + (tmpvar_55 / tmpvar_56))) * tmpvar_56)
       - tmpvar_55)) * sqrt(dot (uv_49, uv_49)));
      highp float tmpvar_57;
      highp float tmpvar_58;
      tmpvar_58 = clamp (((d_50 - 0.1824) / 0.2826), 0.0, 1.0);
      tmpvar_57 = (tmpvar_58 * (tmpvar_58 * (3.0 - 
        (2.0 * tmpvar_58)
      )));
      highp vec2 p_59;
      p_59 = (uv_5 * 3.0);
      highp vec2 x_60;
      x_60 = (mix (vec2(-0.07621861, -0.07621861), vec2(0.07621861, -0.07621861), clamp (
        (dot ((p_59 - vec2(-0.07621861, -0.07621861)), vec2(0.1524372, 0.0)) / 0.02323711)
      , 0.0, 1.0)) - p_59);
      highp vec2 tmpvar_61;
      tmpvar_61.x = abs(uv_5.x);
      tmpvar_61.y = uv_5.y;
      highp vec2 p_62;
      p_62 = (tmpvar_61 * 3.0);
      highp vec2 x_63;
      x_63 = (mix (vec2(0.07621861, -0.07621861), vec2(0.0, 0.07621861), clamp (
        (dot ((p_62 - vec2(0.07621861, -0.07621861)), vec2(-0.07621861, 0.1524372)) / 0.02904638)
      , 0.0, 1.0)) - p_62);
      col_2 = (vec2(0.003, 0.02) / (sqrt(
        dot (x_60, x_60)
      ) / 5.0));
      col_2 = (col_2 + (vec2(0.003, 0.02) / (
        sqrt(dot (x_63, x_63))
       / 5.0)));
      highp float tmpvar_64;
      tmpvar_64 = clamp (((
        (d_3 * tmpvar_57)
       - 0.21) / -0.21), 0.0, 1.0);
      highp float tmpvar_65;
      tmpvar_65 = clamp (((
        (1.0 - d_3)
       * tmpvar_57) / 0.2), 0.0, 1.0);
      col_2 = (col_2 * ((
        (tmpvar_64 * (tmpvar_64 * (3.0 - (2.0 * tmpvar_64))))
       * 2.0) * (tmpvar_65 * 
        (tmpvar_65 * (3.0 - (2.0 * tmpvar_65)))
      )));
    } else {
      if ((viuu == 0)) {
        mat2 tmpvar_66;
        float tmpvar_67;
        tmpvar_67 = -(rot);
        tmpvar_66[uint(0)].x = cos(tmpvar_67);
        tmpvar_66[uint(0)].y = -(sin(tmpvar_67));
        tmpvar_66[1u].x = sin(tmpvar_67);
        tmpvar_66[1u].y = cos(tmpvar_67);
        uv_5 = ((uv_5 + im_4) * tmpvar_66);
        highp float tmpvar_68;
        tmpvar_68 = clamp (((
          sqrt(dot (uv_5, uv_5))
         - 0.01578948) / 0.002631577), 0.0, 1.0);
        highp float tmpvar_69;
        tmpvar_69 = clamp (((
          sqrt(dot (uv_5, uv_5))
         - 0.02631579) / -0.003947368), 0.0, 1.0);
        col_2 = ((vec2(4.075, 17.5) * (tmpvar_68 * 
          (tmpvar_68 * (3.0 - (2.0 * tmpvar_68)))
        )) * (tmpvar_69 * (tmpvar_69 * 
          (3.0 - (2.0 * tmpvar_69))
        )));
      };
    };
  };
  highp vec4 tmpvar_70;
  tmpvar_70.w = 1.0;
  tmpvar_70.x = d_3;
  tmpvar_70.yz = col_2;
  glFragColor = tmpvar_70;
}

