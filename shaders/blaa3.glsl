#version 300 es
precision highp float;
uniform vec2 u_resolution;
uniform sampler2D u_texture1;
uniform sampler2D u_texture2;
out lowp vec4 glFragColor;

// License Creative Commons Attribution-NonCommercial-ShareAlike

// opensource
// please dont use it for sell on google/apple store thanks

//original GLSL source on my github https://github.com/danilw
//this is obfuscated/optimized source

void main ()
{
  lowp vec3 inputColor_1;
  highp vec2 tmpvar_2;
  tmpvar_2 = (gl_FragCoord.xy / u_resolution);
  highp vec2 x_3;
  x_3 = ((tmpvar_2 * 2.0) - 1.0);
  highp float tmpvar_4;
  tmpvar_4 = clamp ((clamp (
    (sqrt(dot (x_3, x_3)) - 0.5)
  , 0.0, 1.0) * 0.9), 0.0, 1.0);
  inputColor_1 = ((texture (u_texture1, tmpvar_2).xyz + (texture (u_texture2, tmpvar_2).xyz * 0.07)) * (1.0 - tmpvar_4));
  inputColor_1 = ((inputColor_1 * 0.995) + 0.005);
  lowp vec3 tmpvar_5;
  tmpvar_5 = max ((max (inputColor_1, 0.0) - 0.04), 0.0);
  lowp vec3 tmpvar_6;
  tmpvar_6 = clamp (((tmpvar_5 * 
    ((tmpvar_5 * 6.2) + 0.85)
  ) / (
    (tmpvar_5 * ((tmpvar_5 * 6.2) + 0.07))
   + 0.56)), 0.0, 1.0);
  lowp vec4 tmpvar_7;
  tmpvar_7.xyz = tmpvar_6;
  tmpvar_7.w = sqrt(dot (tmpvar_6, vec3(0.299, 0.587, 0.114)));
  glFragColor = tmpvar_7;
}

