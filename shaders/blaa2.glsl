#version 300 es
precision highp float;
uniform vec2 u_resolution;
uniform sampler2D u_texture1;
out lowp vec4 glFragColor;

// License Creative Commons Attribution-NonCommercial-ShareAlike

// opensource
// please dont use it for sell on google/apple store thanks

//original GLSL source on my github https://github.com/danilw
//this is obfuscated/optimized source

void main ()
{
  lowp vec3 acc_1;
  highp vec2 tmpvar_2;
  tmpvar_2 = (gl_FragCoord.xy / u_resolution);
  highp vec2 P_3;
  P_3 = (tmpvar_2 + (vec2(-0.0, -3.0) / u_resolution));
  acc_1 = (texture (u_texture1, P_3).xyz * 0.00598);
  highp vec2 P_4;
  P_4 = (tmpvar_2 + (vec2(-0.0, -2.0) / u_resolution));
  acc_1 = (acc_1 + (texture (u_texture1, P_4).xyz * 0.060626));
  highp vec2 P_5;
  P_5 = (tmpvar_2 + (vec2(-0.0, -1.0) / u_resolution));
  acc_1 = (acc_1 + (texture (u_texture1, P_5).xyz * 0.241843));
  highp vec2 P_6;
  P_6 = (tmpvar_2 + (vec2(0.0, 0.0) / u_resolution));
  acc_1 = (acc_1 + (texture (u_texture1, P_6).xyz * 0.383103));
  highp vec2 P_7;
  P_7 = (tmpvar_2 + (vec2(0.0, 1.0) / u_resolution));
  acc_1 = (acc_1 + (texture (u_texture1, P_7).xyz * 0.241843));
  highp vec2 P_8;
  P_8 = (tmpvar_2 + (vec2(0.0, 2.0) / u_resolution));
  acc_1 = (acc_1 + (texture (u_texture1, P_8).xyz * 0.060626));
  highp vec2 P_9;
  P_9 = (tmpvar_2 + (vec2(0.0, 3.0) / u_resolution));
  acc_1 = (acc_1 + (texture (u_texture1, P_9).xyz * 0.00598));
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = acc_1;
  glFragColor = tmpvar_10;
}

