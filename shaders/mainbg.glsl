#version 300 es
precision highp float;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture1;
uniform sampler2D u_texture2;
uniform sampler2D u_texture3;
uniform float u_time;
uniform float playervtime;
out lowp vec4 glFragColor;
uniform highp int numlgths;
uniform highp int maxlgth;
uniform bool sdwsxd;
uniform bool fxaa;
uniform bool isdead;
uniform vec2 playerpos;
uniform highp int plhp;
vec2 res;
vec2 hpo;

// License Creative Commons Attribution-NonCommercial-ShareAlike

// opensource
// please dont use it for sell on google/apple store thanks

//original GLSL source on my github https://github.com/danilw
//this is obfuscated/optimized source

void main ()
{
  lowp vec4 vxxz_1;
  lowp vec4 c1_2;
  lowp vec4 boxes_3;
  lowp vec4 mii_4;
  highp vec3 color_5;
  highp float c_6;
  highp float cs_7;
  lowp vec4 fragColor_8;
  highp vec2 uv_9;
  highp vec2 uv0_10;
  highp float t_11;
  highp vec2 tmpvar_12;
  tmpvar_12 = (((2.0 * 
    (gl_FragCoord.xy - (0.5 * u_resolution))
  ) / u_resolution.y) + vec2(0.25, 0.0));
  uv0_10.y = tmpvar_12.y;
  uv0_10.x = (tmpvar_12.x * 0.981);
  highp vec2 tmpvar_13;
  tmpvar_13 = (gl_FragCoord.xy / u_resolution);
  uv_9 = (((uv0_10 + vec2(1.0, 1.0)) / 2.0) * 8.0);
  highp vec2 tmpvar_14;
  tmpvar_14 = floor(uv_9);
  uv_9 = ((2.0 * fract(uv_9)) - vec2(1.0, 1.0));
  vec2 tmpvar_15;
  tmpvar_15.x = u_mouse.x;
  tmpvar_15.y = (u_resolution.y - u_mouse.y);
  t_11 = (((
    ((playerpos.x / u_resolution.x) - 0.5)
   - 0.765) / 1.1) / 2.25);
  t_11 = ((t_11 + (tmpvar_14.x / 8.0)) + (tmpvar_14.y / 2.0));
  t_11 = (2.0 * abs((
    fract(t_11)
   - 0.5)));
  highp float tmpvar_16;
  tmpvar_16 = clamp (t_11, 0.0, 1.0);
  t_11 = ((2.0 * (tmpvar_16 * 
    (tmpvar_16 * (3.0 - (2.0 * tmpvar_16)))
  )) - 1.0);
  vec2 tmpvar_17;
  tmpvar_17.y = 0.0;
  tmpvar_17.x = (4.0 * (1.0/(u_resolution.y)));
  highp vec2 uv_18;
  uv_18 = (uv_9 + tmpvar_17);
  highp float tmpvar_19;
  tmpvar_19 = ((2.0 * t_11) * pow ((1.0 - 
    (sqrt(dot (uv_18, uv_18)) / 1.414214)
  ), 1.5));
  highp mat2 tmpvar_20;
  tmpvar_20[uint(0)].x = cos(tmpvar_19);
  tmpvar_20[uint(0)].y = sin(tmpvar_19);
  tmpvar_20[1u].x = -(sin(tmpvar_19));
  tmpvar_20[1u].y = cos(tmpvar_19);
  uv_18 = (tmpvar_20 * uv_18);
  uv_18 = (abs(uv_18) / 1.414214);
  highp vec2 uv_21;
  uv_21 = (uv_9 - tmpvar_17);
  highp float tmpvar_22;
  tmpvar_22 = ((2.0 * t_11) * pow ((1.0 - 
    (sqrt(dot (uv_21, uv_21)) / 1.414214)
  ), 1.5));
  highp mat2 tmpvar_23;
  tmpvar_23[uint(0)].x = cos(tmpvar_22);
  tmpvar_23[uint(0)].y = sin(tmpvar_22);
  tmpvar_23[1u].x = -(sin(tmpvar_22));
  tmpvar_23[1u].y = cos(tmpvar_22);
  uv_21 = (tmpvar_23 * uv_21);
  uv_21 = (abs(uv_21) / 1.414214);
  highp vec2 uv_24;
  uv_24 = (uv_9 + tmpvar_17.yx);
  highp float tmpvar_25;
  tmpvar_25 = ((2.0 * t_11) * pow ((1.0 - 
    (sqrt(dot (uv_24, uv_24)) / 1.414214)
  ), 1.5));
  highp mat2 tmpvar_26;
  tmpvar_26[uint(0)].x = cos(tmpvar_25);
  tmpvar_26[uint(0)].y = sin(tmpvar_25);
  tmpvar_26[1u].x = -(sin(tmpvar_25));
  tmpvar_26[1u].y = cos(tmpvar_25);
  uv_24 = (tmpvar_26 * uv_24);
  uv_24 = (abs(uv_24) / 1.414214);
  highp vec2 uv_27;
  uv_27 = (uv_9 - tmpvar_17.yx);
  highp float tmpvar_28;
  tmpvar_28 = ((2.0 * t_11) * pow ((1.0 - 
    (sqrt(dot (uv_27, uv_27)) / 1.414214)
  ), 1.5));
  highp mat2 tmpvar_29;
  tmpvar_29[uint(0)].x = cos(tmpvar_28);
  tmpvar_29[uint(0)].y = sin(tmpvar_28);
  tmpvar_29[1u].x = -(sin(tmpvar_28));
  tmpvar_29[1u].y = cos(tmpvar_28);
  uv_27 = (tmpvar_29 * uv_27);
  uv_27 = (abs(uv_27) / 1.414214);
  highp vec2 tmpvar_30;
  tmpvar_30.x = (max (uv_18.x, uv_18.y) - max (uv_21.x, uv_21.y));
  tmpvar_30.y = (max (uv_24.x, uv_24.y) - max (uv_27.x, uv_27.y));
  highp vec2 tmpvar_31;
  tmpvar_31 = (tmpvar_30 / (2.0 * tmpvar_17.x));
  highp vec3 tmpvar_32;
  tmpvar_32.xy = vec2(1.0, 0.0);
  tmpvar_32.z = tmpvar_31.x;
  highp vec3 tmpvar_33;
  tmpvar_33.xy = vec2(0.0, 1.0);
  tmpvar_33.z = tmpvar_31.y;
  highp vec2 tmpvar_34;
  tmpvar_34 = (tmpvar_13 - (tmpvar_15 / u_resolution));
  highp vec2 tmpvar_35;
  tmpvar_35 = (tmpvar_13 - (tmpvar_15 / u_resolution));
  highp vec3 tmpvar_36;
  tmpvar_36.z = 1.0;
  tmpvar_36.x = (1.0 + (6.0 * sqrt(
    dot (tmpvar_34, tmpvar_34)
  )));
  tmpvar_36.y = (-1.0 - (6.0 * sqrt(
    dot (tmpvar_35, tmpvar_35)
  )));
  highp vec3 tmpvar_37;
  tmpvar_37 = normalize(tmpvar_36);
  highp float tmpvar_38;
  tmpvar_38 = dot (tmpvar_37, normalize((
    (tmpvar_32.yzx * tmpvar_33.zxy)
   - 
    (tmpvar_32.zxy * tmpvar_33.yzx)
  )));
  c_6 = ((0.7 * max (0.0, tmpvar_38)) + (0.07 * max (0.0, 
    -(tmpvar_38)
  )));
  c_6 = (c_6 + (0.1 * pow (
    max (0.0, -(tmpvar_38))
  , 0.5)));
  highp vec2 tmpvar_39;
  tmpvar_39 = abs(uv_9);
  uv_9 = tmpvar_39;
  highp float tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = (1.0 - (max (tmpvar_39.x, tmpvar_39.y) / 1.414214));
  tmpvar_40 = clamp (((tmpvar_41 * tmpvar_41) / 0.2), 0.0, 1.0);
  c_6 = (pow (c_6, 0.8) * (tmpvar_40 * (tmpvar_40 * 
    (3.0 - (2.0 * tmpvar_40))
  )));
  c_6 = (c_6 * mix (0.3, 1.3, pow (
    ((tmpvar_12.y + 1.0) / 2.0)
  , 1.5)));
  uv0_10 = (uv0_10 + vec2(-0.25, -0.0));
  highp float tmpvar_42;
  tmpvar_42 = (1.0 - float((1.5 >= 
    abs(uv0_10.x)
  )));
  c_6 = (c_6 * tmpvar_42);
  cs_7 = (tmpvar_38 * tmpvar_42);
  color_5 = ((floor(
    (90.0 * vec3(c_6))
  ) + vec3(
    greaterThanEqual (fract((90.0 * vec3(c_6))), vec3(fract((sin(
      (u_time + dot (gl_FragCoord.xy, vec2(12.9898, 78.233)))
    ) * 43758.55))))
  )) / 90.0);
  lowp vec4 tmpvar_43;
  tmpvar_43.w = 1.0;
  tmpvar_43.xyz = (color_5 * vec3(0.41176, 0.53333, 0.78431));
  fragColor_8 = tmpvar_43;
  highp float t_44;
  highp vec4 fragColor_45;
  highp vec2 tmpvar_46;
  tmpvar_46 = (((
    (gl_FragCoord.xy + ((u_resolution * cs_7) / 10.0))
   / u_resolution) * 1.25) + 0.8625);
  highp vec2 p_47;
  p_47 = ((tmpvar_46 * u_resolution) / 1500.0);
  float tmpvar_48;
  tmpvar_48 = (0.31 * u_time);
  highp vec2 p_49;
  p_49 = ((p_47 * 5.0) + (0.05 * tmpvar_48));
  highp float d_50;
  highp vec2 tmpvar_51;
  tmpvar_51 = (floor(p_49) + vec2(-1.0, -1.0));
  highp vec2 p_52;
  p_52 = ((p_49 - tmpvar_51) - fract((
    sin((fract((
      sin(tmpvar_51.x)
     * 43.13311)) + tmpvar_51.y))
   * 31.0011)));
  d_50 = min (1e+30, dot (p_52, p_52));
  highp vec2 tmpvar_53;
  tmpvar_53 = (floor(p_49) + vec2(-1.0, 0.0));
  highp vec2 p_54;
  p_54 = ((p_49 - tmpvar_53) - fract((
    sin((fract((
      sin(tmpvar_53.x)
     * 43.13311)) + tmpvar_53.y))
   * 31.0011)));
  d_50 = min (d_50, dot (p_54, p_54));
  highp vec2 tmpvar_55;
  tmpvar_55 = (floor(p_49) + vec2(-1.0, 1.0));
  highp vec2 p_56;
  p_56 = ((p_49 - tmpvar_55) - fract((
    sin((fract((
      sin(tmpvar_55.x)
     * 43.13311)) + tmpvar_55.y))
   * 31.0011)));
  d_50 = min (d_50, dot (p_56, p_56));
  highp vec2 tmpvar_57;
  tmpvar_57 = (floor(p_49) + vec2(0.0, -1.0));
  highp vec2 p_58;
  p_58 = ((p_49 - tmpvar_57) - fract((
    sin((fract((
      sin(tmpvar_57.x)
     * 43.13311)) + tmpvar_57.y))
   * 31.0011)));
  d_50 = min (d_50, dot (p_58, p_58));
  highp vec2 tmpvar_59;
  tmpvar_59 = floor(p_49);
  highp vec2 p_60;
  p_60 = ((p_49 - tmpvar_59) - fract((
    sin((fract((
      sin(tmpvar_59.x)
     * 43.13311)) + tmpvar_59.y))
   * 31.0011)));
  d_50 = min (d_50, dot (p_60, p_60));
  highp vec2 tmpvar_61;
  tmpvar_61 = (floor(p_49) + vec2(0.0, 1.0));
  highp vec2 p_62;
  p_62 = ((p_49 - tmpvar_61) - fract((
    sin((fract((
      sin(tmpvar_61.x)
     * 43.13311)) + tmpvar_61.y))
   * 31.0011)));
  d_50 = min (d_50, dot (p_62, p_62));
  highp vec2 tmpvar_63;
  tmpvar_63 = (floor(p_49) + vec2(1.0, -1.0));
  highp vec2 p_64;
  p_64 = ((p_49 - tmpvar_63) - fract((
    sin((fract((
      sin(tmpvar_63.x)
     * 43.13311)) + tmpvar_63.y))
   * 31.0011)));
  d_50 = min (d_50, dot (p_64, p_64));
  highp vec2 tmpvar_65;
  tmpvar_65 = (floor(p_49) + vec2(1.0, 0.0));
  highp vec2 p_66;
  p_66 = ((p_49 - tmpvar_65) - fract((
    sin((fract((
      sin(tmpvar_65.x)
     * 43.13311)) + tmpvar_65.y))
   * 31.0011)));
  d_50 = min (d_50, dot (p_66, p_66));
  highp vec2 tmpvar_67;
  tmpvar_67 = (floor(p_49) + vec2(1.0, 1.0));
  highp vec2 p_68;
  p_68 = ((p_49 - tmpvar_67) - fract((
    sin((fract((
      sin(tmpvar_67.x)
     * 43.13311)) + tmpvar_67.y))
   * 31.0011)));
  d_50 = min (d_50, dot (p_68, p_68));
  highp vec2 p_69;
  p_69 = (((p_47 * 50.0) + 0.12) + (-0.1 * tmpvar_48));
  highp float d_70;
  highp vec2 tmpvar_71;
  tmpvar_71 = (floor(p_69) + vec2(-1.0, -1.0));
  highp vec2 p_72;
  p_72 = ((p_69 - tmpvar_71) - fract((
    sin((fract((
      sin(tmpvar_71.x)
     * 43.13311)) + tmpvar_71.y))
   * 31.0011)));
  d_70 = min (1e+30, dot (p_72, p_72));
  highp vec2 tmpvar_73;
  tmpvar_73 = (floor(p_69) + vec2(-1.0, 0.0));
  highp vec2 p_74;
  p_74 = ((p_69 - tmpvar_73) - fract((
    sin((fract((
      sin(tmpvar_73.x)
     * 43.13311)) + tmpvar_73.y))
   * 31.0011)));
  d_70 = min (d_70, dot (p_74, p_74));
  highp vec2 tmpvar_75;
  tmpvar_75 = (floor(p_69) + vec2(-1.0, 1.0));
  highp vec2 p_76;
  p_76 = ((p_69 - tmpvar_75) - fract((
    sin((fract((
      sin(tmpvar_75.x)
     * 43.13311)) + tmpvar_75.y))
   * 31.0011)));
  d_70 = min (d_70, dot (p_76, p_76));
  highp vec2 tmpvar_77;
  tmpvar_77 = (floor(p_69) + vec2(0.0, -1.0));
  highp vec2 p_78;
  p_78 = ((p_69 - tmpvar_77) - fract((
    sin((fract((
      sin(tmpvar_77.x)
     * 43.13311)) + tmpvar_77.y))
   * 31.0011)));
  d_70 = min (d_70, dot (p_78, p_78));
  highp vec2 tmpvar_79;
  tmpvar_79 = floor(p_69);
  highp vec2 p_80;
  p_80 = ((p_69 - tmpvar_79) - fract((
    sin((fract((
      sin(tmpvar_79.x)
     * 43.13311)) + tmpvar_79.y))
   * 31.0011)));
  d_70 = min (d_70, dot (p_80, p_80));
  highp vec2 tmpvar_81;
  tmpvar_81 = (floor(p_69) + vec2(0.0, 1.0));
  highp vec2 p_82;
  p_82 = ((p_69 - tmpvar_81) - fract((
    sin((fract((
      sin(tmpvar_81.x)
     * 43.13311)) + tmpvar_81.y))
   * 31.0011)));
  d_70 = min (d_70, dot (p_82, p_82));
  highp vec2 tmpvar_83;
  tmpvar_83 = (floor(p_69) + vec2(1.0, -1.0));
  highp vec2 p_84;
  p_84 = ((p_69 - tmpvar_83) - fract((
    sin((fract((
      sin(tmpvar_83.x)
     * 43.13311)) + tmpvar_83.y))
   * 31.0011)));
  d_70 = min (d_70, dot (p_84, p_84));
  highp vec2 tmpvar_85;
  tmpvar_85 = (floor(p_69) + vec2(1.0, 0.0));
  highp vec2 p_86;
  p_86 = ((p_69 - tmpvar_85) - fract((
    sin((fract((
      sin(tmpvar_85.x)
     * 43.13311)) + tmpvar_85.y))
   * 31.0011)));
  d_70 = min (d_70, dot (p_86, p_86));
  highp vec2 tmpvar_87;
  tmpvar_87 = (floor(p_69) + vec2(1.0, 1.0));
  highp vec2 p_88;
  p_88 = ((p_69 - tmpvar_87) - fract((
    sin((fract((
      sin(tmpvar_87.x)
     * 43.13311)) + tmpvar_87.y))
   * 31.0011)));
  d_70 = min (d_70, dot (p_88, p_88));
  highp vec2 p_89;
  p_89 = ((p_47 * -10.0) + (0.03 * tmpvar_48));
  highp float d_90;
  highp vec2 tmpvar_91;
  tmpvar_91 = (floor(p_89) + vec2(-1.0, -1.0));
  highp vec2 p_92;
  p_92 = ((p_89 - tmpvar_91) - fract((
    sin((fract((
      sin(tmpvar_91.x)
     * 43.13311)) + tmpvar_91.y))
   * 31.0011)));
  d_90 = min (1e+30, dot (p_92, p_92));
  highp vec2 tmpvar_93;
  tmpvar_93 = (floor(p_89) + vec2(-1.0, 0.0));
  highp vec2 p_94;
  p_94 = ((p_89 - tmpvar_93) - fract((
    sin((fract((
      sin(tmpvar_93.x)
     * 43.13311)) + tmpvar_93.y))
   * 31.0011)));
  d_90 = min (d_90, dot (p_94, p_94));
  highp vec2 tmpvar_95;
  tmpvar_95 = (floor(p_89) + vec2(-1.0, 1.0));
  highp vec2 p_96;
  p_96 = ((p_89 - tmpvar_95) - fract((
    sin((fract((
      sin(tmpvar_95.x)
     * 43.13311)) + tmpvar_95.y))
   * 31.0011)));
  d_90 = min (d_90, dot (p_96, p_96));
  highp vec2 tmpvar_97;
  tmpvar_97 = (floor(p_89) + vec2(0.0, -1.0));
  highp vec2 p_98;
  p_98 = ((p_89 - tmpvar_97) - fract((
    sin((fract((
      sin(tmpvar_97.x)
     * 43.13311)) + tmpvar_97.y))
   * 31.0011)));
  d_90 = min (d_90, dot (p_98, p_98));
  highp vec2 tmpvar_99;
  tmpvar_99 = floor(p_89);
  highp vec2 p_100;
  p_100 = ((p_89 - tmpvar_99) - fract((
    sin((fract((
      sin(tmpvar_99.x)
     * 43.13311)) + tmpvar_99.y))
   * 31.0011)));
  d_90 = min (d_90, dot (p_100, p_100));
  highp vec2 tmpvar_101;
  tmpvar_101 = (floor(p_89) + vec2(0.0, 1.0));
  highp vec2 p_102;
  p_102 = ((p_89 - tmpvar_101) - fract((
    sin((fract((
      sin(tmpvar_101.x)
     * 43.13311)) + tmpvar_101.y))
   * 31.0011)));
  d_90 = min (d_90, dot (p_102, p_102));
  highp vec2 tmpvar_103;
  tmpvar_103 = (floor(p_89) + vec2(1.0, -1.0));
  highp vec2 p_104;
  p_104 = ((p_89 - tmpvar_103) - fract((
    sin((fract((
      sin(tmpvar_103.x)
     * 43.13311)) + tmpvar_103.y))
   * 31.0011)));
  d_90 = min (d_90, dot (p_104, p_104));
  highp vec2 tmpvar_105;
  tmpvar_105 = (floor(p_89) + vec2(1.0, 0.0));
  highp vec2 p_106;
  p_106 = ((p_89 - tmpvar_105) - fract((
    sin((fract((
      sin(tmpvar_105.x)
     * 43.13311)) + tmpvar_105.y))
   * 31.0011)));
  d_90 = min (d_90, dot (p_106, p_106));
  highp vec2 tmpvar_107;
  tmpvar_107 = (floor(p_89) + vec2(1.0, 1.0));
  highp vec2 p_108;
  p_108 = ((p_89 - tmpvar_107) - fract((
    sin((fract((
      sin(tmpvar_107.x)
     * 43.13311)) + tmpvar_107.y))
   * 31.0011)));
  d_90 = min (d_90, dot (p_108, p_108));
  highp vec2 tmpvar_109;
  tmpvar_109 = abs(((0.7 * tmpvar_46) - 1.0));
  t_44 = (sqrt(sqrt(
    sqrt((((3.0 * 
      exp((-4.0 * abs((
        (2.5 * d_50)
       - 1.0))))
    ) * sqrt(
      (3.0 * exp((-4.0 * abs(
        ((2.5 * d_70) - 1.0)
      ))))
    )) * sqrt(sqrt(
      (3.0 * exp((-4.0 * abs(
        ((2.5 * d_90) - 1.0)
      ))))
    ))))
  )) * exp(-(
    dot (tmpvar_109, tmpvar_109)
  )));
  highp vec3 tmpvar_110;
  tmpvar_110.x = 0.1;
  tmpvar_110.y = (1.1 * t_44);
  tmpvar_110.z = pow (t_44, (0.5 - t_44));
  highp vec4 tmpvar_111;
  tmpvar_111.w = 1.0;
  tmpvar_111.xyz = (t_44 * tmpvar_110);
  fragColor_45 = (tmpvar_111 * ((tmpvar_111.z / 2.5) + (tmpvar_111.y / 2.0)));
  fragColor_45 = (fragColor_45 * fragColor_45.z);
  highp vec4 tmpvar_112;
  tmpvar_112 = (fragColor_45 * vec4(0.41176, 0.53333, 0.78431, 1.0));
  lowp vec4 tmpvar_113;
  highp vec2 fragCoord_114;
  fragCoord_114 = (gl_FragCoord.xy + ((u_resolution * cs_7) / 10.0));
  highp vec4 fragColor_115;
  highp vec2 tmpvar_116;
  tmpvar_116.x = fragCoord_114.x;
  tmpvar_116.y = (u_resolution.y - fragCoord_114.y);
  vec2 tmpvar_117;
  tmpvar_117.x = (u_resolution.x * 0.7);
  tmpvar_117.y = (u_resolution.y * -0.4);
  vec2 tmpvar_118;
  tmpvar_118.x = (u_resolution.x * 0.8);
  tmpvar_118.y = (u_resolution.y * -0.6);
  highp vec2 tmpvar_119;
  tmpvar_119 = (tmpvar_116 - tmpvar_117);
  highp float tmpvar_120;
  tmpvar_120 = dot (normalize(tmpvar_119), vec2(0.9933391, -0.1152273));
  highp vec2 tmpvar_121;
  tmpvar_121 = (tmpvar_116 - tmpvar_118);
  highp float tmpvar_122;
  tmpvar_122 = dot (normalize(tmpvar_121), vec2(0.9721663, 0.2342921));
  highp vec4 tmpvar_123;
  float tmpvar_124;
  tmpvar_124 = (u_time * 0.5);
  float tmpvar_125;
  tmpvar_125 = (u_time * 0.1);
  tmpvar_123 = ((vec4((
    clamp (((0.45 + (0.15 * 
      sin(((tmpvar_120 * 36.2214) + tmpvar_124))
    )) + (0.3 + (0.2 * 
      cos(((-(tmpvar_120) * 21.11349) + tmpvar_124))
    ))), 0.0, 1.0)
   * 
    clamp (((u_resolution.x - sqrt(
      dot (tmpvar_119, tmpvar_119)
    )) / u_resolution.x), 0.5, 1.0)
  )) * 0.5) + (vec4((
    clamp (((0.45 + (0.15 * 
      sin(((tmpvar_122 * 22.3991) + tmpvar_125))
    )) + (0.3 + (0.2 * 
      cos(((-(tmpvar_122) * 18.0234) + tmpvar_125))
    ))), 0.0, 1.0)
   * 
    clamp (((u_resolution.x - sqrt(
      dot (tmpvar_121, tmpvar_121)
    )) / u_resolution.x), 0.5, 1.0)
  )) * 0.4));
  fragColor_115.w = tmpvar_123.w;
  highp float tmpvar_126;
  tmpvar_126 = (1.0 - (tmpvar_116.y / u_resolution.y));
  fragColor_115.x = (tmpvar_123.x * (0.01 + (tmpvar_126 * 0.8)));
  fragColor_115.y = (tmpvar_123.y * (-0.13 + (tmpvar_126 * 1.16)));
  fragColor_115.z = (tmpvar_123.z * (0.15 + (tmpvar_126 * 1.285)));
  fragColor_115 = (fragColor_115 + fragColor_115);
  tmpvar_113 = fragColor_115;
  mii_4 = tmpvar_113;
  lowp vec4 shadow_127;
  lowp float vf_128;
  vf_128 = tmpvar_113.z;
  lowp vec3 shd2x_129;
  vec2 tmpvar_130;
  tmpvar_130.x = u_resolution.x;
  tmpvar_130.y = float((maxlgth + 4));
  hpo = (0.5 / tmpvar_130);
  res = (u_resolution / u_resolution.y);
  highp vec2 tmpvar_131;
  tmpvar_131 = (((gl_FragCoord.xy + 
    ((u_resolution * cs_7) / 10.0)
  ) / u_resolution.y) - (res / 2.0));
  highp vec2 uv_132;
  uv_132.y = tmpvar_131.y;
  uv_132.x = (tmpvar_131.x * (1.0/((u_resolution.x / u_resolution.y))));
  uv_132 = (uv_132 + 0.5);
  lowp vec4 tmpvar_133;
  tmpvar_133 = texture (u_texture2, uv_132);
  lowp vec3 tmpvar_134;
  tmpvar_134.x = (tmpvar_133.y / 2.0);
  tmpvar_134.yz = tmpvar_133.yz;
  if (sdwsxd) {
    highp vec2 uv_135;
    uv_135 = tmpvar_131;
    lowp float vf_136;
    vf_136 = vf_128;
    lowp vec3 shd2_137;
    lowp vec3 b_139;
    b_139 = vec3(0.1, 0.1, 0.1);
    shd2_137 = vec3(0.1, 0.1, 0.1);
    for (highp int i_138 = 0; i_138 < (numlgths + 4); i_138++) {
      lowp float l_140;
      vec2 tmpvar_141;
      tmpvar_141.x = 0.0;
      tmpvar_141.y = float(i_138);
      vec2 tmpvar_142;
      tmpvar_142.x = u_resolution.x;
      highp int tmpvar_143;
      tmpvar_143 = (maxlgth + 4);
      tmpvar_142.y = float(tmpvar_143);
      lowp vec4 tmpvar_144;
      tmpvar_144 = texture (u_texture1, ((tmpvar_141 / tmpvar_142) + hpo));
      vec2 tmpvar_145;
      tmpvar_145.x = 1.0;
      tmpvar_145.y = float(i_138);
      vec2 tmpvar_146;
      tmpvar_146.x = u_resolution.x;
      tmpvar_146.y = float(tmpvar_143);
      lowp vec4 tmpvar_147;
      tmpvar_147 = texture (u_texture1, ((tmpvar_145 / tmpvar_146) + hpo));
      l_140 = 0.0;
      lowp float tmpvar_148;
      lowp vec2 uv_149;
      uv_149 = (uv_135 - tmpvar_144.yz);
      lowp float tmpvar_150;
      lowp float tmpvar_151;
      tmpvar_151 = (min (abs(
        (uv_149.y / uv_149.x)
      ), 1.0) / max (abs(
        (uv_149.y / uv_149.x)
      ), 1.0));
      lowp float tmpvar_152;
      tmpvar_152 = (tmpvar_151 * tmpvar_151);
      tmpvar_152 = (((
        ((((
          ((((-0.01213232 * tmpvar_152) + 0.05368138) * tmpvar_152) - 0.1173503)
         * tmpvar_152) + 0.1938925) * tmpvar_152) - 0.3326756)
       * tmpvar_152) + 0.9999793) * tmpvar_151);
      tmpvar_152 = (tmpvar_152 + (float(
        (abs((uv_149.y / uv_149.x)) > 1.0)
      ) * (
        (tmpvar_152 * -2.0)
       + 1.570796)));
      tmpvar_150 = (tmpvar_152 * sign((uv_149.y / uv_149.x)));
      if ((abs(uv_149.x) > (1e-08 * abs(uv_149.y)))) {
        if ((uv_149.x < 0.0)) {
          if ((uv_149.y >= 0.0)) {
            tmpvar_150 += 3.141593;
          } else {
            tmpvar_150 = (tmpvar_150 - 3.141593);
          };
        };
      } else {
        tmpvar_150 = (sign(uv_149.y) * 1.570796);
      };
      lowp vec2 tmpvar_153;
      tmpvar_153.x = ((tmpvar_150 / 6.283159) + 0.5);
      tmpvar_153.y = (float(i_138) / float((maxlgth + 4)));
      lowp vec4 tmpvar_154;
      tmpvar_154 = texture (u_texture1, (tmpvar_153 + hpo));
      lowp float tmpvar_155;
      tmpvar_155 = clamp (((
        sqrt(dot (uv_149, uv_149))
       - tmpvar_154.x) / (
        (tmpvar_154.x + 0.02)
       - tmpvar_154.x)), 0.0, 1.0);
      tmpvar_148 = (1.0 - (tmpvar_155 * (tmpvar_155 * 
        (3.0 - (2.0 * tmpvar_155))
      )));
      if ((i_138 < 4)) {
        lowp vec3 tmpvar_156;
        tmpvar_156.z = 0.1;
        tmpvar_156.xy = (uv_135 - tmpvar_144.yz);
        l_140 = (0.01 / pow ((
          (sqrt(dot (tmpvar_156, tmpvar_156)) * vf_136)
         / 2.0), (
          (vf_136 / 2.0)
         * 3.05)));
        lowp float edge0_157;
        edge0_157 = (tmpvar_148 / 2.0);
        lowp float tmpvar_158;
        tmpvar_158 = clamp (((
          (1.0 - vf_136)
         - edge0_157) / (vf_136 - edge0_157)), 0.0, 1.0);
        l_140 = (l_140 * (tmpvar_148 + (tmpvar_158 * 
          (tmpvar_158 * (3.0 - (2.0 * tmpvar_158)))
        )));
        l_140 = (l_140 * vf_136);
        l_140 = (l_140 + (vf_136 / 3.0));
        b_139 = (b_139 + (tmpvar_147.yzw * l_140));
      } else {
        lowp vec3 tmpvar_159;
        tmpvar_159.z = 0.1;
        tmpvar_159.xy = (uv_135 - tmpvar_144.yz);
        lowp float tmpvar_160;
        tmpvar_160 = sqrt(dot (tmpvar_159, tmpvar_159));
        l_140 = (0.01 / (tmpvar_160 * tmpvar_160));
        l_140 = (l_140 * tmpvar_148);
        shd2_137 = (shd2_137 + (tmpvar_147.yzw * l_140));
      };
    };
    shd2x_129 = shd2_137;
    lowp vec4 tmpvar_161;
    tmpvar_161.w = 1.0;
    tmpvar_161.xyz = b_139;
    shadow_127 = tmpvar_161;
  };
  lowp vec4 tmpvar_162;
  tmpvar_162.w = 1.0;
  tmpvar_162.xyz = tmpvar_134;
  boxes_3 = (tmpvar_162.zyxw / 3.0);
  boxes_3.x = (boxes_3.x * 0.4675);
  boxes_3.z = (boxes_3.z * 0.835);
  highp vec2 tmpvar_163;
  tmpvar_163 = (((gl_FragCoord.xy + 
    ((u_resolution * cs_7) / 10.0)
  ) / u_resolution.y) - (res / 2.0));
  highp vec2 uv_164;
  uv_164.y = tmpvar_163.y;
  uv_164.x = (tmpvar_163.x * (1.0/((u_resolution.x / u_resolution.y))));
  uv_164 = (uv_164 + 0.5);
  lowp vec4 tmpvar_165;
  tmpvar_165.w = 1.0;
  tmpvar_165.xyz = texture (u_texture3, uv_164).xyz;
  boxes_3 = (boxes_3 + tmpvar_165);
  if (sdwsxd) {
    lowp vec4 tmpvar_166;
    tmpvar_166.w = 1.0;
    tmpvar_166.xyz = shd2x_129;
    lowp vec4 tmpvar_167;
    tmpvar_167.w = 1.0;
    tmpvar_167.xyz = shd2x_129;
    lowp vec4 tmpvar_168;
    tmpvar_168.w = 1.0;
    tmpvar_168.xyz = shd2x_129;
    mii_4 = (((
      ((tmpvar_112.zyxw * tmpvar_166) * 2.0)
     + 
      ((((
        (min (vec4(1.0, 1.0, 1.0, 1.0), tmpvar_167) * (1.0 - tmpvar_113))
       / 4.3) * tmpvar_112.zyxw) * tmpvar_168) * 2.0)
    ) + (tmpvar_112 * shadow_127)) + ((
      min (vec4(1.0, 1.0, 1.0, 1.0), shadow_127)
    .xzyw * tmpvar_113) / 1.3));
  } else {
    mii_4 = ((mii_4 / 3.0) + (tmpvar_112 / 3.0));
  };
  lowp vec4 tmpvar_169;
  tmpvar_169 = (tmpvar_43 + ((tmpvar_43 * tmpvar_112) * (tmpvar_42 * 3.0)));
  c1_2 = tmpvar_169;
  fragColor_8 = (tmpvar_112 * (1.0 - tmpvar_42));
  highp vec2 fragCoord_170;
  fragCoord_170 = (gl_FragCoord.xy - ((u_resolution * cs_7) / 50.0));
  highp float time_171;
  time_171 = (tmpvar_37.y * 50.0);
  highp vec2 uv0_172;
  time_171 = (time_171 + u_time);
  highp vec2 tmpvar_173;
  if ((fragCoord_170.x > (u_resolution.x / 2.0))) {
    tmpvar_173 = (fragCoord_170 + (u_resolution.x * 0.0055));
  } else {
    tmpvar_173 = fragCoord_170;
  };
  fragCoord_170 = tmpvar_173;
  vec2 tmpvar_174;
  tmpvar_174 = (0.5 * u_resolution);
  uv0_172 = (((
    (2.0 * (tmpvar_173 - tmpvar_174))
   / u_resolution.y) + vec2(0.38525, -0.1255)) * 0.799311);
  uv0_172.x = (uv0_172.x * 0.9819981);
  highp vec2 tmpvar_175;
  tmpvar_175 = ((vec2(mod (uv0_172, 0.2))) - 0.1);
  highp vec2 tmpvar_176;
  float tmpvar_177;
  tmpvar_177 = (u_resolution.y / u_resolution.x);
  tmpvar_176.x = (((uv0_172.x * tmpvar_177) / 2.0) + 0.5);
  tmpvar_176.y = ((uv0_172.y / 2.0) + 0.5);
  highp float tmpvar_178;
  tmpvar_178 = (0.0002 / (abs(tmpvar_175.y) * abs(tmpvar_175.x)));
  highp float tmpvar_179;
  tmpvar_179 = ((sin(time_171) / 2.2) + 1.5);
  highp vec3 tmpvar_180;
  tmpvar_180.x = (tmpvar_178 * tmpvar_179);
  tmpvar_180.y = (((tmpvar_178 * tmpvar_176.x) * (
    (cos(time_171) / 2.2)
   + 1.5)) * tmpvar_179);
  tmpvar_180.z = ((tmpvar_178 * tmpvar_176.y) * tmpvar_176.x);
  highp vec4 tmpvar_181;
  tmpvar_181.w = 1.0;
  tmpvar_181.xyz = tmpvar_180;
  highp vec4 tmpvar_182;
  tmpvar_182 = min (vec4(1.0, 1.0, 1.0, 1.0), ((tmpvar_181 * tmpvar_42).yxxw / 2.0));
  c1_2 = (tmpvar_169 + tmpvar_182);
  highp float time_183;
  time_183 = (tmpvar_37.x * 50.0);
  highp vec2 uv0_184;
  time_183 = (time_183 + u_time);
  uv0_184 = (((
    (2.0 * (gl_FragCoord.xy - tmpvar_174))
   / u_resolution.y) + vec2(0.37825, -0.1255)) * 0.799311);
  uv0_184.x = (uv0_184.x * 0.9819981);
  highp vec2 tmpvar_185;
  tmpvar_185 = ((vec2(mod (uv0_184, 0.2))) - 0.1);
  highp vec2 tmpvar_186;
  tmpvar_186.x = (((uv0_184.x * tmpvar_177) / 2.0) + 0.5);
  tmpvar_186.y = ((uv0_184.y / 2.0) + 0.5);
  highp float tmpvar_187;
  tmpvar_187 = (0.0002 / (abs(tmpvar_185.y) * abs(tmpvar_185.x)));
  highp float tmpvar_188;
  tmpvar_188 = ((sin(time_183) / 2.2) + 1.5);
  highp vec3 tmpvar_189;
  tmpvar_189.x = (tmpvar_187 * tmpvar_188);
  tmpvar_189.y = (((tmpvar_187 * tmpvar_186.x) * (
    (cos(time_183) / 2.2)
   + 1.5)) * tmpvar_188);
  tmpvar_189.z = ((tmpvar_187 * tmpvar_186.y) * tmpvar_186.x);
  highp vec4 tmpvar_190;
  tmpvar_190.w = 1.0;
  tmpvar_190.xyz = tmpvar_189;
  highp float tmpvar_191;
  tmpvar_191 = clamp (((
    abs(uv0_10.y)
   - 0.8838) / 0.1162), 0.0, 1.0);
  highp float tmpvar_192;
  tmpvar_192 = clamp (((
    abs(uv0_10.x)
   - 1.3838) / 0.1162), 0.0, 1.0);
  highp vec4 tmpvar_193;
  tmpvar_193 = (min (vec4(1.0, 1.0, 1.0, 1.0), (
    (tmpvar_190.yxxw / 2.0)
   * 
    (1.0 - tmpvar_42)
  )) * ((tmpvar_191 * 
    (tmpvar_191 * (3.0 - (2.0 * tmpvar_191)))
  ) + (tmpvar_192 * 
    (tmpvar_192 * (3.0 - (2.0 * tmpvar_192)))
  )));
  fragColor_8 = (((mii_4 * 
    (1.0 - tmpvar_42)
  ) + (mii_4 * tmpvar_42)) + ((fragColor_8.zyyw * tmpvar_193) * 20.0));
  fragColor_8 = (fragColor_8 + (c1_2 + (tmpvar_112 * tmpvar_42)));
  if (sdwsxd) {
    vxxz_1 = (((boxes_3 * tmpvar_112) * 3.0) + ((boxes_3 * mii_4) * 2.0));
  } else {
    vxxz_1 = (((
      (boxes_3.yyxw / 2.2)
     + 
      ((boxes_3.yyxw * tmpvar_112) / 2.0)
    ) + (tmpvar_112 / 3.0)) + ((boxes_3 * mii_4) / 2.0));
    vxxz_1 = (vxxz_1 * 0.5);
  };
  fragColor_8 = (fragColor_8 + vxxz_1);
  fragColor_8.xyz = min (vec3(1.0, 1.0, 1.0), fragColor_8.xyz);
  fragColor_8.xyz = max (vec3(0.0, 0.0, 0.0), fragColor_8.xyz);
  fragColor_8.w = 1.0;
  lowp vec4 tmpvar_194;
  highp vec2 fragCoord_195;
  highp vec4 tmpvar_196;
  highp float x_197;
  highp vec4 fragColor_198;
  highp vec4 cx_199;
  fragCoord_195 = (gl_FragCoord.xy * 3.0);
  float tmpvar_200;
  tmpvar_200 = (u_resolution.x / 2.24299);
  vec2 tmpvar_201;
  tmpvar_201.x = playerpos.x;
  tmpvar_201.y = (u_resolution.y - playerpos.y);
  vec2 tmpvar_202;
  tmpvar_202 = ((-(tmpvar_201) * 3.0) + (u_resolution / 2.0));
  fragCoord_195 = (fragCoord_195 + tmpvar_202);
  vec2 tmpvar_203;
  tmpvar_203.x = (tmpvar_200 / 2.25);
  tmpvar_203.y = (-(tmpvar_200) / 15.0);
  highp vec2 x_204;
  x_204 = ((fragCoord_195 - (tmpvar_200 / 1.45)) - tmpvar_203);
  highp float tmpvar_205;
  tmpvar_205 = float((sqrt(
    dot (x_204, x_204)
  ) >= (tmpvar_200 / 1.45)));
  if (((1.0 - tmpvar_205) <= 0.0)) {
    tmpvar_196 = fragColor_8;
  } else {
    highp vec2 tmpvar_206;
    tmpvar_206 = (fragCoord_195 / u_resolution);
    highp vec2 uv_207;
    uv_207 = (((
      (2.0 * fragCoord_195)
     - u_resolution) / u_resolution.y) * 1.2);
    highp float tmpvar_208;
    tmpvar_208 = sqrt(dot (uv_207, uv_207));
    highp float tmpvar_209;
    tmpvar_209 = clamp (((tmpvar_208 - 0.94) / 0.00999999), 0.0, 1.0);
    highp vec4 tmpvar_210;
    tmpvar_210.w = 1.0;
    tmpvar_210.xyz = (vec3((0.9 - (0.4 * 
      pow (tmpvar_208, 4.0)
    ))) * (1.0 - (tmpvar_209 * 
      (tmpvar_209 * (3.0 - (2.0 * tmpvar_209)))
    )));
    cx_199.xyz = tmpvar_210.xyz;
    highp float tmpvar_211;
    tmpvar_211 = clamp ((tmpvar_210.x / 0.752), 0.0, 1.0);
    cx_199.w = (tmpvar_211 * (tmpvar_211 * (3.0 - 
      (2.0 * tmpvar_211)
    )));
    if ((u_time < 6.0)) {
      float tmpvar_212;
      float tmpvar_213;
      tmpvar_213 = clamp (((u_time - 6.0) / -1.5), 0.0, 1.0);
      tmpvar_212 = (tmpvar_213 * (tmpvar_213 * (3.0 - 
        (2.0 * tmpvar_213)
      )));
      float tmpvar_214;
      float tmpvar_215;
      tmpvar_215 = clamp (((u_time - 3.0) / 1.5), 0.0, 1.0);
      tmpvar_214 = (tmpvar_215 * (tmpvar_215 * (3.0 - 
        (2.0 * tmpvar_215)
      )));
      float tmpvar_216;
      tmpvar_216 = clamp ((u_time / 3.0), 0.0, 1.0);
      float tmpvar_217;
      tmpvar_217 = ((tmpvar_216 * (tmpvar_216 * 
        (3.0 - (2.0 * tmpvar_216))
      )) * tmpvar_212);
      highp vec2 p_218;
      p_218 = tmpvar_206;
      highp vec2 bp_220;
      highp float rz_221;
      float z2_222;
      float z_223;
      z_223 = 1.5;
      z2_222 = 1.5;
      rz_221 = 0.0;
      bp_220 = tmpvar_206;
      for (float i_219 = 0.0; i_219 <= 3.0; i_219 += 1.0) {
        highp vec2 p_224;
        p_224 = (bp_220 * 2.0);
        highp vec2 tmpvar_225;
        tmpvar_225.x = abs((fract(
          (p_224.x + abs((fract(
            (p_224.y * 2.0)
          ) - 0.5)))
        ) - 0.5));
        tmpvar_225.y = abs((fract(
          (p_224.y + abs((fract(
            (p_224.x * 2.0)
          ) - 0.5)))
        ) - 0.5));
        float a_226;
        a_226 = (u_time * 0.2);
        float tmpvar_227;
        tmpvar_227 = cos(a_226);
        float tmpvar_228;
        tmpvar_228 = sin(a_226);
        mat2 tmpvar_229;
        tmpvar_229[uint(0)].x = tmpvar_227;
        tmpvar_229[uint(0)].y = -(tmpvar_228);
        tmpvar_229[1u].x = tmpvar_228;
        tmpvar_229[1u].y = tmpvar_227;
        p_218 = (p_218 + ((
          (tmpvar_225 * 0.8)
         * tmpvar_229) / z2_222));
        bp_220 = (bp_220 * 1.6);
        z2_222 = (z2_222 * 0.6);
        z_223 = (z_223 * 1.8);
        p_218 = (p_218 * 1.2);
        p_218 = (p_218 * mat2(0.97, 0.242, -0.242, 0.97));
        rz_221 = (rz_221 + (abs(
          (fract((p_218.x + abs(
            (fract(p_218.y) - 0.5)
          ))) - 0.5)
        ) / z_223));
      };
      highp float tmpvar_230;
      tmpvar_230 = (rz_221 * cx_199.w);
      highp vec4 tmpvar_231;
      tmpvar_231.xyz = (((
        (vec3(0.48235, 0.19607, 0.96862) * tmpvar_230)
       * tmpvar_217) + (
        (tmpvar_230 * vec3(0.56078, 0.78823, 0.87843))
       * 
        (tmpvar_214 * tmpvar_212)
      )) + ((tmpvar_210.xyz * 
        (1.0 - tmpvar_212)
      ) * tmpvar_214));
      tmpvar_231.w = cx_199.w;
      cx_199 = tmpvar_231;
    };
    highp float tmpvar_232;
    tmpvar_232 = clamp ((cx_199.x / 0.752), 0.0, 1.0);
    cx_199.w = (tmpvar_232 * (tmpvar_232 * (3.0 - 
      (2.0 * tmpvar_232)
    )));
    if (fxaa) {
      cx_199.xyz = (cx_199.xyz / 1.5);
    };
    highp int v_233;
    highp float y_234;
    highp int iFrame_235;
    highp vec4 fragColor_236;
    fragColor_236 = vec4(0.0, 0.0, 0.0, 0.0);
    iFrame_235 = int((playervtime * 60.0));
    if ((u_time < 6.0)) {
      iFrame_235 = 0;
    };
    vec2 tmpvar_237;
    tmpvar_237 = vec2((54.5 * sqrt((u_resolution.y / 1080.0))));
    vec2 tmpvar_238;
    tmpvar_238.x = 0.0;
    tmpvar_238.y = (-0.8 / u_resolution.y);
    highp vec2 tmpvar_239;
    tmpvar_239 = (((
      floor((fragCoord_195 / tmpvar_237))
     * tmpvar_237) / u_resolution) + tmpvar_238);
    highp vec2 tmpvar_240;
    tmpvar_240 = (((
      (fragCoord_195 / u_resolution)
     - tmpvar_239) * (u_resolution - 
      (u_resolution * vec2(0.0, 0.051))
    )) / tmpvar_237);
    highp float tmpvar_241;
    tmpvar_241 = clamp (((
      -(tmpvar_239.x)
     * 2.0) + (
      (3.0 * float((iFrame_235 - (
        (iFrame_235 / 60)
       * 60))))
     / 60.0)), 0.0, 1.0);
    y_234 = (tmpvar_241 * tmpvar_241);
    highp float tmpvar_242;
    tmpvar_242 = (1.0 - tmpvar_240.y);
    highp float edge0_243;
    edge0_243 = (y_234 - 0.01);
    highp float tmpvar_244;
    tmpvar_244 = clamp (((tmpvar_242 - edge0_243) / (
      (y_234 + 0.01)
     - edge0_243)), 0.0, 1.0);
    highp float edge0_245;
    edge0_245 = (y_234 - 0.01);
    highp float tmpvar_246;
    tmpvar_246 = clamp (((tmpvar_242 - edge0_245) / (
      (y_234 + 0.01)
     - edge0_245)), 0.0, 1.0);
    v_233 = (int((
      (float(mod (float((iFrame_235 / 60)), 3.0)))
     * 
      (1.0 - (tmpvar_244 * (tmpvar_244 * (3.0 - 
        (2.0 * tmpvar_244)
      ))))
    )) + int((
      (float(mod ((float((iFrame_235 / 60)) - 1.0), 3.0)))
     * 
      (tmpvar_246 * (tmpvar_246 * (3.0 - (2.0 * tmpvar_246))))
    )));
    highp vec2 uv_247;
    highp float d_248;
    vec3 c_249;
    highp int N_250;
    uv_247 = (tmpvar_239 * u_resolution);
    N_250 = 4;
    uv_247 = (((2.0 * uv_247) - u_resolution) / u_resolution.y);
    uv_247 = (uv_247 + vec2(0.05, 0.05));
    uv_247 = (uv_247 * 1.85);
    c_249 = vec3(0.0, 0.0, 0.0);
    if ((v_233 == 2)) {
      N_250 = 3;
      uv_247.y = (uv_247.y + 0.213);
      uv_247 = (uv_247 * 0.7);
      c_249 = vec3(-0.07255499, 0.396075, 0.317645);
    };
    if ((v_233 == 1)) {
      N_250 = 4;
      uv_247 = (uv_247 * 0.5);
      c_249 = vec3(0.18039, 0.40785, 0.18196);
    };
    if ((v_233 == 0)) {
      N_250 = 104;
      uv_247 = (uv_247 * 0.5);
      c_249 = vec3(-0.41176, 0.18039, 0.4353);
    };
    d_248 = 0.0;
    highp float tmpvar_251;
    highp float tmpvar_252;
    tmpvar_252 = (min (abs(
      (uv_247.x / uv_247.y)
    ), 1.0) / max (abs(
      (uv_247.x / uv_247.y)
    ), 1.0));
    highp float tmpvar_253;
    tmpvar_253 = (tmpvar_252 * tmpvar_252);
    tmpvar_253 = (((
      ((((
        ((((-0.01213232 * tmpvar_253) + 0.05368138) * tmpvar_253) - 0.1173503)
       * tmpvar_253) + 0.1938925) * tmpvar_253) - 0.3326756)
     * tmpvar_253) + 0.9999793) * tmpvar_252);
    tmpvar_253 = (tmpvar_253 + (float(
      (abs((uv_247.x / uv_247.y)) > 1.0)
    ) * (
      (tmpvar_253 * -2.0)
     + 1.570796)));
    tmpvar_251 = (tmpvar_253 * sign((uv_247.x / uv_247.y)));
    if ((abs(uv_247.y) > (1e-08 * abs(uv_247.x)))) {
      if ((uv_247.y < 0.0)) {
        if ((uv_247.x >= 0.0)) {
          tmpvar_251 += 3.141593;
        } else {
          tmpvar_251 = (tmpvar_251 - 3.141593);
        };
      };
    } else {
      tmpvar_251 = (sign(uv_247.x) * 1.570796);
    };
    highp float tmpvar_254;
    tmpvar_254 = (tmpvar_251 + 3.14158);
    float tmpvar_255;
    tmpvar_255 = (6.283159 / float(N_250));
    d_248 = (cos((
      (floor((0.5 + (tmpvar_254 / tmpvar_255))) * tmpvar_255)
     - tmpvar_254)) * sqrt(dot (uv_247, uv_247)));
    highp float tmpvar_256;
    highp float tmpvar_257;
    tmpvar_257 = clamp (((d_248 - 0.24) / 0.2), 0.0, 1.0);
    tmpvar_256 = (tmpvar_257 * (tmpvar_257 * (3.0 - 
      (2.0 * tmpvar_257)
    )));
    highp vec4 tmpvar_258;
    tmpvar_258.xyz = ((1.0 - tmpvar_256) * c_249);
    tmpvar_258.w = (1.0 - tmpvar_256);
    highp float b_259;
    b_259 = (0.2 * dot (tmpvar_258.xyz, vec3(0.333, 0.333, 0.333)));
    highp vec4 tmpvar_260;
    tmpvar_260.xy = tmpvar_240;
    tmpvar_260.zw = (vec2(1.0, 1.0) - tmpvar_240);
    highp vec4 tmpvar_261;
    highp vec4 edge0_262;
    edge0_262 = vec4((-(b_259) - 0.0035));
    highp vec4 tmpvar_263;
    tmpvar_263 = clamp (((tmpvar_260 - edge0_262) / (vec4(
      (-(b_259) + 0.35)
    ) - edge0_262)), 0.0, 1.0);
    tmpvar_261 = (tmpvar_263 * (tmpvar_263 * (3.0 - 
      (2.0 * tmpvar_263)
    )));
    fragColor_236 = (tmpvar_258 * (0.5 + (
      (0.5 * tmpvar_261.x)
     * 
      ((tmpvar_261.y * tmpvar_261.z) * tmpvar_261.w)
    )));
    highp float tmpvar_264;
    highp vec2 uv_265;
    uv_265 = (tmpvar_240 - 0.102);
    highp vec2 tmpvar_266;
    tmpvar_266.x = 0.0;
    tmpvar_266.y = (y_234 - 1.0);
    highp vec2 uv_267;
    uv_267 = (uv_265 + tmpvar_266);
    highp float d_268;
    highp float color_269;
    highp int N_270;
    N_270 = 0;
    uv_267 = (uv_267 - 0.495);
    if ((v_233 == 2)) {
      N_270 = 3;
      uv_267 = (uv_267 * 2.7);
    };
    if ((v_233 == 1)) {
      N_270 = 4;
      uv_267 = (uv_267 * 1.8);
    };
    if ((v_233 == 0)) {
      N_270 = 104;
      uv_267 = (uv_267 * 1.8);
    };
    color_269 = 0.0;
    d_268 = 0.0;
    highp float tmpvar_271;
    highp float tmpvar_272;
    tmpvar_272 = (min (abs(
      (uv_267.x / uv_267.y)
    ), 1.0) / max (abs(
      (uv_267.x / uv_267.y)
    ), 1.0));
    highp float tmpvar_273;
    tmpvar_273 = (tmpvar_272 * tmpvar_272);
    tmpvar_273 = (((
      ((((
        ((((-0.01213232 * tmpvar_273) + 0.05368138) * tmpvar_273) - 0.1173503)
       * tmpvar_273) + 0.1938925) * tmpvar_273) - 0.3326756)
     * tmpvar_273) + 0.9999793) * tmpvar_272);
    tmpvar_273 = (tmpvar_273 + (float(
      (abs((uv_267.x / uv_267.y)) > 1.0)
    ) * (
      (tmpvar_273 * -2.0)
     + 1.570796)));
    tmpvar_271 = (tmpvar_273 * sign((uv_267.x / uv_267.y)));
    if ((abs(uv_267.y) > (1e-08 * abs(uv_267.x)))) {
      if ((uv_267.y < 0.0)) {
        if ((uv_267.x >= 0.0)) {
          tmpvar_271 += 3.141593;
        } else {
          tmpvar_271 = (tmpvar_271 - 3.141593);
        };
      };
    } else {
      tmpvar_271 = (sign(uv_267.x) * 1.570796);
    };
    highp float tmpvar_274;
    tmpvar_274 = (tmpvar_271 + 3.14158);
    float tmpvar_275;
    tmpvar_275 = (6.283159 / float(N_270));
    d_268 = (cos((
      (floor((0.5 + (tmpvar_274 / tmpvar_275))) * tmpvar_275)
     - tmpvar_274)) * sqrt(dot (uv_267, uv_267)));
    highp float tmpvar_276;
    tmpvar_276 = clamp (((d_268 - 0.354) / 0.287), 0.0, 1.0);
    color_269 = (1.0 - (tmpvar_276 * (tmpvar_276 * 
      (3.0 - (2.0 * tmpvar_276))
    )));
    highp vec2 tmpvar_277;
    tmpvar_277.x = 0.0;
    tmpvar_277.y = y_234;
    highp vec2 uv_278;
    uv_278 = (uv_265 + tmpvar_277);
    highp float d_279;
    highp float color_280;
    highp int N_281;
    N_281 = 0;
    uv_278 = (uv_278 - 0.495);
    if ((v_233 == 2)) {
      N_281 = 3;
      uv_278 = (uv_278 * 2.7);
    };
    if ((v_233 == 1)) {
      N_281 = 4;
      uv_278 = (uv_278 * 1.8);
    };
    if ((v_233 == 0)) {
      N_281 = 104;
      uv_278 = (uv_278 * 1.8);
    };
    color_280 = 0.0;
    d_279 = 0.0;
    highp float tmpvar_282;
    highp float tmpvar_283;
    tmpvar_283 = (min (abs(
      (uv_278.x / uv_278.y)
    ), 1.0) / max (abs(
      (uv_278.x / uv_278.y)
    ), 1.0));
    highp float tmpvar_284;
    tmpvar_284 = (tmpvar_283 * tmpvar_283);
    tmpvar_284 = (((
      ((((
        ((((-0.01213232 * tmpvar_284) + 0.05368138) * tmpvar_284) - 0.1173503)
       * tmpvar_284) + 0.1938925) * tmpvar_284) - 0.3326756)
     * tmpvar_284) + 0.9999793) * tmpvar_283);
    tmpvar_284 = (tmpvar_284 + (float(
      (abs((uv_278.x / uv_278.y)) > 1.0)
    ) * (
      (tmpvar_284 * -2.0)
     + 1.570796)));
    tmpvar_282 = (tmpvar_284 * sign((uv_278.x / uv_278.y)));
    if ((abs(uv_278.y) > (1e-08 * abs(uv_278.x)))) {
      if ((uv_278.y < 0.0)) {
        if ((uv_278.x >= 0.0)) {
          tmpvar_282 += 3.141593;
        } else {
          tmpvar_282 = (tmpvar_282 - 3.141593);
        };
      };
    } else {
      tmpvar_282 = (sign(uv_278.x) * 1.570796);
    };
    highp float tmpvar_285;
    tmpvar_285 = (tmpvar_282 + 3.14158);
    float tmpvar_286;
    tmpvar_286 = (6.283159 / float(N_281));
    d_279 = (cos((
      (floor((0.5 + (tmpvar_285 / tmpvar_286))) * tmpvar_286)
     - tmpvar_285)) * sqrt(dot (uv_278, uv_278)));
    highp float tmpvar_287;
    tmpvar_287 = clamp (((d_279 - 0.354) / 0.287), 0.0, 1.0);
    color_280 = (1.0 - (tmpvar_287 * (tmpvar_287 * 
      (3.0 - (2.0 * tmpvar_287))
    )));
    tmpvar_264 = (color_269 + color_280);
    highp vec2 uv_288;
    uv_288 = (tmpvar_240 + 0.02);
    highp vec2 tmpvar_289;
    tmpvar_289.x = 0.0;
    tmpvar_289.y = (y_234 - 1.0);
    highp vec2 uv_290;
    uv_290 = (uv_288 + tmpvar_289);
    highp float d_291;
    highp float color_292;
    highp int N_293;
    N_293 = 0;
    uv_290 = (uv_290 - 0.495);
    if ((v_233 == 2)) {
      N_293 = 3;
      uv_290 = (uv_290 * 2.7);
    };
    if ((v_233 == 1)) {
      N_293 = 4;
      uv_290 = (uv_290 * 1.8);
    };
    if ((v_233 == 0)) {
      N_293 = 104;
      uv_290 = (uv_290 * 1.8);
    };
    color_292 = 0.0;
    d_291 = 0.0;
    highp float tmpvar_294;
    highp float tmpvar_295;
    tmpvar_295 = (min (abs(
      (uv_290.x / uv_290.y)
    ), 1.0) / max (abs(
      (uv_290.x / uv_290.y)
    ), 1.0));
    highp float tmpvar_296;
    tmpvar_296 = (tmpvar_295 * tmpvar_295);
    tmpvar_296 = (((
      ((((
        ((((-0.01213232 * tmpvar_296) + 0.05368138) * tmpvar_296) - 0.1173503)
       * tmpvar_296) + 0.1938925) * tmpvar_296) - 0.3326756)
     * tmpvar_296) + 0.9999793) * tmpvar_295);
    tmpvar_296 = (tmpvar_296 + (float(
      (abs((uv_290.x / uv_290.y)) > 1.0)
    ) * (
      (tmpvar_296 * -2.0)
     + 1.570796)));
    tmpvar_294 = (tmpvar_296 * sign((uv_290.x / uv_290.y)));
    if ((abs(uv_290.y) > (1e-08 * abs(uv_290.x)))) {
      if ((uv_290.y < 0.0)) {
        if ((uv_290.x >= 0.0)) {
          tmpvar_294 += 3.141593;
        } else {
          tmpvar_294 = (tmpvar_294 - 3.141593);
        };
      };
    } else {
      tmpvar_294 = (sign(uv_290.x) * 1.570796);
    };
    highp float tmpvar_297;
    tmpvar_297 = (tmpvar_294 + 3.14158);
    float tmpvar_298;
    tmpvar_298 = (6.283159 / float(N_293));
    d_291 = (cos((
      (floor((0.5 + (tmpvar_297 / tmpvar_298))) * tmpvar_298)
     - tmpvar_297)) * sqrt(dot (uv_290, uv_290)));
    highp float tmpvar_299;
    tmpvar_299 = clamp (((d_291 - 0.354) / 0.287), 0.0, 1.0);
    color_292 = (1.0 - (tmpvar_299 * (tmpvar_299 * 
      (3.0 - (2.0 * tmpvar_299))
    )));
    highp vec2 tmpvar_300;
    tmpvar_300.x = 0.0;
    tmpvar_300.y = y_234;
    highp vec2 uv_301;
    uv_301 = (uv_288 + tmpvar_300);
    highp float d_302;
    highp float color_303;
    highp int N_304;
    N_304 = 0;
    uv_301 = (uv_301 - 0.495);
    if ((v_233 == 2)) {
      N_304 = 3;
      uv_301 = (uv_301 * 2.7);
    };
    if ((v_233 == 1)) {
      N_304 = 4;
      uv_301 = (uv_301 * 1.8);
    };
    if ((v_233 == 0)) {
      N_304 = 104;
      uv_301 = (uv_301 * 1.8);
    };
    color_303 = 0.0;
    d_302 = 0.0;
    highp float tmpvar_305;
    highp float tmpvar_306;
    tmpvar_306 = (min (abs(
      (uv_301.x / uv_301.y)
    ), 1.0) / max (abs(
      (uv_301.x / uv_301.y)
    ), 1.0));
    highp float tmpvar_307;
    tmpvar_307 = (tmpvar_306 * tmpvar_306);
    tmpvar_307 = (((
      ((((
        ((((-0.01213232 * tmpvar_307) + 0.05368138) * tmpvar_307) - 0.1173503)
       * tmpvar_307) + 0.1938925) * tmpvar_307) - 0.3326756)
     * tmpvar_307) + 0.9999793) * tmpvar_306);
    tmpvar_307 = (tmpvar_307 + (float(
      (abs((uv_301.x / uv_301.y)) > 1.0)
    ) * (
      (tmpvar_307 * -2.0)
     + 1.570796)));
    tmpvar_305 = (tmpvar_307 * sign((uv_301.x / uv_301.y)));
    if ((abs(uv_301.y) > (1e-08 * abs(uv_301.x)))) {
      if ((uv_301.y < 0.0)) {
        if ((uv_301.x >= 0.0)) {
          tmpvar_305 += 3.141593;
        } else {
          tmpvar_305 = (tmpvar_305 - 3.141593);
        };
      };
    } else {
      tmpvar_305 = (sign(uv_301.x) * 1.570796);
    };
    highp float tmpvar_308;
    tmpvar_308 = (tmpvar_305 + 3.14158);
    float tmpvar_309;
    tmpvar_309 = (6.283159 / float(N_304));
    d_302 = (cos((
      (floor((0.5 + (tmpvar_308 / tmpvar_309))) * tmpvar_309)
     - tmpvar_308)) * sqrt(dot (uv_301, uv_301)));
    highp float tmpvar_310;
    tmpvar_310 = clamp (((d_302 - 0.354) / 0.287), 0.0, 1.0);
    color_303 = (1.0 - (tmpvar_310 * (tmpvar_310 * 
      (3.0 - (2.0 * tmpvar_310))
    )));
    fragColor_236.xyz = (fragColor_236.xyz + ((0.935 * 
      clamp ((tmpvar_264 - (color_292 + color_303)), -0.4, 1.0)
    ) * fragColor_236.xyz));
    highp vec2 x_311;
    x_311 = (fragCoord_195 - (u_resolution * 0.5));
    highp float tmpvar_312;
    tmpvar_312 = (sqrt(dot (x_311, x_311)) / u_resolution.x);
    fragColor_236 = (fragColor_236 * (1.2 * (0.8 - 
      ((tmpvar_312 * tmpvar_312) * tmpvar_312)
    )));
    if (isdead) {
      fragColor_236.xyz = vec3(max (max (fragColor_236.x, fragColor_236.y), fragColor_236.z));
    };
    fragColor_198.w = fragColor_236.w;
    fragColor_198.xyz = (fragColor_236.xyz * 0.8);
    x_197 = fragColor_198.w;
    if ((u_time < 6.0)) {
      float tmpvar_313;
      float tmpvar_314;
      tmpvar_314 = clamp (((u_time - 6.0) / -1.5), 0.0, 1.0);
      tmpvar_313 = (tmpvar_314 * (tmpvar_314 * (3.0 - 
        (2.0 * tmpvar_314)
      )));
      float tmpvar_315;
      float tmpvar_316;
      tmpvar_316 = clamp (((u_time - 3.0) / 1.5), 0.0, 1.0);
      tmpvar_315 = (tmpvar_316 * (tmpvar_316 * (3.0 - 
        (2.0 * tmpvar_316)
      )));
      float tmpvar_317;
      float tmpvar_318;
      tmpvar_318 = clamp ((u_time / 3.0), 0.0, 1.0);
      tmpvar_317 = (tmpvar_318 * (tmpvar_318 * (3.0 - 
        (2.0 * tmpvar_318)
      )));
      highp vec2 p_319;
      p_319 = tmpvar_206;
      highp vec2 bp_321;
      highp float rz_322;
      float z2_323;
      float z_324;
      z_324 = 1.5;
      z2_323 = 1.5;
      rz_322 = 0.0;
      bp_321 = tmpvar_206;
      for (float i_320 = 0.0; i_320 <= 3.0; i_320 += 1.0) {
        highp vec2 p_325;
        p_325 = (bp_321 * 2.0);
        highp vec2 tmpvar_326;
        tmpvar_326.x = abs((fract(
          (p_325.x + abs((fract(
            (p_325.y * 2.0)
          ) - 0.5)))
        ) - 0.5));
        tmpvar_326.y = abs((fract(
          (p_325.y + abs((fract(
            (p_325.x * 2.0)
          ) - 0.5)))
        ) - 0.5));
        float a_327;
        a_327 = (u_time * 0.2);
        float tmpvar_328;
        tmpvar_328 = cos(a_327);
        float tmpvar_329;
        tmpvar_329 = sin(a_327);
        mat2 tmpvar_330;
        tmpvar_330[uint(0)].x = tmpvar_328;
        tmpvar_330[uint(0)].y = -(tmpvar_329);
        tmpvar_330[1u].x = tmpvar_329;
        tmpvar_330[1u].y = tmpvar_328;
        p_319 = (p_319 + ((
          (tmpvar_326 * 0.8)
         * tmpvar_330) / z2_323));
        bp_321 = (bp_321 * 1.6);
        z2_323 = (z2_323 * 0.6);
        z_324 = (z_324 * 1.8);
        p_319 = (p_319 * 1.2);
        p_319 = (p_319 * mat2(0.97, 0.242, -0.242, 0.97));
        rz_322 = (rz_322 + (abs(
          (fract((p_319.x + abs(
            (fract(p_319.y) - 0.5)
          ))) - 0.5)
        ) / z_324));
      };
      highp float tmpvar_331;
      tmpvar_331 = (rz_322 * fragColor_236.w);
      highp vec4 tmpvar_332;
      tmpvar_332.xyz = (((
        (vec3(0.56078, 0.78823, 0.87843) * tmpvar_331)
       * 
        (tmpvar_317 * tmpvar_313)
      ) + (
        (tmpvar_331 * vec3(0.9647, 0.90196, 0.88392))
       * 
        (tmpvar_315 * tmpvar_313)
      )) + ((fragColor_198.xyz * 
        (1.0 - tmpvar_313)
      ) * tmpvar_315));
      tmpvar_332.w = (fragColor_236.w * tmpvar_317);
      fragColor_198 = tmpvar_332;
      x_197 = tmpvar_332.w;
    };
    cx_199.xyz = (cx_199.xyz * 0.8);
    fragColor_198 = ((cx_199 * (1.0 - x_197)) + fragColor_198);
    fragColor_198.w = (1.0 - fragColor_198.w);
    highp vec3 col_333;
    float val_334;
    highp vec3 hc_335;
    highp vec2 uv_336;
    uv_336 = (fragCoord_195 / u_resolution);
    highp vec2 tmpvar_337;
    tmpvar_337 = (((
      (2.0 * fragCoord_195)
     - u_resolution) / u_resolution.y) * 0.845);
    highp float tmpvar_338;
    highp float tmpvar_339;
    tmpvar_339 = (min (abs(
      (tmpvar_337.x / tmpvar_337.y)
    ), 1.0) / max (abs(
      (tmpvar_337.x / tmpvar_337.y)
    ), 1.0));
    highp float tmpvar_340;
    tmpvar_340 = (tmpvar_339 * tmpvar_339);
    tmpvar_340 = (((
      ((((
        ((((-0.01213232 * tmpvar_340) + 0.05368138) * tmpvar_340) - 0.1173503)
       * tmpvar_340) + 0.1938925) * tmpvar_340) - 0.3326756)
     * tmpvar_340) + 0.9999793) * tmpvar_339);
    tmpvar_340 = (tmpvar_340 + (float(
      (abs((tmpvar_337.x / tmpvar_337.y)) > 1.0)
    ) * (
      (tmpvar_340 * -2.0)
     + 1.570796)));
    tmpvar_338 = (tmpvar_340 * sign((tmpvar_337.x / tmpvar_337.y)));
    if ((abs(tmpvar_337.y) > (1e-08 * abs(tmpvar_337.x)))) {
      if ((tmpvar_337.y < 0.0)) {
        if ((tmpvar_337.x >= 0.0)) {
          tmpvar_338 += 3.141593;
        } else {
          tmpvar_338 = (tmpvar_338 - 3.141593);
        };
      };
    } else {
      tmpvar_338 = (sign(tmpvar_337.x) * 1.570796);
    };
    highp vec2 tmpvar_341;
    tmpvar_341.x = ((tmpvar_338 / 3.14158) * 2.0);
    tmpvar_341.y = (sqrt(dot (tmpvar_337, tmpvar_337)) * 0.75);
    uv_336 = ((2.0 * tmpvar_341) - 1.0);
    highp float tmpvar_342;
    tmpvar_342 = ((float(mod ((
      abs((uv_336.x - 20.5))
     * 6.0), 2.0))) * (float(mod ((
      (uv_336.x + 20.5)
     * 6.0), 2.0))));
    hc_335 = vec3(0.125, 0.125, 0.125);
    highp float tmpvar_343;
    tmpvar_343 = (float(mod ((uv_336.x + 0.5), 24.0)));
    val_334 = float(plhp);
    if ((u_time < 6.0)) {
      val_334 = ((float(mod (u_time, 24.0))) * 8.0);
      hc_335 = vec3(0.0, 0.0, 0.0);
    };
    highp float tmpvar_344;
    if ((tmpvar_343 > 4.0)) {
      highp float tmpvar_345;
      if ((tmpvar_343 < 19.0)) {
        tmpvar_345 = 4.0;
      } else {
        tmpvar_345 = (tmpvar_343 - 16.0);
      };
      tmpvar_344 = tmpvar_345;
    } else {
      tmpvar_344 = tmpvar_343;
    };
    highp float tmpvar_346;
    tmpvar_346 = floor((tmpvar_344 * 3.0));
    if ((tmpvar_346 < (val_334 + 1.0))) {
      highp vec3 tmpvar_347;
      tmpvar_347.z = 0.0;
      tmpvar_347.x = (1.0 - (tmpvar_346 / 20.0));
      tmpvar_347.y = (tmpvar_346 / 20.0);
      hc_335 = tmpvar_347;
      if ((u_time < 6.0)) {
        float tmpvar_348;
        float tmpvar_349;
        tmpvar_349 = clamp (((u_time - 6.0) / -1.5), 0.0, 1.0);
        tmpvar_348 = (tmpvar_349 * (tmpvar_349 * (3.0 - 
          (2.0 * tmpvar_349)
        )));
        float tmpvar_350;
        float tmpvar_351;
        tmpvar_351 = clamp (((u_time - 3.0) / 1.5), 0.0, 1.0);
        tmpvar_350 = (tmpvar_351 * (tmpvar_351 * (3.0 - 
          (2.0 * tmpvar_351)
        )));
        hc_335 = (((vec3(0.125, 0.125, 0.125) * 
          (1.0 - tmpvar_350)
        ) + (
          (vec3(5.0, 5.0, 5.0) * tmpvar_350)
         * tmpvar_348)) + ((tmpvar_347 * 
          (1.0 - tmpvar_348)
        ) * tmpvar_350));
      };
    };
    highp float tmpvar_352;
    tmpvar_352 = clamp (((
      (uv_336.y - 0.15)
     - -0.215) / 0.115), 0.0, 1.0);
    highp float tmpvar_353;
    tmpvar_353 = clamp (((
      (uv_336.y - 0.15)
     - 0.215) / -0.315), 0.0, 1.0);
    highp vec3 tmpvar_354;
    tmpvar_354 = ((min (15.8, 
      (1.2 * abs((1.0/((30.0 * uv_336.y)))))
    ) * hc_335) * vec3(((
      (tmpvar_352 * (tmpvar_352 * (3.0 - (2.0 * tmpvar_352))))
     * 
      (tmpvar_353 * (tmpvar_353 * (3.0 - (2.0 * tmpvar_353))))
    ) * tmpvar_342)));
    col_333 = tmpvar_354;
    if ((int(tmpvar_346) == 10)) {
      uv_336 = (6.283159 * ((
        (gl_FragCoord.xy * 3.0)
       + tmpvar_202) / u_resolution));
    };
    highp vec2 p_355;
    p_355 = uv_336;
    highp vec2 bp_357;
    highp float rz_358;
    float z2_359;
    float z_360;
    z_360 = 1.5;
    z2_359 = 1.5;
    rz_358 = 0.0;
    bp_357 = uv_336;
    for (float i_356 = 0.0; i_356 <= 3.0; i_356 += 1.0) {
      highp vec2 p_361;
      p_361 = (bp_357 * 2.0);
      highp vec2 tmpvar_362;
      tmpvar_362.x = abs((fract(
        (p_361.x + abs((fract(
          (p_361.y * 2.0)
        ) - 0.5)))
      ) - 0.5));
      tmpvar_362.y = abs((fract(
        (p_361.y + abs((fract(
          (p_361.x * 2.0)
        ) - 0.5)))
      ) - 0.5));
      float a_363;
      a_363 = (u_time * 0.2);
      float tmpvar_364;
      tmpvar_364 = cos(a_363);
      float tmpvar_365;
      tmpvar_365 = sin(a_363);
      mat2 tmpvar_366;
      tmpvar_366[uint(0)].x = tmpvar_364;
      tmpvar_366[uint(0)].y = -(tmpvar_365);
      tmpvar_366[1u].x = tmpvar_365;
      tmpvar_366[1u].y = tmpvar_364;
      p_355 = (p_355 + ((
        (tmpvar_362 * 0.8)
       * tmpvar_366) / z2_359));
      bp_357 = (bp_357 * 1.6);
      z2_359 = (z2_359 * 0.6);
      z_360 = (z_360 * 1.8);
      p_355 = (p_355 * 1.2);
      p_355 = (p_355 * mat2(0.97, 0.242, -0.242, 0.97));
      rz_358 = (rz_358 + (abs(
        (fract((p_355.x + abs(
          (fract(p_355.y) - 0.5)
        ))) - 0.5)
      ) / z_360));
    };
    col_333 = ((tmpvar_354 / 3.0) + ((tmpvar_354 * 2.0) * rz_358));
    highp vec4 tmpvar_367;
    tmpvar_367.xyz = col_333;
    tmpvar_367.w = max (max (col_333.x, col_333.z), col_333.y);
    fragColor_198 = (fragColor_198 + tmpvar_367);
    fragColor_198 = (fragColor_198 + (fragColor_8 * fragColor_198.w));
    highp vec2 uv_368;
    vec2 tmpvar_369;
    tmpvar_369 = (u_resolution / u_resolution.y);
    uv_368 = (((fragCoord_195 / u_resolution.y) - (tmpvar_369 / 2.0)) + 0.5);
    uv_368.x = uv_368.x;
    uv_368 = ((uv_368 * 2.0) - 1.0);
    uv_368 = (uv_368 * 20.0);
    vec2 tmpvar_370;
    tmpvar_370 = ((u_mouse / u_resolution.y) - (tmpvar_369 / 2.0));
    vec2 tmpvar_371;
    tmpvar_371 = ((playerpos / u_resolution.y) - (tmpvar_369 / 2.0));
    float vec_y_372;
    vec_y_372 = (tmpvar_371.y - tmpvar_370.y);
    float vec_x_373;
    vec_x_373 = (tmpvar_371.x - tmpvar_370.x);
    float tmpvar_374;
    float tmpvar_375;
    tmpvar_375 = (min (abs(
      (vec_y_372 / vec_x_373)
    ), 1.0) / max (abs(
      (vec_y_372 / vec_x_373)
    ), 1.0));
    float tmpvar_376;
    tmpvar_376 = (tmpvar_375 * tmpvar_375);
    tmpvar_376 = (((
      ((((
        ((((-0.01213232 * tmpvar_376) + 0.05368138) * tmpvar_376) - 0.1173503)
       * tmpvar_376) + 0.1938925) * tmpvar_376) - 0.3326756)
     * tmpvar_376) + 0.9999793) * tmpvar_375);
    tmpvar_376 = (tmpvar_376 + (float(
      (abs((vec_y_372 / vec_x_373)) > 1.0)
    ) * (
      (tmpvar_376 * -2.0)
     + 1.570796)));
    tmpvar_374 = (tmpvar_376 * sign((vec_y_372 / vec_x_373)));
    if ((abs(vec_x_373) > (1e-08 * abs(vec_y_372)))) {
      if ((vec_x_373 < 0.0)) {
        if ((vec_y_372 >= 0.0)) {
          tmpvar_374 += 3.141593;
        } else {
          tmpvar_374 = (tmpvar_374 - 3.141593);
        };
      };
    } else {
      tmpvar_374 = (sign(vec_y_372) * 1.570796);
    };
    float tmpvar_377;
    tmpvar_377 = cos((3.14158 + tmpvar_374));
    float vec_y_378;
    vec_y_378 = (tmpvar_371.y - tmpvar_370.y);
    float vec_x_379;
    vec_x_379 = (tmpvar_371.x - tmpvar_370.x);
    float tmpvar_380;
    float tmpvar_381;
    tmpvar_381 = (min (abs(
      (vec_y_378 / vec_x_379)
    ), 1.0) / max (abs(
      (vec_y_378 / vec_x_379)
    ), 1.0));
    float tmpvar_382;
    tmpvar_382 = (tmpvar_381 * tmpvar_381);
    tmpvar_382 = (((
      ((((
        ((((-0.01213232 * tmpvar_382) + 0.05368138) * tmpvar_382) - 0.1173503)
       * tmpvar_382) + 0.1938925) * tmpvar_382) - 0.3326756)
     * tmpvar_382) + 0.9999793) * tmpvar_381);
    tmpvar_382 = (tmpvar_382 + (float(
      (abs((vec_y_378 / vec_x_379)) > 1.0)
    ) * (
      (tmpvar_382 * -2.0)
     + 1.570796)));
    tmpvar_380 = (tmpvar_382 * sign((vec_y_378 / vec_x_379)));
    if ((abs(vec_x_379) > (1e-08 * abs(vec_y_378)))) {
      if ((vec_x_379 < 0.0)) {
        if ((vec_y_378 >= 0.0)) {
          tmpvar_380 += 3.141593;
        } else {
          tmpvar_380 = (tmpvar_380 - 3.141593);
        };
      };
    } else {
      tmpvar_380 = (sign(vec_y_378) * 1.570796);
    };
    float tmpvar_383;
    tmpvar_383 = sin((3.14158 + tmpvar_380));
    float vec_y_384;
    vec_y_384 = (tmpvar_371.y - tmpvar_370.y);
    float vec_x_385;
    vec_x_385 = (tmpvar_371.x - tmpvar_370.x);
    float tmpvar_386;
    float tmpvar_387;
    tmpvar_387 = (min (abs(
      (vec_y_384 / vec_x_385)
    ), 1.0) / max (abs(
      (vec_y_384 / vec_x_385)
    ), 1.0));
    float tmpvar_388;
    tmpvar_388 = (tmpvar_387 * tmpvar_387);
    tmpvar_388 = (((
      ((((
        ((((-0.01213232 * tmpvar_388) + 0.05368138) * tmpvar_388) - 0.1173503)
       * tmpvar_388) + 0.1938925) * tmpvar_388) - 0.3326756)
     * tmpvar_388) + 0.9999793) * tmpvar_387);
    tmpvar_388 = (tmpvar_388 + (float(
      (abs((vec_y_384 / vec_x_385)) > 1.0)
    ) * (
      (tmpvar_388 * -2.0)
     + 1.570796)));
    tmpvar_386 = (tmpvar_388 * sign((vec_y_384 / vec_x_385)));
    if ((abs(vec_x_385) > (1e-08 * abs(vec_y_384)))) {
      if ((vec_x_385 < 0.0)) {
        if ((vec_y_384 >= 0.0)) {
          tmpvar_386 += 3.141593;
        } else {
          tmpvar_386 = (tmpvar_386 - 3.141593);
        };
      };
    } else {
      tmpvar_386 = (sign(vec_y_384) * 1.570796);
    };
    float tmpvar_389;
    tmpvar_389 = sin((3.14158 + tmpvar_386));
    float vec_y_390;
    vec_y_390 = (tmpvar_371.y - tmpvar_370.y);
    float vec_x_391;
    vec_x_391 = (tmpvar_371.x - tmpvar_370.x);
    float tmpvar_392;
    float tmpvar_393;
    tmpvar_393 = (min (abs(
      (vec_y_390 / vec_x_391)
    ), 1.0) / max (abs(
      (vec_y_390 / vec_x_391)
    ), 1.0));
    float tmpvar_394;
    tmpvar_394 = (tmpvar_393 * tmpvar_393);
    tmpvar_394 = (((
      ((((
        ((((-0.01213232 * tmpvar_394) + 0.05368138) * tmpvar_394) - 0.1173503)
       * tmpvar_394) + 0.1938925) * tmpvar_394) - 0.3326756)
     * tmpvar_394) + 0.9999793) * tmpvar_393);
    tmpvar_394 = (tmpvar_394 + (float(
      (abs((vec_y_390 / vec_x_391)) > 1.0)
    ) * (
      (tmpvar_394 * -2.0)
     + 1.570796)));
    tmpvar_392 = (tmpvar_394 * sign((vec_y_390 / vec_x_391)));
    if ((abs(vec_x_391) > (1e-08 * abs(vec_y_390)))) {
      if ((vec_x_391 < 0.0)) {
        if ((vec_y_390 >= 0.0)) {
          tmpvar_392 += 3.141593;
        } else {
          tmpvar_392 = (tmpvar_392 - 3.141593);
        };
      };
    } else {
      tmpvar_392 = (sign(vec_y_390) * 1.570796);
    };
    mat2 tmpvar_395;
    tmpvar_395[uint(0)].x = tmpvar_377;
    tmpvar_395[uint(0)].y = -(tmpvar_383);
    tmpvar_395[1u].x = tmpvar_389;
    tmpvar_395[1u].y = cos((3.14158 + tmpvar_392));
    uv_368 = (uv_368 * tmpvar_395);
    uv_368.x = (uv_368.x - 18.5);
    uv_368 = (uv_368 * mat2(0.8660265, -0.4999981, 0.4999981, 0.8660265));
    highp float tmpvar_396;
    highp float tmpvar_397;
    tmpvar_397 = (min (abs(
      (uv_368.x / uv_368.y)
    ), 1.0) / max (abs(
      (uv_368.x / uv_368.y)
    ), 1.0));
    highp float tmpvar_398;
    tmpvar_398 = (tmpvar_397 * tmpvar_397);
    tmpvar_398 = (((
      ((((
        ((((-0.01213232 * tmpvar_398) + 0.05368138) * tmpvar_398) - 0.1173503)
       * tmpvar_398) + 0.1938925) * tmpvar_398) - 0.3326756)
     * tmpvar_398) + 0.9999793) * tmpvar_397);
    tmpvar_398 = (tmpvar_398 + (float(
      (abs((uv_368.x / uv_368.y)) > 1.0)
    ) * (
      (tmpvar_398 * -2.0)
     + 1.570796)));
    tmpvar_396 = (tmpvar_398 * sign((uv_368.x / uv_368.y)));
    if ((abs(uv_368.y) > (1e-08 * abs(uv_368.x)))) {
      if ((uv_368.y < 0.0)) {
        if ((uv_368.x >= 0.0)) {
          tmpvar_396 += 3.141593;
        } else {
          tmpvar_396 = (tmpvar_396 - 3.141593);
        };
      };
    } else {
      tmpvar_396 = (sign(uv_368.x) * 1.570796);
    };
    highp float tmpvar_399;
    tmpvar_399 = clamp (((
      (cos(((
        floor((0.5 + (tmpvar_396 / 2.094386)))
       * 2.094386) - tmpvar_396)) * sqrt(dot (uv_368, uv_368)))
     - 0.54) / 0.3141), 0.0, 1.0);
    vec2 tmpvar_400;
    vec2 tmpvar_401;
    tmpvar_401 = (u_mouse / u_resolution);
    vec2 tmpvar_402;
    tmpvar_402 = (playerpos / u_resolution);
    tmpvar_400 = (tmpvar_402 - tmpvar_401);
    vec2 tmpvar_403;
    tmpvar_403 = (tmpvar_402 - tmpvar_401);
    vec4 tmpvar_404;
    tmpvar_404.zw = vec2(0.0, 1.0);
    tmpvar_404.x = (1.0 - sqrt(dot (tmpvar_400, tmpvar_400)));
    tmpvar_404.y = sqrt(dot (tmpvar_403, tmpvar_403));
    fragColor_198 = (fragColor_198 + ((
      (1.0 - (tmpvar_399 * (tmpvar_399 * (3.0 - 
        (2.0 * tmpvar_399)
      ))))
     / 1.5) * tmpvar_404));
    tmpvar_196 = fragColor_198;
  };
  tmpvar_194 = tmpvar_196;
  fragColor_8 = tmpvar_194;
  glFragColor = tmpvar_194;
}

