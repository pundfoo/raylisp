(defpackage #:raylisp
  (:use #:cl)
  (:export
           #:n-patch-info #:wave #:audio-stream #:sound #:music #:pixel-format #:texture-filter
           #:texture-wrap #:cubemap-layout #:n-patch-layout #:gesture #:set-gestures-enabled
           #:is-gesture-detected #:get-gesture-detected #:get-gesture-hold-duration
           #:get-gesture-drag-vector #:get-gesture-drag-angle #:get-gesture-pinch-vector
           #:get-gesture-pinch-angle #:load-image #:load-image-raw #:load-image-anim
           #:load-image-anim-from-memory #:load-image-from-memory #:load-image-from-texture
           #:load-image-from-screen #:is-image-valid #:unload-image #:export-image
           #:export-image-to-memory #:export-image-as-code #:gen-image-color
           #:gen-image-gradient-linear #:gen-image-gradient-radial #:gen-image-gradient-square
           #:gen-image-checked #:gen-image-white-noise #:gen-image-perlin-noise #:gen-image-cellular
           #:gen-image-text #:image-copy #:image-from-image #:image-from-channel #:image-text
           #:image-text-ex #:image-format #:image-to-pot #:image-crop #:image-alpha-crop
           #:image-alpha-clear #:image-alpha-mask #:image-alpha-premultiply #:image-blur-gaussian
           #:image-kernel-convolution #:image-resize #:image-resize-nn #:image-resize-canvas
           #:image-mipmaps #:image-dither #:image-flip-vertical #:image-flip-horizontal
           #:image-rotate #:image-rotate-cw #:image-rotate-ccw #:image-color-tint
           #:image-color-invert #:image-color-grayscale #:image-color-contrast
           #:image-color-brightness #:image-color-replace #:load-image-colors #:load-image-palette
           #:unload-image-colors #:unload-image-palette #:get-image-alpha-border #:get-image-color
           #:image-clear-background #:image-draw-pixel #:image-draw-pixel-v #:image-draw-line
           #:image-draw-line-v #:image-draw-line-ex #:image-draw-line-strip #:image-draw-triangle
           #:image-draw-triangle-gradient #:image-draw-triangle-lines #:image-draw-triangle-fan
           #:image-draw-triangle-strip #:image-draw-rectangle #:image-draw-rectangle-v
           #:image-draw-rectangle-rec #:image-draw-rectangle-pro #:image-draw-rectangle-lines
           #:image-draw-rectangle-lines-ex #:image-draw-rectangle-gradient-ex #:image-draw-circle
           #:image-draw-circle-v #:image-draw-circle-lines #:image-draw-circle-lines-v
           #:image-draw-circle-gradient #:image-draw-image #:image-draw-image-ex
           #:image-draw-image-rec #:image-draw-image-pro #:image-draw-text #:image-draw-text-ex
           #:image-draw-text-pro #:load-texture #:load-texture-from-image #:load-texture-cubemap
           #:load-render-texture #:load-render-texture-ex #:is-texture-valid #:unload-texture
           #:is-render-texture-valid #:unload-render-texture #:update-texture #:update-texture-rec
           #:gen-texture-mipmaps #:set-texture-filter #:set-texture-wrap #:draw-texture
           #:draw-texture-v #:draw-texture-ex #:draw-texture-rec #:draw-texture-pro
           #:draw-texture-n-patch #:color-is-equal #:fade #:color-to-int #:color-normalize
           #:color-from-normalized #:color-to-hsv #:color-from-hsv #:color-tint #:color-brightness
           #:color-contrast #:color-alpha #:color-alpha-blend #:color-lerp #:get-color
           #:get-pixel-color #:set-pixel-color #:get-pixel-data-size #:init-audio-device
           #:close-audio-device #:is-audio-device-ready #:set-master-volume #:get-master-volume
           #:load-wave #:load-wave-from-memory #:is-wave-valid #:load-sound #:load-sound-from-wave
           #:load-sound-alias #:is-sound-valid #:update-sound #:unload-wave #:unload-sound
           #:unload-sound-alias #:export-wave #:export-wave-as-code #:play-sound #:stop-sound
           #:pause-sound #:resume-sound #:is-sound-playing #:set-sound-volume #:set-sound-pitch
           #:set-sound-pan #:wave-copy #:wave-crop #:wave-format #:load-wave-samples
           #:unload-wave-samples #:load-music-stream #:load-music-stream-from-memory
           #:is-music-valid #:unload-music-stream #:play-music-stream #:is-music-stream-playing
           #:update-music-stream #:stop-music-stream #:pause-music-stream #:resume-music-stream
           #:seek-music-stream #:set-music-volume #:set-music-pitch #:set-music-pan
           #:get-music-time-length #:get-music-time-played #:load-audio-stream
           #:is-audio-stream-valid #:unload-audio-stream #:update-audio-stream
           #:is-audio-stream-processed #:play-audio-stream #:pause-audio-stream
           #:resume-audio-stream #:is-audio-stream-playing #:stop-audio-stream
           #:set-audio-stream-volume #:set-audio-stream-pitch #:set-audio-stream-pan
           #:set-audio-stream-buffer-size-default #:set-audio-stream-callback
           #:attach-audio-stream-processor #:detach-audio-stream-processor
           #:attach-audio-mixed-processor #:detach-audio-mixed-processor
           #:load-raylib #:init-window #:close-window #:window-should-close-p
           #:begin-drawing #:end-drawing #:clear-background #:set-target-fps
           #:draw-text #:draw-circle #:draw-rectangle #:get-mouse-x #:get-mouse-y
           #:color #:demo #:camera-2d-demo #:camera-3d-demo
           #:vec2 #:vec3 #:camera-2d #:camera-3d #:begin-mode-2d #:end-mode-2d
           #:begin-mode-3d #:end-mode-3d #:draw-cube #:draw-grid
           #:draw-triangle #:draw-sphere #:draw-cylinder #:shapes-demo
           #:key-down-p #:key-pressed-p #:mouse-button-down-p #:get-mouse-wheel-move
           #:gamepad-available-p #:gamepad-button-pressed-p #:get-gamepad-axis-movement
           #:defpalette #:define-drawing-scope #:with-3d #:with-clip #:with-font
           #:with-point-components #:move-point-by #:do-pressed-keys #:expansion-of
           #:macro-guide #:drawing-macros-demo #:defcolor #:defcircle #:deflabel #:defkeymap #:defgame
           #:macros-demo #:when-key-pressed #:with-mouse-position #:with-frame
           #:do-grid #:with-window #:do-frames
           #:input-demo #:keyboard-key #:mouse-button #:gamepad-button #:gamepad-axis
           #:get-key-pressed #:next-key-pressed #:mouse-button-pressed-p
           #:rectangle #:ray #:bounding-box #:draw-pixel #:draw-pixel-v #:draw-line
           #:draw-line-v #:draw-line-ex #:draw-line-strip #:draw-line-bezier
           #:draw-line-dashed #:draw-triangle-gradient #:draw-triangle-lines
           #:draw-triangle-lines-ex #:draw-triangle-fan #:draw-triangle-strip
           #:draw-rectangle-v #:draw-rectangle-rec #:draw-rectangle-pro
           #:draw-rectangle-gradient-v #:draw-rectangle-gradient-h
           #:draw-rectangle-gradient-ex #:draw-rectangle-lines #:draw-rectangle-lines-ex
           #:draw-rectangle-rounded #:draw-rectangle-rounded-lines
           #:draw-rectangle-rounded-lines-ex #:draw-poly #:draw-poly-lines
           #:draw-poly-lines-ex #:draw-circle-v #:draw-circle-gradient #:draw-circle-sector
           #:draw-circle-sector-lines #:draw-circle-sector-lines-ex #:draw-circle-lines
           #:draw-circle-lines-v #:draw-circle-lines-ex #:draw-ellipse #:draw-ellipse-v
           #:draw-ellipse-lines #:draw-ellipse-lines-v #:draw-ellipse-lines-ex #:draw-ring
           #:draw-ring-lines #:draw-ring-lines-ex #:draw-spline-linear #:draw-spline-basis
           #:draw-spline-catmull-rom #:draw-spline-bezier-quadratic #:draw-spline-bezier-cubic
           #:draw-spline-segment-linear #:draw-spline-segment-basis
           #:draw-spline-segment-catmull-rom #:draw-spline-segment-bezier-quadratic
           #:draw-spline-segment-bezier-cubic #:draw-line-3d #:draw-point-3d #:draw-circle-3d
           #:draw-triangle-3d #:draw-triangle-strip-3d #:draw-cube-v #:draw-cube-wires
           #:draw-cube-wires-v #:draw-sphere-ex #:draw-sphere-wires #:draw-cylinder-ex
           #:draw-cylinder-wires #:draw-cylinder-wires-ex #:draw-capsule #:draw-capsule-wires
           #:draw-plane #:draw-ray #:draw-bounding-box
           #:core-read-text #:directory-names #:line-intersection #:inside-polygon-p
           #:apply-first-animation #:replace-all-text #:font-codepoints #:struct-field #:api-guide #:automation-event #:automation-event-list #:begin-blend-mode
           #:begin-scissor-mode #:begin-shader-mode #:begin-texture-mode #:begin-vr-stereo-mode
           #:blend-mode #:bone-info #:camera-mode #:change-directory
           #:check-collision-box-sphere #:check-collision-boxes #:check-collision-circle-line
           #:check-collision-circle-rec #:check-collision-circles #:check-collision-lines
           #:check-collision-point-circle #:check-collision-point-line
           #:check-collision-point-poly #:check-collision-point-rec
           #:check-collision-point-triangle #:check-collision-recs #:check-collision-spheres
           #:clear-window-state #:codepoint-to-utf8 #:compress-data #:compute-crc32
           #:compute-md5 #:compute-sha1 #:compute-sha256 #:config-flags #:controllers-demo
           #:core-demo #:decode-data-base64 #:decompress-data #:directory-exists
           #:disable-cursor #:disable-event-waiting #:draw-billboard #:draw-billboard-pro
           #:draw-billboard-rec #:draw-fps #:draw-mesh #:draw-mesh-instanced #:draw-model
           #:draw-model-ex #:draw-model-wires #:draw-model-wires-ex #:draw-text-codepoint
           #:draw-text-codepoints #:draw-text-ex #:draw-text-pro #:enable-cursor
           #:enable-event-waiting #:encode-data-base64 #:end-blend-mode #:end-scissor-mode
           #:end-shader-mode #:end-texture-mode #:end-vr-stereo-mode
           #:export-automation-event-list #:export-data-as-code #:export-font-as-code
           #:export-mesh #:export-mesh-as-code #:file-copy #:file-exists #:file-move
           #:file-path-list #:file-remove #:file-rename #:file-text-find-index
           #:file-text-replace #:font #:font-type #:fonts-demo #:gen-image-font-atlas
           #:gen-mesh-cone #:gen-mesh-cube #:gen-mesh-cubicmap #:gen-mesh-cylinder
           #:gen-mesh-heightmap #:gen-mesh-hemi-sphere #:gen-mesh-knot #:gen-mesh-plane
           #:gen-mesh-poly #:gen-mesh-sphere #:gen-mesh-tangents #:gen-mesh-torus
           #:get-application-directory #:get-camera-matrix #:get-camera-matrix-2d
           #:get-char-pressed #:get-clipboard-image #:get-clipboard-text #:get-codepoint
           #:get-codepoint-count #:get-codepoint-next #:get-codepoint-previous
           #:get-collision-rec #:get-current-monitor #:get-directory-file-count
           #:get-directory-file-count-ex #:get-directory-path #:get-file-extension
           #:get-file-length #:get-file-mod-time #:get-file-name #:get-file-name-without-ext
           #:get-font-default #:get-fps #:get-frame-time #:get-gamepad-axis-count
           #:get-gamepad-button-pressed #:get-gamepad-name #:get-glyph-atlas-rec
           #:get-glyph-index #:get-glyph-info #:get-key-name #:get-mesh-bounding-box
           #:get-model-bounding-box #:get-monitor-count #:get-monitor-height #:get-monitor-name
           #:get-monitor-physical-height #:get-monitor-physical-width #:get-monitor-position
           #:get-monitor-refresh-rate #:get-monitor-width #:get-mouse-delta #:get-mouse-position
           #:get-mouse-wheel-move-v #:get-prev-directory-path #:get-random-value
           #:get-ray-collision-box #:get-ray-collision-mesh #:get-ray-collision-quad
           #:get-ray-collision-sphere #:get-ray-collision-triangle #:get-render-height
           #:get-render-width #:get-screen-height #:get-screen-to-world-2d
           #:get-screen-to-world-ray #:get-screen-to-world-ray-ex #:get-screen-width
           #:get-shader-location #:get-shader-location-attrib #:get-shapes-texture
           #:get-shapes-texture-rectangle #:get-spline-point-basis
           #:get-spline-point-bezier-cubic #:get-spline-point-bezier-quadratic
           #:get-spline-point-catmull-rom #:get-spline-point-linear #:get-text-between
           #:get-time #:get-touch-point-count #:get-touch-point-id #:get-touch-position
           #:get-touch-x #:get-touch-y #:get-window-handle #:get-window-position
           #:get-window-scale-dpi #:get-working-directory #:get-world-to-screen
           #:get-world-to-screen-2d #:get-world-to-screen-ex #:glyph-info #:hide-cursor #:image
           #:is-cursor-hidden #:is-cursor-on-screen #:is-file-dropped #:is-file-extension
           #:is-file-hidden #:is-file-name-valid #:is-font-valid #:is-gamepad-button-down
           #:is-gamepad-button-released #:is-gamepad-button-up #:is-key-pressed-repeat
           #:is-key-released #:is-key-up #:is-material-valid #:is-model-animation-valid
           #:is-model-valid #:is-mouse-button-released #:is-mouse-button-up #:is-path-absolute
           #:is-path-directory #:is-path-file #:is-shader-valid #:is-window-focused
           #:is-window-fullscreen #:is-window-hidden #:is-window-maximized #:is-window-minimized
           #:is-window-ready #:is-window-resized #:is-window-state #:load-automation-event-list
           #:load-codepoints #:load-directory-files #:load-directory-files-ex
           #:load-dropped-files #:load-file-data #:load-file-text #:load-font #:load-font-data
           #:load-font-ex #:load-font-from-image #:load-font-from-memory #:load-material-default
           #:load-materials #:load-model #:load-model-animations #:load-model-from-mesh
           #:load-random-sequence #:load-shader #:load-shader-from-memory #:load-text-lines
           #:load-utf8 #:load-vr-stereo-config #:make-directory #:material #:material-map
           #:material-map-index #:matrix #:maximize-window #:measure-text
           #:measure-text-codepoints #:measure-text-ex #:mem-alloc #:mem-free #:mem-realloc
           #:mesh #:minimize-window #:model #:model-animation #:model-skeleton #:mouse-cursor
           #:open-url #:play-automation-event #:poll-input-events #:ray-collision
           #:render-texture #:restore-window #:rgba #:save-file-data #:save-file-text
           #:set-automation-event-base-frame #:set-automation-event-list #:set-clipboard-text
           #:set-config-flags #:set-exit-key #:set-gamepad-mappings #:set-gamepad-vibration
           #:set-load-file-data-callback #:set-load-file-text-callback #:set-material-texture
           #:set-model-mesh-material #:set-mouse-cursor #:set-mouse-offset #:set-mouse-position
           #:set-mouse-scale #:set-random-seed #:set-save-file-data-callback
           #:set-save-file-text-callback #:set-shader-value #:set-shader-value-matrix
           #:set-shader-value-texture #:set-shader-value-v #:set-shapes-texture
           #:set-text-line-spacing #:set-trace-log-callback #:set-trace-log-level
           #:set-window-focused #:set-window-icon #:set-window-icons #:set-window-max-size
           #:set-window-min-size #:set-window-monitor #:set-window-opacity #:set-window-position
           #:set-window-size #:set-window-state #:set-window-title #:shader
           #:shader-attribute-data-type #:shader-location-index #:shader-uniform-data-type
           #:shapes-2d-demo #:shapes-3d-demo #:show-cursor #:start-automation-event-recording
           #:stop-automation-event-recording #:swap-screen-buffer #:take-screenshot
           #:text-append #:text-copy #:text-find-index #:text-format #:text-insert
           #:text-insert-alloc #:text-is-equal #:text-join #:text-length #:text-remove-spaces
           #:text-replace #:text-replace-alloc #:text-replace-between
           #:text-replace-between-alloc #:text-split #:text-subtext #:text-to-camel
           #:text-to-float #:text-to-integer #:text-to-lower #:text-to-pascal #:text-to-snake
           #:text-to-upper #:texture #:toggle-borderless-windowed #:toggle-fullscreen
           #:trace-log #:trace-log-level #:transform #:unload-automation-event-list
           #:unload-codepoints #:unload-directory-files #:unload-dropped-files
           #:unload-file-data #:unload-file-text #:unload-font #:unload-font-data
           #:unload-material #:unload-mesh #:unload-model #:unload-model-animations
           #:unload-random-sequence #:unload-shader #:unload-text-lines #:unload-utf8
           #:unload-vr-stereo-config #:update-camera #:update-camera-pro #:update-mesh-buffer
           #:update-model-animation #:update-model-animation-ex #:upload-mesh #:vector-2
           #:vector-3 #:vector-4 #:vr-device-info #:vr-stereo-config #:wait-time))

(in-package #:raylisp)

(cffi:define-foreign-library raylib
  (:darwin (:or "libraylib.dylib"
                "/opt/homebrew/opt/raylib/lib/libraylib.dylib"
                "/usr/local/opt/raylib/lib/libraylib.dylib"))
  (:unix (:or "libraylib.so"
              "/home/linuxbrew/.linuxbrew/opt/raylib/lib/libraylib.so"))
  (:windows "raylib.dll"))

(defun load-raylib (&optional path)
  "Load the native library. Supply its full pathname if installed privately."
  (if path
      (cffi:load-foreign-library path)
      (cffi:use-foreign-library raylib)))

;; A raylib Color contains four consecutive bytes. CFFI accepts a property
;; list whose keys name the slots when passing this structure by value.
(cffi:defcstruct rgba
  (red :uint8)
  (green :uint8)
  (blue :uint8)
  (alpha :uint8))

(defun color (red green blue &optional (alpha 255))
  "Make a drawing color. Each channel ranges from 0 to 255."
  (list 'red red 'green green 'blue blue 'alpha alpha))

;; Each declaration gives the C name, Lisp name, return type, then arguments.

(cffi:defcstruct vector-2 (x :float) (y :float))
(cffi:defcstruct vector-3 (x :float) (y :float) (z :float))

(defun vec2 (x y)
  (list 'x (float x 1f0) 'y (float y 1f0)))

(defun vec3 (x y z)
  (list 'x (float x 1f0) 'y (float y 1f0) 'z (float z 1f0)))

(cffi:defcstruct camera-2d
  (offset (:struct vector-2))
  (target (:struct vector-2))
  (rotation :float)
  (zoom :float))

(defun camera-2d (&key offset target (rotation 0) (zoom 1))
  "Place the world point TARGET at screen point OFFSET."
  (list 'offset offset 'target target
        'rotation (float rotation 1f0) 'zoom (float zoom 1f0)))

(cffi:defcenum projection (:perspective 0) (:orthographic 1))

(cffi:defcstruct camera-3d
  (position (:struct vector-3))
  (target (:struct vector-3))
  (up (:struct vector-3))
  (fovy :float)
  (projection projection))

(defun camera-3d (&key position target (up (vec3 0 1 0)) (fovy 45)
                       (projection :perspective))
  "Look from POSITION toward TARGET. FOVY is in degrees for perspective."
  (list 'position position 'target target 'up up
        'fovy (float fovy 1f0) 'projection projection))

(cffi:defcenum keyboard-key
  (:null 0)
  (:apostrophe 39)
  (:comma 44)
  (:minus 45)
  (:period 46)
  (:slash 47)
  (:zero 48)
  (:one 49)
  (:two 50)
  (:three 51)
  (:four 52)
  (:five 53)
  (:six 54)
  (:seven 55)
  (:eight 56)
  (:nine 57)
  (:semicolon 59)
  (:equal 61)
  (:a 65)
  (:b 66)
  (:c 67)
  (:d 68)
  (:e 69)
  (:f 70)
  (:g 71)
  (:h 72)
  (:i 73)
  (:j 74)
  (:k 75)
  (:l 76)
  (:m 77)
  (:n 78)
  (:o 79)
  (:p 80)
  (:q 81)
  (:r 82)
  (:s 83)
  (:t 84)
  (:u 85)
  (:v 86)
  (:w 87)
  (:x 88)
  (:y 89)
  (:z 90)
  (:left-bracket 91)
  (:backslash 92)
  (:right-bracket 93)
  (:grave 96)
  (:space 32)
  (:escape 256)
  (:enter 257)
  (:tab 258)
  (:backspace 259)
  (:insert 260)
  (:delete 261)
  (:right 262)
  (:left 263)
  (:down 264)
  (:up 265)
  (:page-up 266)
  (:page-down 267)
  (:home 268)
  (:end 269)
  (:caps-lock 280)
  (:scroll-lock 281)
  (:num-lock 282)
  (:print-screen 283)
  (:pause 284)
  (:f1 290)
  (:f2 291)
  (:f3 292)
  (:f4 293)
  (:f5 294)
  (:f6 295)
  (:f7 296)
  (:f8 297)
  (:f9 298)
  (:f10 299)
  (:f11 300)
  (:f12 301)
  (:left-shift 340)
  (:left-control 341)
  (:left-alt 342)
  (:left-super 343)
  (:right-shift 344)
  (:right-control 345)
  (:right-alt 346)
  (:right-super 347)
  (:kb-menu 348)
  (:kp-0 320)
  (:kp-1 321)
  (:kp-2 322)
  (:kp-3 323)
  (:kp-4 324)
  (:kp-5 325)
  (:kp-6 326)
  (:kp-7 327)
  (:kp-8 328)
  (:kp-9 329)
  (:kp-decimal 330)
  (:kp-divide 331)
  (:kp-multiply 332)
  (:kp-subtract 333)
  (:kp-add 334)
  (:kp-enter 335)
  (:kp-equal 336)
  (:back 4)
  (:menu 5)
  (:volume-up 24)
  (:volume-down 25))

(cffi:defcenum mouse-button
  (:left 0)
  (:right 1)
  (:middle 2)
  (:side 3)
  (:extra 4)
  (:forward 5)
  (:back 6))

(cffi:defcenum gamepad-button
  (:unknown 0)
  (:left-face-up 1)
  (:left-face-right 2)
  (:left-face-down 3)
  (:left-face-left 4)
  (:right-face-up 5)
  (:right-face-right 6)
  (:right-face-down 7)
  (:right-face-left 8)
  (:left-trigger-1 9)
  (:left-trigger-2 10)
  (:right-trigger-1 11)
  (:right-trigger-2 12)
  (:middle-left 13)
  (:middle 14)
  (:middle-right 15)
  (:left-thumb 16)
  (:right-thumb 17))

(cffi:defcenum gamepad-axis
  (:left-x 0)
  (:left-y 1)
  (:right-x 2)
  (:right-y 3)
  (:left-trigger 4)
  (:right-trigger 5))

(cffi:defcstruct rectangle (x :float) (y :float) (width :float) (height :float))
(defun rectangle (x y width height)
  (list 'x (float x 1f0) 'y (float y 1f0)
        'width (float width 1f0) 'height (float height 1f0)))

(cffi:defcstruct ray (position (:struct vector-3)) (direction (:struct vector-3)))
(defun ray (position direction)
  (list 'position position 'direction direction))

(cffi:defcstruct bounding-box (min (:struct vector-3)) (max (:struct vector-3)))
(defun bounding-box (min max)
  (list 'min min 'max max))

;; Raylib expects consecutive vectors in memory. Keep the array alive for
;; one draw call and derive its size from the Lisp list.
(defmacro with-point-array ((pointer points type) &body body)
  `(cffi:with-foreign-object (,pointer ',type (length ,points))
     (loop for point in ,points for index from 0
           do (setf (cffi:mem-aref ,pointer ',type index) point))
     ,@body))

;; Fixed C arrays are inline fields. Numbered slots stay valid when a
;; structure returned by value is copied into a Lisp property list.

(cffi:defcstruct vector-4
  (x :float)
  (y :float)
  (z :float)
  (w :float))

(cffi:defcstruct matrix
  (m0 :float)
  (m4 :float)
  (m8 :float)
  (m12 :float)
  (m1 :float)
  (m5 :float)
  (m9 :float)
  (m13 :float)
  (m2 :float)
  (m6 :float)
  (m10 :float)
  (m14 :float)
  (m3 :float)
  (m7 :float)
  (m11 :float)
  (m15 :float))

(cffi:defcstruct image
  (data :pointer)
  (width :int)
  (height :int)
  (mipmaps :int)
  (format :int))

(cffi:defcstruct texture
  (id :unsigned-int)
  (width :int)
  (height :int)
  (mipmaps :int)
  (format :int))

(cffi:defcstruct render-texture
  (id :unsigned-int)
  (texture (:struct texture))
  (depth (:struct texture)))

(cffi:defcstruct glyph-info
  (value :int)
  (offset-x :int)
  (offset-y :int)
  (advance-x :int)
  (image (:struct image)))

(cffi:defcstruct font
  (base-size :int)
  (glyph-count :int)
  (glyph-padding :int)
  (texture (:struct texture))
  (recs :pointer)
  (glyphs :pointer))

(cffi:defcstruct mesh
  (vertex-count :int)
  (triangle-count :int)
  (vertices :pointer)
  (texcoords :pointer)
  (texcoords2 :pointer)
  (normals :pointer)
  (tangents :pointer)
  (colors :pointer)
  (indices :pointer)
  (bone-count :int)
  (bone-indices :pointer)
  (bone-weights :pointer)
  (anim-vertices :pointer)
  (anim-normals :pointer)
  (vao-id :unsigned-int)
  (vbo-id :pointer))

(cffi:defcstruct shader
  (id :unsigned-int)
  (locs :pointer))

(cffi:defcstruct material-map
  (texture (:struct texture))
  (color (:struct rgba))
  (value :float))

(cffi:defcstruct material
  (shader (:struct shader))
  (maps :pointer)
  (params-0 :float)
  (params-1 :float)
  (params-2 :float)
  (params-3 :float))

(cffi:defcstruct transform
  (translation (:struct vector-3))
  (rotation (:struct vector-4))
  (scale (:struct vector-3)))

(cffi:defcstruct bone-info
  (name-0 :char)
  (name-1 :char)
  (name-2 :char)
  (name-3 :char)
  (name-4 :char)
  (name-5 :char)
  (name-6 :char)
  (name-7 :char)
  (name-8 :char)
  (name-9 :char)
  (name-10 :char)
  (name-11 :char)
  (name-12 :char)
  (name-13 :char)
  (name-14 :char)
  (name-15 :char)
  (name-16 :char)
  (name-17 :char)
  (name-18 :char)
  (name-19 :char)
  (name-20 :char)
  (name-21 :char)
  (name-22 :char)
  (name-23 :char)
  (name-24 :char)
  (name-25 :char)
  (name-26 :char)
  (name-27 :char)
  (name-28 :char)
  (name-29 :char)
  (name-30 :char)
  (name-31 :char)
  (parent :int))

(cffi:defcstruct model-skeleton
  (bone-count :unsigned-int)
  (bones :pointer)
  (bind-pose :pointer))

(cffi:defcstruct model
  (transform (:struct matrix))
  (mesh-count :int)
  (material-count :int)
  (meshes :pointer)
  (materials :pointer)
  (mesh-material :pointer)
  (skeleton (:struct model-skeleton))
  (current-pose :pointer)
  (bone-matrices :pointer))

(cffi:defcstruct model-animation
  (name-0 :char)
  (name-1 :char)
  (name-2 :char)
  (name-3 :char)
  (name-4 :char)
  (name-5 :char)
  (name-6 :char)
  (name-7 :char)
  (name-8 :char)
  (name-9 :char)
  (name-10 :char)
  (name-11 :char)
  (name-12 :char)
  (name-13 :char)
  (name-14 :char)
  (name-15 :char)
  (name-16 :char)
  (name-17 :char)
  (name-18 :char)
  (name-19 :char)
  (name-20 :char)
  (name-21 :char)
  (name-22 :char)
  (name-23 :char)
  (name-24 :char)
  (name-25 :char)
  (name-26 :char)
  (name-27 :char)
  (name-28 :char)
  (name-29 :char)
  (name-30 :char)
  (name-31 :char)
  (bone-count :unsigned-int)
  (keyframe-count :int)
  (keyframe-poses :pointer))

(cffi:defcstruct ray-collision
  (hit (:boolean :uint8))
  (distance :float)
  (point (:struct vector-3))
  (normal (:struct vector-3)))

(cffi:defcstruct vr-device-info
  (h-resolution :int)
  (v-resolution :int)
  (h-screen-size :float)
  (v-screen-size :float)
  (eye-to-screen-distance :float)
  (lens-separation-distance :float)
  (interpupillary-distance :float)
  (lens-distortion-values-0 :float)
  (lens-distortion-values-1 :float)
  (lens-distortion-values-2 :float)
  (lens-distortion-values-3 :float)
  (chroma-ab-correction-0 :float)
  (chroma-ab-correction-1 :float)
  (chroma-ab-correction-2 :float)
  (chroma-ab-correction-3 :float))

(cffi:defcstruct vr-stereo-config
  (projection-0 (:struct matrix))
  (projection-1 (:struct matrix))
  (view-offset-0 (:struct matrix))
  (view-offset-1 (:struct matrix))
  (left-lens-center-0 :float)
  (left-lens-center-1 :float)
  (right-lens-center-0 :float)
  (right-lens-center-1 :float)
  (left-screen-center-0 :float)
  (left-screen-center-1 :float)
  (right-screen-center-0 :float)
  (right-screen-center-1 :float)
  (scale-0 :float)
  (scale-1 :float)
  (scale-in-0 :float)
  (scale-in-1 :float))

(cffi:defcstruct file-path-list
  (count :unsigned-int)
  (paths :pointer))

(cffi:defcstruct automation-event
  (frame :unsigned-int)
  (type :unsigned-int)
  (params-0 :int)
  (params-1 :int)
  (params-2 :int)
  (params-3 :int))

(cffi:defcstruct automation-event-list
  (capacity :unsigned-int)
  (count :unsigned-int)
  (events :pointer))

(cffi:defbitfield (config-flags :unsigned-int)
  (:vsync-hint 64)
  (:fullscreen-mode 2)
  (:window-resizable 4)
  (:window-undecorated 8)
  (:window-hidden 128)
  (:window-minimized 512)
  (:window-maximized 1024)
  (:window-unfocused 2048)
  (:window-topmost 4096)
  (:window-always-run 256)
  (:window-transparent 16)
  (:window-highdpi 8192)
  (:window-mouse-passthrough 16384)
  (:borderless-windowed-mode 32768)
  (:msaa-4x-hint 32)
  (:interlaced-hint 65536))

(cffi:defcenum trace-log-level
  (:all 0)
  (:trace 1)
  (:debug 2)
  (:info 3)
  (:warning 4)
  (:error 5)
  (:fatal 6)
  (:none 7))

(cffi:defcenum mouse-cursor
  (:default 0)
  (:arrow 1)
  (:ibeam 2)
  (:crosshair 3)
  (:pointing-hand 4)
  (:resize-ew 5)
  (:resize-ns 6)
  (:resize-nwse 7)
  (:resize-nesw 8)
  (:resize-all 9)
  (:not-allowed 10))

(cffi:defcenum material-map-index
  (:albedo 0)
  (:metalness 1)
  (:normal 2)
  (:roughness 3)
  (:occlusion 4)
  (:emission 5)
  (:height 6)
  (:cubemap 7)
  (:irradiance 8)
  (:prefilter 9)
  (:brdf 10))

(cffi:defcenum shader-location-index
  (:vertex-position 0)
  (:vertex-texcoord01 1)
  (:vertex-texcoord02 2)
  (:vertex-normal 3)
  (:vertex-tangent 4)
  (:vertex-color 5)
  (:matrix-mvp 6)
  (:matrix-view 7)
  (:matrix-projection 8)
  (:matrix-model 9)
  (:matrix-normal 10)
  (:vector-view 11)
  (:color-diffuse 12)
  (:color-specular 13)
  (:color-ambient 14)
  (:map-albedo 15)
  (:map-metalness 16)
  (:map-normal 17)
  (:map-roughness 18)
  (:map-occlusion 19)
  (:map-emission 20)
  (:map-height 21)
  (:map-cubemap 22)
  (:map-irradiance 23)
  (:map-prefilter 24)
  (:map-brdf 25)
  (:vertex-boneids 26)
  (:vertex-boneweights 27)
  (:matrix-bonetransforms 28)
  (:vertex-instancetransform 29))

(cffi:defcenum shader-uniform-data-type
  (:float 0)
  (:vec2 1)
  (:vec3 2)
  (:vec4 3)
  (:int 4)
  (:ivec2 5)
  (:ivec3 6)
  (:ivec4 7)
  (:uint 8)
  (:uivec2 9)
  (:uivec3 10)
  (:uivec4 11)
  (:sampler2d 12))

(cffi:defcenum shader-attribute-data-type
  (:float 0)
  (:vec2 1)
  (:vec3 2)
  (:vec4 3))

(cffi:defcenum font-type
  (:default 0)
  (:bitmap 1)
  (:sdf 2))

(cffi:defcenum blend-mode
  (:alpha 0)
  (:additive 1)
  (:multiplied 2)
  (:add-colors 3)
  (:subtract-colors 4)
  (:alpha-premultiply 5)
  (:custom 6)
  (:custom-separate 7))

(cffi:defcenum camera-mode
  (:custom 0)
  (:free 1)
  (:orbital 2)
  (:first-person 3)
  (:third-person 4))

(defun struct-field (structure field)
  "Read a field from a raylib structure using a keyword, e.g. (struct-field point :x)."
  (let ((name (find-symbol (symbol-name field) :raylisp)))
    (unless (and name (loop for key in structure by #'cddr thereis (eq key name)))
      (error "No field ~S on this raylib structure." field))
    (getf structure name)))

(cffi:defcstruct n-patch-info
  (source (:struct rectangle))
  (left :int)
  (top :int)
  (right :int)
  (bottom :int)
  (layout :int))

(cffi:defcstruct wave
  (frame-count :unsigned-int)
  (sample-rate :unsigned-int)
  (sample-size :unsigned-int)
  (channels :unsigned-int)
  (data :pointer))

(cffi:defcstruct audio-stream
  (buffer :pointer)
  (processor :pointer)
  (sample-rate :unsigned-int)
  (sample-size :unsigned-int)
  (channels :unsigned-int))

(cffi:defcstruct sound
  (stream (:struct audio-stream))
  (frame-count :unsigned-int))

(cffi:defcstruct music
  (stream (:struct audio-stream))
  (frame-count :unsigned-int)
  (looping (:boolean :uint8))
  (ctx-type :int)
  (ctx-data :pointer))

(cffi:defcenum pixel-format
  (:uncompressed-grayscale 1)
  (:uncompressed-gray-alpha 2)
  (:uncompressed-r5g6b5 3)
  (:uncompressed-r8g8b8 4)
  (:uncompressed-r5g5b5a1 5)
  (:uncompressed-r4g4b4a4 6)
  (:uncompressed-r8g8b8a8 7)
  (:uncompressed-r32 8)
  (:uncompressed-r32g32b32 9)
  (:uncompressed-r32g32b32a32 10)
  (:uncompressed-r16 11)
  (:uncompressed-r16g16b16 12)
  (:uncompressed-r16g16b16a16 13)
  (:compressed-dxt1-rgb 14)
  (:compressed-dxt1-rgba 15)
  (:compressed-dxt3-rgba 16)
  (:compressed-dxt5-rgba 17)
  (:compressed-etc1-rgb 18)
  (:compressed-etc2-rgb 19)
  (:compressed-etc2-eac-rgba 20)
  (:compressed-pvrt-rgb 21)
  (:compressed-pvrt-rgba 22)
  (:compressed-astc-4x4-rgba 23)
  (:compressed-astc-8x8-rgba 24))

(cffi:defcenum texture-filter
  (:point 0)
  (:bilinear 1)
  (:trilinear 2)
  (:anisotropic-4x 3)
  (:anisotropic-8x 4)
  (:anisotropic-16x 5))

(cffi:defcenum texture-wrap
  (:repeat 0)
  (:clamp 1)
  (:mirror-repeat 2)
  (:mirror-clamp 3))

(cffi:defcenum cubemap-layout
  (:auto-detect 0)
  (:line-vertical 1)
  (:line-horizontal 2)
  (:cross-three-by-four 3)
  (:cross-four-by-three 4))

(cffi:defcenum n-patch-layout
  (:nine-patch 0)
  (:three-patch-vertical 1)
  (:three-patch-horizontal 2))

(cffi:defcenum gesture
  (:none 0)
  (:tap 1)
  (:doubletap 2)
  (:hold 4)
  (:drag 8)
  (:swipe-right 16)
  (:swipe-left 32)
  (:swipe-up 64)
  (:swipe-down 128)
  (:pinch-in 256)
  (:pinch-out 512))
