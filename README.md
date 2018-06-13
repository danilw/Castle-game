# Castle-game
**what is it** this is small game(demo) using wasm and glsl and box2d

**play** [live](https://danilw.github.io/Castle-game/ccgame.html)

original GLSL source in *glsl* folder

**binary builds** added *bin/exe* builds for Linux and Windows to *bin* folder

### Building

1. clone this [nanogui wasm](https://github.com/danilw/nanogui-GLES-wasm)
2. put files from *nanogui_mod* folder to *nanogui-GLES-wasm* 
3. build *nanovg.bc* and *nanogui.bc* in *nanogui-GLES-wasm* and move them to this project
4. clone this [box2d.js](https://github.com/kripken/box2d.js) and build *box2d.bc*
5. build this project *Castle-game* using this command
```
em++ -DNANOVG_GLES3_IMPLEMENTATION -DGLFW_INCLUDE_ES3 -DGLFW_INCLUDE_GLEXT -DNANOGUI_LINUX -Iinclude/ -Iext/Box2D/ -Iext/nanovg/ -Iext/eigen/ box2d.bc nanogui.bc agame3k.cpp --std=c++11 -O3 -lGL -lGLU -lm -lGLEW -s USE_GLFW=3 -s FULL_ES3=1 -s USE_WEBGL2=1 -s WASM=1 -s ALLOW_MEMORY_GROWTH=1 -s EXPORTED_FUNCTIONS='["_c_setnamecolorx","_c_boardlistlength","_c_boardlist","_main"]' -s EXTRA_EXPORTED_RUNTIME_METHODS='["ccall", "cwrap"]' -o build/ccgame.html --shell-file shell_minimal.html --no-heap-copy --preload-file  ./textures --preload-file ./shaders

```

### Screenshot
![ccg](https://danilw.github.io/Castle-game/ccg.png)
### Video
[![ccgv](https://danilw.github.io/Castle-game/yt.png)](https://youtu.be/lNXTFvTDOAo)
