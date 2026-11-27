#lang scribble/manual

@title{Raylisp}

Raylisp exposes the 619 public functions in raylib 6.2 to Common Lisp.
You can draw a window from the REPL, inspect input as it arrives, and use
the same drawing calls inside a game loop.

@section{Install and open a window}

Install the native raylib 6.2 shared library and a Common Lisp with Quicklisp.
Homebrew users can install raylib with @tt{brew install raylib}. On Debian
and Ubuntu, install @tt{libffi-dev} and @tt{build-essential} for CFFI.
Clone the project from a shell:

@verbatim{
git clone https://github.com/pundfoo/raylisp.git ~/quicklisp/local-projects/raylisp
}

Evaluate these forms in order in your Lisp REPL. Run the window on the main
thread. Move the mouse to guide the circle, then press Escape to return.

@verbatim{
(ql:register-local-projects)
(ql:quickload "raylisp")
(raylisp:load-raylib)
(raylisp:demo)
}

If the loader cannot locate the native library, supply its full path to
@tt{raylisp:load-raylib}.

@section{Draw your first frame loop}

@verbatim{
(let ((paper (raylisp:color 245 245 245))
      (blue  (raylisp:color 0 121 241)))
  (raylisp:with-window (640 400 "Follow the mouse")
    (raylisp:do-frames paper
      (raylisp:draw-circle (raylisp:get-mouse-x)
                           (raylisp:get-mouse-y)
                           16.0f0 blue))))
}

@tt{with-window} opens the window and closes it when its body exits.
@tt{do-frames} clears the background, draws the body, and presents the
result on each pass. The mouse coordinates are measured in pixels from
the upper left. Try changing the radius from @tt{16.0f0} to @tt{32.0f0}.
The @tt{f0} suffix gives raylib a single-precision float.

@section{Explore the bindings}

@itemlist[
 @item{@tt{(raylisp:shapes-demo)} opens the shape gallery. Use the arrow keys
 to browse, and Space to switch between 2D and 3D.}
 @item{@tt{(raylisp:input-demo)} displays keyboard, mouse and gamepad input.
 Press a key or move a controller axis to see its name or value.}
 @item{@tt{(raylisp:fonts-demo)} shows text measurement and glyphs.
 Press F1 for the lesson's function reference.}
 @item{@tt{(raylisp:api-guide :core "shader")} prints matching calls,
 C prototypes and examples in the REPL. Other lesson keys are
 @tt{:shapes-2d}, @tt{:shapes-3d}, @tt{:fonts} and @tt{:controllers}.}
]

The @hyperlink["https://github.com/pundfoo/raylisp/blob/main/api.lisp"]{complete
binding declarations} include audio, images, textures, and gestures. Search
for a C name such as @tt{LoadTextureFromImage} to find the exported Lisp
name, its parameters and its return type.

@section{Work with native values}

Use @tt{struct-field} to read a structure returned by value.
A native resource may own memory even when its Lisp representation is an
ordinary property list. This example creates a small image, reads its
width, and releases its pixels even if the body signals an error.

@verbatim{
(let ((image (raylisp:gen-image-color 32 16 (raylisp:color 255 0 0))))
  (unwind-protect
       (raylisp:struct-field image :width)
    (raylisp:unload-image image)))
}

@section{Check your installation}

Evaluate @tt{(asdf:test-system "raylisp")} after loading the project.
The tests check exported Lisp functions and native symbols and exercise
image drawing and audio sample conversion without a display. Set the
@tt{RAYLIB_HEADER} environment variable to the full path of @tt{raylib.h}
to compare against a header installed in a custom location.
