# Raylisp

Common Lisp bindings for all 619 public functions in the main header of [raylib 6.2](https://github.com/raysan5/raylib/releases/tag/6.2).

[Read the Raylisp manual](https://pundfoo.github.io/raylisp/). To build it locally with Racket, run `mkdir -p /tmp/raylisp-manual && raco scribble --html --dest /tmp/raylisp-manual docs/index.scrbl` and open `/tmp/raylisp-manual/index.html`.

## Run the example

An existing Homebrew installation of raylib is sufficient. The loader checks the standard Homebrew locations on Linux and macOS. If needed, install raylib with `brew install raylib` or download the shared library from the linked release. Quicklisp supplies the Lisp dependencies. On Linux, install the libffi development package and a C compiler for CFFI (on Debian or Ubuntu, `libffi-dev` and `build-essential`).

Clone the library into your Quicklisp local projects directory.

```sh
git clone https://github.com/pundfoo/raylisp.git ~/quicklisp/local-projects/raylisp
```

In a Lisp REPL with Quicklisp loaded, evaluate each form in order:

```lisp
(ql:register-local-projects)
(ql:quickload "raylisp")
(raylisp:load-raylib)
(raylisp:demo)
```

If the loader cannot find raylib, pass the full path to the shared library, for example `(raylisp:load-raylib #P"/opt/raylib/lib/libraylib.so")`. Run the demo on the main thread with a graphical display. Move the mouse to move the circle. Press Escape to exit.

## Verify the bindings

Run `(asdf:test-system "raylisp")` after Quickloading the project. The suite checks all 619 exported callables and native symbols, and exercises representative functions including image drawing, pixel reads, and PCM sample conversion. With an installed header it also compares every public function name against the declarations in `raylib.h`. Set `RAYLIB_HEADER` to your header path if it is outside the standard Homebrew or system include directories.

## Five API lessons

Run these after `(raylisp:load-raylib)`. Each lesson starts with a working scene. **F1** pauses the scene and opens that area's complete function reference. **Left/Right** moves one entry, **Page Up/Down** jumps ten, and **F1** returns to the scene.

| Area | Run | What to try |
| --- | --- | --- |
| Core (211 functions) | `(raylisp:core-demo)` | Resize the window and move the dot. [Source and file/callback examples](demo/core.lisp) |
| 2D shapes (75) | `(raylisp:shapes-2d-demo)` | Move the cursor rectangle across the target and watch a point follow a spline. [Source and collision examples](demo/shapes-2d.lisp) |
| Fonts and text (59) | `(raylisp:fonts-demo)` | Measure text and inspect a glyph. Supply a font filename to try your own. [Source and Unicode examples](demo/fonts.lisp) |
| 3D shapes and models (73) | `(raylisp:shapes-3d-demo)` | Pick a generated torus. Supply a model filename to pick your own asset. [Source and animation example](demo/shapes-3d.lisp) |
| Camera controllers (2) | `(raylisp:controllers-demo)` | Press Space to switch from orbit to manual movement, then hold Left or Right. [Source](demo/controllers.lisp) |

The same reference works without a display or native library. The first line shows the Lisp call. Each entry also includes a usage example and the exact C prototype. Example variables such as `font`, `mesh` and `camera` stand for resources you have already obtained. Names ending in `-out` stand for storage supplied by the caller. Browsing displays the examples as text, so a call such as `file-remove` runs only if you evaluate it yourself.

```lisp
(raylisp:api-guide :core "shader")
(raylisp:api-guide :shapes-2d "collision")
(raylisp:api-guide :fonts "codepoint")
(raylisp:api-guide :shapes-3d "animation")
(raylisp:api-guide :controllers)
```

### Reading and passing values

A C structure returned by value becomes a Lisp property list. For example, `(raylisp:struct-field (raylisp:get-mouse-position) :x)` reads a coordinate. CFFI types such as `(:struct raylisp:font)` describe the corresponding layout in native memory. Slots for fixed-size C arrays have numbered names, starting at zero. A pointer field still refers to native memory.

A C parameter such as `int *count` often lets raylib return a second result. Use `cffi:with-foreign-object` to provide space and `cffi:mem-ref` to read it. See `font-codepoints` for a complete example. Pass `(cffi:null-pointer)` when a function accepts C's NULL. Pass a list of flag keywords such as `'(:window-resizable :vsync-hint)` for combined window flags.

For owned native data, pair each load with its matching unload in `unwind-protect`. For example, pair `load-file-text` with `unload-file-text`, `load-codepoints` with `unload-codepoints`, and `text-replace-alloc` with `mem-free`. Read-only string results such as `get-file-extension` are copied for you. A returned array with an explicit length, such as `codepoint-to-utf8`, is a pointer; read exactly that many bytes. Images returned by `get-clipboard-image` and `gen-image-font-atlas` own a pixel buffer, released with `(raylisp:unload-image image)`. The atlas also returns a separately allocated rectangles buffer to release with `mem-free`.

Callback setters accept a C function pointer made with `cffi:defcallback` and `cffi:callback`. The argument types are beside each setter in [api.lisp](api.lisp). Keep any data used by a registered callback alive until you replace or clear it. The trace-log callback receives a platform-specific C `va_list`; formatting its variable arguments requires a native `va_list` consumer. For logging from Lisp, use `(raylisp:trace-log :info "%s" :string "Ready")`.

The declarations and reference entries follow raylib's installed header. [Upstream license](RAYLIB-LICENSE)

## Read the code

Start with `demo/mouse.lisp`. Each trip through the loop draws one frame. Try changing the radius from `16.0f0` to `32.0f0`. The suffix specifies a single-precision float, matching raylib's C parameter.

[bindings.lisp](bindings.lisp) defines the package, library loader, C types, and value constructors. [api.lisp](api.lisp) contains the native functions and Lisp wrappers, grouped by topic. Find `DrawCircle` there. The quoted name identifies the function in the shared library. The next name, `draw-circle`, is what you call in Lisp. Its return type is `:void` and the four arguments follow in the same order as in [raylib.h](https://github.com/raysan5/raylib/blob/6.2/src/raylib.h). To bind another function, add its declaration in `api.lisp` and export the Lisp name in `bindings.lisp`.

## Camera examples

After loading raylib, run `(raylisp:camera-2d-demo)` to pan across a row of blocks or `(raylisp:camera-3d-demo)` to view a cube on a grid. Move the mouse horizontally in either window and press Escape to close it. Both loops are in [demo/camera.lisp](demo/camera.lisp).

## Shape example

Run `(raylisp:shapes-demo)` and use the left and right arrows to browse. Press Space to switch between 2D and 3D. Each page names its raylib function so you can find its call in [demo/shapes.lisp](demo/shapes.lisp). The gallery covers the 2D shape and spline drawing functions and the 3D primitives, including wireframes, rays, grids and bounding boxes.

## Input example

Run `(raylisp:input-demo)` to see the last keyboard key, mouse button and gamepad button pressed, plus held mouse buttons, scroll movement and all six gamepad axes. Escape closes the window. Gamepad index 0 selects the first controller. Available physical controls depend on the device.

Use the raylib name without its category prefix, replacing underscores with hyphens. For example, `KEY_KP_ENTER` becomes `:kp-enter`, `MOUSE_BUTTON_SIDE` becomes `:side`, and `GAMEPAD_BUTTON_LEFT_THUMB` becomes `:left-thumb`. You can list every supported name at the REPL:

```lisp
(cffi:foreign-enum-keyword-list 'raylisp:keyboard-key)
(cffi:foreign-enum-keyword-list 'raylisp:mouse-button)
(cffi:foreign-enum-keyword-list 'raylisp:gamepad-button)
(cffi:foreign-enum-keyword-list 'raylisp:gamepad-axis)
```

See [demo/input.lisp](demo/input.lisp) for the polling loop.

## Define a game

[demo/macros.lisp](demo/macros.lisp) builds a small game with five defining forms. Use `raylisp:defcolor` to name a color, `raylisp:defcircle` and `raylisp:deflabel` to define drawing functions, `raylisp:defkeymap` to bind actions to keys, and `raylisp:defgame` to define the playable entry point. All five are available after quickloading Raylisp. Their implementations are in [macros.lisp](macros.lisp).

After loading raylib, run `(raylisp:macros-demo)`. Hold Left or Right to move the circle and tap Space to change its color. Try changing the radius in a `defcircle` form and evaluating that definition again.

## Macro construction reference

Start with `(raylisp:macro-guide)` to list the constructions. Supply a name to see an example and one step of expansion. These forms only need Quicklisp; you can study them before loading the native library.

```lisp
(raylisp:macro-guide :when-key-pressed)
(raylisp:macro-guide :move-point-by)
(raylisp:macro-guide :define-drawing-scope)
```

| Learn | Read in [macros.lisp](macros.lisp) |
| --- | --- |
| Backquote, comma and body splicing | `when-key-pressed` |
| Caller-chosen bindings, destructuring and optional settings | `with-mouse-position`, `with-window` |
| Once-only evaluation and private temporaries | `do-grid` |
| Loops, event consumption and macro composition | `do-pressed-keys`, `do-frames` |
| Paired calls and resource ownership on early exit | `with-frame`, `with-font` |
| Generating variables, functions and groups of definitions | `defcolor`, `defcircle`, `deflabel`, `defpalette` |
| Translating a little language into ordinary Lisp | `defkeymap`, `defgame` |
| Editing places, including an array element with a computed index | `with-point-components`, `move-point-by` |
| A defining macro that creates other macros | `define-drawing-scope`, `with-3d`, `with-clip` |
| Local macros and expansion in the caller's environment | `macrolet` in [the demo](demo/macros.lisp), `expansion-of` |

After loading raylib, run `(raylisp:drawing-macros-demo)`. Move the marker with the arrow keys. The scene combines a clipped drawing region, a 3D camera, local keyboard controls and a borrowed font. Try passing a font filename to the same demo to exercise the load-and-release path.

Run `(asdf:test-system "raylisp")` to check that your native library exports the 420 functions and exercise collision results, UTF-8 decoding, variable arguments and camera updates without opening a window.
