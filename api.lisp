(in-package #:raylisp)

;;; Window, drawing and input

(defmacro with-window-float-environment (&body body)
  ;; Cocoa and the OpenGL driver expect the usual non-trapping C environment.
  #+(and sbcl darwin)
  `(sb-int:with-float-traps-masked (:invalid :overflow :divide-by-zero :underflow :inexact)
     ,@body)
  #-(and sbcl darwin)
  `(progn ,@body))

(cffi:defcfun ("InitWindow" %init-window) :void (width :int) (height :int) (title :string))
(defun init-window (width height title)
  (with-window-float-environment (%init-window width height title)))

(cffi:defcfun ("CloseWindow" %close-window) :void)
(defun close-window ()
  (with-window-float-environment (%close-window)))

(cffi:defcfun ("WindowShouldClose" window-should-close-p) (:boolean :uint8))
(cffi:defcfun ("SetTargetFPS" set-target-fps) :void (fps :int))

(cffi:defcfun ("GetMouseX" get-mouse-x) :int)
(cffi:defcfun ("GetMouseY" get-mouse-y) :int)

(cffi:defcfun ("BeginDrawing" begin-drawing) :void)
(cffi:defcfun ("EndDrawing" %end-drawing) :void)
(defun end-drawing ()
  (with-window-float-environment (%end-drawing)))
(cffi:defcfun ("ClearBackground" clear-background) :void (color (:struct rgba)))
(cffi:defcfun ("DrawText" draw-text) :void
  (text :string) (x :int) (y :int) (font-size :int) (color (:struct rgba)))
(cffi:defcfun ("DrawCircle" draw-circle) :void
  (x :int) (y :int) (radius :float) (color (:struct rgba)))
(cffi:defcfun ("DrawRectangle" draw-rectangle) :void
  (x :int) (y :int) (width :int) (height :int) (color (:struct rgba)))

(cffi:defcfun ("BeginMode2D" begin-mode-2d) :void (camera (:struct camera-2d)))
(cffi:defcfun ("EndMode2D" end-mode-2d) :void)
(cffi:defcfun ("BeginMode3D" begin-mode-3d) :void (camera (:struct camera-3d)))
(cffi:defcfun ("EndMode3D" end-mode-3d) :void)
(cffi:defcfun ("DrawCube" draw-cube) :void
  (position (:struct vector-3)) (width :float) (height :float) (depth :float)
  (color (:struct rgba)))
(cffi:defcfun ("DrawGrid" draw-grid) :void (slices :int) (spacing :float))

(cffi:defcfun ("DrawTriangle" draw-triangle) :void
  (a (:struct vector-2)) (b (:struct vector-2)) (c (:struct vector-2)) (color (:struct rgba)))
(cffi:defcfun ("DrawSphere" draw-sphere) :void
  (center (:struct vector-3)) (radius :float) (color (:struct rgba)))
(cffi:defcfun ("DrawCylinder" draw-cylinder) :void
  (base (:struct vector-3)) (top-radius :float) (bottom-radius :float)
  (height :float) (sides :int) (color (:struct rgba)))

;; Input names correspond to the four enums in raylib.h.

(cffi:defcfun ("IsKeyDown" key-down-p) (:boolean :uint8) (key keyboard-key))
(cffi:defcfun ("IsKeyPressed" key-pressed-p) (:boolean :uint8) (key keyboard-key))
(cffi:defcfun ("IsMouseButtonDown" mouse-button-down-p) (:boolean :uint8) (button mouse-button))
(cffi:defcfun ("GetMouseWheelMove" get-mouse-wheel-move) :float)
(cffi:defcfun ("IsGamepadAvailable" gamepad-available-p) (:boolean :uint8) (gamepad :int))
(cffi:defcfun ("IsGamepadButtonPressed" gamepad-button-pressed-p) (:boolean :uint8)
  (gamepad :int) (button gamepad-button))
(cffi:defcfun ("GetGamepadAxisMovement" get-gamepad-axis-movement) :float
  (gamepad :int) (axis gamepad-axis))

(cffi:defcfun ("GetKeyPressed" get-key-pressed) :int)
(defun next-key-pressed ()
  "Read one queued key as a keyword, or NIL when the queue is empty."
  (let ((code (get-key-pressed)))
    (unless (zerop code)
      (or (cffi:foreign-enum-keyword 'keyboard-key code :errorp nil) code))))

(cffi:defcfun ("IsMouseButtonPressed" mouse-button-pressed-p) (:boolean :uint8)
  (button mouse-button))

;;; Core

;; Check if window has been initialized successfully
(cffi:defcfun ("IsWindowReady" is-window-ready) (:boolean :uint8))

;; Check if window is currently fullscreen
(cffi:defcfun ("IsWindowFullscreen" is-window-fullscreen) (:boolean :uint8))

;; Check if window is currently hidden
(cffi:defcfun ("IsWindowHidden" is-window-hidden) (:boolean :uint8))

;; Check if window is currently minimized
(cffi:defcfun ("IsWindowMinimized" is-window-minimized) (:boolean :uint8))

;; Check if window is currently maximized
(cffi:defcfun ("IsWindowMaximized" is-window-maximized) (:boolean :uint8))

;; Check if window is currently focused
(cffi:defcfun ("IsWindowFocused" is-window-focused) (:boolean :uint8))

;; Check if window has been resized last frame
(cffi:defcfun ("IsWindowResized" is-window-resized) (:boolean :uint8))

;; Check if one specific window flag is enabled
(cffi:defcfun ("IsWindowState" is-window-state) (:boolean :uint8) (flag config-flags))

;; Set window configuration state using flags
(cffi:defcfun ("SetWindowState" set-window-state) :void (flags config-flags))

;; Clear window configuration state flags
(cffi:defcfun ("ClearWindowState" clear-window-state) :void (flags config-flags))

;; Toggle window state: fullscreen/windowed, resizes monitor to match window resolution
(cffi:defcfun ("ToggleFullscreen" toggle-fullscreen) :void)

;; Toggle window state: borderless windowed, resizes window to match monitor resolution
(cffi:defcfun ("ToggleBorderlessWindowed" toggle-borderless-windowed) :void)

;; Set window state: maximized, if resizable
(cffi:defcfun ("MaximizeWindow" maximize-window) :void)

;; Set window state: minimized, if resizable
(cffi:defcfun ("MinimizeWindow" minimize-window) :void)

;; Restore window from being minimized/maximized
(cffi:defcfun ("RestoreWindow" restore-window) :void)

;; Set icon for window (single image, RGBA 32bit)
(cffi:defcfun ("SetWindowIcon" set-window-icon) :void (image (:struct image)))

;; Set icon for window (multiple images, RGBA 32bit)
(cffi:defcfun ("SetWindowIcons" set-window-icons) :void (images :pointer) (count :int))

;; Set title for window
(cffi:defcfun ("SetWindowTitle" set-window-title) :void (title :string))

;; Set window position on screen
(cffi:defcfun ("SetWindowPosition" set-window-position) :void (x :int) (y :int))

;; Set monitor for the current window
(cffi:defcfun ("SetWindowMonitor" set-window-monitor) :void (monitor :int))

;; Set window minimum dimensions (for FLAG_WINDOW_RESIZABLE)
(cffi:defcfun ("SetWindowMinSize" set-window-min-size) :void (width :int) (height :int))

;; Set window maximum dimensions (for FLAG_WINDOW_RESIZABLE)
(cffi:defcfun ("SetWindowMaxSize" set-window-max-size) :void (width :int) (height :int))

;; Set window dimensions
(cffi:defcfun ("SetWindowSize" set-window-size) :void (width :int) (height :int))

;; Set window opacity [0.0f..1.0f]
(cffi:defcfun ("SetWindowOpacity" set-window-opacity) :void (opacity :float))

;; Set window focused
(cffi:defcfun ("SetWindowFocused" set-window-focused) :void)

;; Get native window handle
(cffi:defcfun ("GetWindowHandle" get-window-handle) :pointer)

;; Get current screen width
(cffi:defcfun ("GetScreenWidth" get-screen-width) :int)

;; Get current screen height
(cffi:defcfun ("GetScreenHeight" get-screen-height) :int)

;; Get current render width (it considers HiDPI)
(cffi:defcfun ("GetRenderWidth" get-render-width) :int)

;; Get current render height (it considers HiDPI)
(cffi:defcfun ("GetRenderHeight" get-render-height) :int)

;; Get number of connected monitors
(cffi:defcfun ("GetMonitorCount" get-monitor-count) :int)

;; Get current monitor where window is placed
(cffi:defcfun ("GetCurrentMonitor" get-current-monitor) :int)

;; Get specified monitor position
(cffi:defcfun ("GetMonitorPosition" get-monitor-position) (:struct vector-2) (monitor :int))

;; Get specified monitor width (current video mode used by monitor)
(cffi:defcfun ("GetMonitorWidth" get-monitor-width) :int (monitor :int))

;; Get specified monitor height (current video mode used by monitor)
(cffi:defcfun ("GetMonitorHeight" get-monitor-height) :int (monitor :int))

;; Get specified monitor physical width in millimetres
(cffi:defcfun ("GetMonitorPhysicalWidth" get-monitor-physical-width) :int (monitor :int))

;; Get specified monitor physical height in millimetres
(cffi:defcfun ("GetMonitorPhysicalHeight" get-monitor-physical-height) :int (monitor :int))

;; Get specified monitor refresh rate
(cffi:defcfun ("GetMonitorRefreshRate" get-monitor-refresh-rate) :int (monitor :int))

;; Get window position XY on monitor
(cffi:defcfun ("GetWindowPosition" get-window-position) (:struct vector-2))

;; Get window scale DPI factor
(cffi:defcfun ("GetWindowScaleDPI" get-window-scale-dpi) (:struct vector-2))

;; Get the human-readable, UTF-8 encoded name of the specified monitor
(cffi:defcfun ("GetMonitorName" get-monitor-name) :string (monitor :int))

;; Set clipboard text content
(cffi:defcfun ("SetClipboardText" set-clipboard-text) :void (text :string))

;; Get clipboard text content
(cffi:defcfun ("GetClipboardText" get-clipboard-text) :string)

;; Get clipboard image content
(cffi:defcfun ("GetClipboardImage" get-clipboard-image) (:struct image))

;; Enable waiting for events on EndDrawing(), no automatic event polling
(cffi:defcfun ("EnableEventWaiting" enable-event-waiting) :void)

;; Disable waiting for events on EndDrawing(), automatic events polling
(cffi:defcfun ("DisableEventWaiting" disable-event-waiting) :void)

;; Show cursor
(cffi:defcfun ("ShowCursor" show-cursor) :void)

;; Hide cursor
(cffi:defcfun ("HideCursor" hide-cursor) :void)

;; Check if cursor is not visible
(cffi:defcfun ("IsCursorHidden" is-cursor-hidden) (:boolean :uint8))

;; Enable cursor (unlock cursor)
(cffi:defcfun ("EnableCursor" enable-cursor) :void)

;; Disable cursor (lock cursor)
(cffi:defcfun ("DisableCursor" disable-cursor) :void)

;; Check if cursor is on the screen
(cffi:defcfun ("IsCursorOnScreen" is-cursor-on-screen) (:boolean :uint8))

;; Begin drawing to render texture
(cffi:defcfun ("BeginTextureMode" begin-texture-mode) :void (target (:struct render-texture)))

;; End drawing to render texture
(cffi:defcfun ("EndTextureMode" end-texture-mode) :void)

;; Begin custom shader drawing
(cffi:defcfun ("BeginShaderMode" begin-shader-mode) :void (shader (:struct shader)))

;; End custom shader drawing (use default shader)
(cffi:defcfun ("EndShaderMode" end-shader-mode) :void)

;; Begin blending mode (alpha, additive, multiplied, subtract, custom)
(cffi:defcfun ("BeginBlendMode" begin-blend-mode) :void (mode blend-mode))

;; End blending mode (reset to default: alpha blending)
(cffi:defcfun ("EndBlendMode" end-blend-mode) :void)

;; Begin scissor mode (define screen area for following drawing)
(cffi:defcfun ("BeginScissorMode" begin-scissor-mode) :void
  (x :int) (y :int) (width :int) (height :int))

;; End scissor mode
(cffi:defcfun ("EndScissorMode" end-scissor-mode) :void)

;; Begin stereo rendering (requires VR simulator)
(cffi:defcfun ("BeginVrStereoMode" begin-vr-stereo-mode) :void (config (:struct vr-stereo-config)))

;; End stereo rendering (requires VR simulator)
(cffi:defcfun ("EndVrStereoMode" end-vr-stereo-mode) :void)

;; Load VR stereo config for VR simulator device parameters
(cffi:defcfun ("LoadVrStereoConfig" load-vr-stereo-config) (:struct vr-stereo-config)
  (device (:struct vr-device-info)))

;; Unload VR stereo config
(cffi:defcfun ("UnloadVrStereoConfig" unload-vr-stereo-config) :void
  (config (:struct vr-stereo-config)))

;; Load shader from files and bind default locations
(cffi:defcfun ("LoadShader" load-shader) (:struct shader)
  (vs-file-name :string) (fs-file-name :string))

;; Load shader from code strings and bind default locations
(cffi:defcfun ("LoadShaderFromMemory" load-shader-from-memory) (:struct shader)
  (vs-code :string) (fs-code :string))

;; Check if shader is valid (loaded on GPU)
(cffi:defcfun ("IsShaderValid" %is-shader-valid) :unsigned-char (shader (:struct shader)))

(defun is-shader-valid (shader)
  (not (zerop (%is-shader-valid shader))))

;; Get shader uniform location
(cffi:defcfun ("GetShaderLocation" get-shader-location) :int
  (shader (:struct shader)) (uniform-name :string))

;; Get shader attribute location
(cffi:defcfun ("GetShaderLocationAttrib" get-shader-location-attrib) :int
  (shader (:struct shader)) (attrib-name :string))

;; Set shader uniform value
(cffi:defcfun ("SetShaderValue" set-shader-value) :void
  (shader (:struct shader))
  (loc-index :int)
  (value :pointer)
  (uniform-type shader-uniform-data-type))

;; Set shader uniform value vector
(cffi:defcfun ("SetShaderValueV" set-shader-value-v) :void
  (shader (:struct shader))
  (loc-index :int)
  (value :pointer)
  (uniform-type shader-uniform-data-type)
  (count :int))

;; Set shader uniform value (matrix 4x4)
(cffi:defcfun ("SetShaderValueMatrix" set-shader-value-matrix) :void
  (shader (:struct shader)) (loc-index :int) (mat (:struct matrix)))

;; Set shader uniform value and bind the texture (sampler2d)
(cffi:defcfun ("SetShaderValueTexture" set-shader-value-texture) :void
  (shader (:struct shader)) (loc-index :int) (texture (:struct texture)))

;; Unload shader from GPU memory (VRAM)
(cffi:defcfun ("UnloadShader" unload-shader) :void (shader (:struct shader)))

;; Get a ray trace from screen position (i.e mouse)
(cffi:defcfun ("GetScreenToWorldRay" get-screen-to-world-ray) (:struct ray)
  (position (:struct vector-2)) (camera (:struct camera-3d)))

;; Get a ray trace from screen position (i.e mouse) in a viewport
(cffi:defcfun ("GetScreenToWorldRayEx" get-screen-to-world-ray-ex) (:struct ray)
  (position (:struct vector-2)) (camera (:struct camera-3d)) (width :int) (height :int))

;; Get screen space position for a 3d world space position
(cffi:defcfun ("GetWorldToScreen" get-world-to-screen) (:struct vector-2)
  (position (:struct vector-3)) (camera (:struct camera-3d)))

;; Get sized screen space position for a 3d world space position
(cffi:defcfun ("GetWorldToScreenEx" get-world-to-screen-ex) (:struct vector-2)
  (position (:struct vector-3)) (camera (:struct camera-3d)) (width :int) (height :int))

;; Get screen space position for a 2d camera world space position
(cffi:defcfun ("GetWorldToScreen2D" get-world-to-screen-2d) (:struct vector-2)
  (position (:struct vector-2)) (camera (:struct camera-2d)))

;; Get world space position for a 2d camera screen space position
(cffi:defcfun ("GetScreenToWorld2D" get-screen-to-world-2d) (:struct vector-2)
  (position (:struct vector-2)) (camera (:struct camera-2d)))

;; Get camera transform matrix (view matrix)
(cffi:defcfun ("GetCameraMatrix" get-camera-matrix) (:struct matrix) (camera (:struct camera-3d)))

;; Get camera 2d transform matrix
(cffi:defcfun ("GetCameraMatrix2D" get-camera-matrix-2d) (:struct matrix)
  (camera (:struct camera-2d)))

;; Get time in seconds for last frame drawn (delta time)
(cffi:defcfun ("GetFrameTime" get-frame-time) :float)

;; Get elapsed time in seconds since InitWindow()
(cffi:defcfun ("GetTime" get-time) :double)

;; Get current FPS
(cffi:defcfun ("GetFPS" get-fps) :int)

;; Swap back buffer with front buffer (screen drawing)
(cffi:defcfun ("SwapScreenBuffer" swap-screen-buffer) :void)

;; Register all input events
(cffi:defcfun ("PollInputEvents" poll-input-events) :void)

;; Wait for some time (halt program execution)
(cffi:defcfun ("WaitTime" wait-time) :void (seconds :double))

;; Set the seed for the random number generator
(cffi:defcfun ("SetRandomSeed" set-random-seed) :void (seed :unsigned-int))

;; Get a random value between min and max (both included)
(cffi:defcfun ("GetRandomValue" get-random-value) :int (min :int) (max :int))

;; Load random values sequence, no values repeated
(cffi:defcfun ("LoadRandomSequence" load-random-sequence) :pointer
  (count :unsigned-int) (min :int) (max :int))

;; Unload random values sequence
(cffi:defcfun ("UnloadRandomSequence" unload-random-sequence) :void (sequence :pointer))

;; Takes a screenshot of current screen (filename extension defines format)
(cffi:defcfun ("TakeScreenshot" take-screenshot) :void (file-name :string))

;; Set init configuration flags (view FLAGS)
(cffi:defcfun ("SetConfigFlags" set-config-flags) :void (flags config-flags))

;; Open URL with default system browser (if available)
(cffi:defcfun ("OpenURL" open-url) :void (url :string))

;; Set the current threshold (minimum) log level
(cffi:defcfun ("SetTraceLogLevel" set-trace-log-level) :void (log-level trace-log-level))

;; Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...)
(cffi:defcfun ("TraceLog" trace-log) :void (log-level trace-log-level) (text :string)
  &rest)

;; Set custom trace log
;; Callback signature: void callback(int logLevel, const char *text, va_list args)
(cffi:defcfun ("SetTraceLogCallback" set-trace-log-callback) :void (callback :pointer))

;; Internal memory allocator
(cffi:defcfun ("MemAlloc" mem-alloc) :pointer (size :unsigned-int))

;; Internal memory reallocator
(cffi:defcfun ("MemRealloc" mem-realloc) :pointer (ptr :pointer) (size :unsigned-int))

;; Internal memory free
(cffi:defcfun ("MemFree" mem-free) :void (ptr :pointer))

;; Load file data as byte array (read)
(cffi:defcfun ("LoadFileData" load-file-data) :pointer (file-name :string) (data-size :pointer))

;; Unload file data allocated by LoadFileData()
(cffi:defcfun ("UnloadFileData" unload-file-data) :void (data :pointer))

;; Save data to file from byte array (write), returns true on success
(cffi:defcfun ("SaveFileData" save-file-data) (:boolean :uint8)
  (file-name :string) (data :pointer) (data-size :int))

;; Export data to code (.h), returns true on success
(cffi:defcfun ("ExportDataAsCode" export-data-as-code) (:boolean :uint8)
  (data :pointer) (data-size :int) (file-name :string))

;; Load text data from file (read), returns a '\0' terminated string
(cffi:defcfun ("LoadFileText" load-file-text) :pointer (file-name :string))

;; Unload file text data allocated by LoadFileText()
(cffi:defcfun ("UnloadFileText" unload-file-text) :void (text :pointer))

;; Save text data to file (write), string must be '\0' terminated, returns true on success
(cffi:defcfun ("SaveFileText" save-file-text) (:boolean :uint8) (file-name :string) (text :string))

;; Set custom file binary data loader
;; Callback signature: unsigned char * callback(const char *fileName, int *dataSize)
(cffi:defcfun ("SetLoadFileDataCallback" set-load-file-data-callback) :void (callback :pointer))

;; Set custom file binary data saver
;; Callback signature: bool callback(const char *fileName, const void *data, int dataSize)
(cffi:defcfun ("SetSaveFileDataCallback" set-save-file-data-callback) :void (callback :pointer))

;; Set custom file text data loader
;; Callback signature: char * callback(const char *fileName)
(cffi:defcfun ("SetLoadFileTextCallback" set-load-file-text-callback) :void (callback :pointer))

;; Set custom file text data saver
;; Callback signature: bool callback(const char *fileName, const char *text)
(cffi:defcfun ("SetSaveFileTextCallback" set-save-file-text-callback) :void (callback :pointer))

;; Rename file (if exists), returns 0 on success
(cffi:defcfun ("FileRename" file-rename) :int (file-name :string) (file-rename :string))

;; Remove file (if exists), returns 0 on success
(cffi:defcfun ("FileRemove" file-remove) :int (file-name :string))

;; Copy file from one path to another, dstPath created if it doesn't exist, returns 0 on success
(cffi:defcfun ("FileCopy" file-copy) :int (src-path :string) (dst-path :string))

;; Move file from one directory to another, dstPath created if it doesn't exist, returns 0 on success
(cffi:defcfun ("FileMove" file-move) :int (src-path :string) (dst-path :string))

;; Replace text in an existing file, returns 0 on success
(cffi:defcfun ("FileTextReplace" file-text-replace) :int
  (file-name :string) (search :string) (replacement :string))

;; Find text in existing file, returns -1 if index not found or index otherwise
(cffi:defcfun ("FileTextFindIndex" file-text-find-index) :int (file-name :string) (search :string))

;; Check if file exists
(cffi:defcfun ("FileExists" file-exists) (:boolean :uint8) (file-name :string))

;; Check if directory path exists
(cffi:defcfun ("DirectoryExists" directory-exists) (:boolean :uint8) (dir-path :string))

;; Check file extension (recommended include point: .png, .wav)
(cffi:defcfun ("IsFileExtension" is-file-extension) (:boolean :uint8)
  (file-name :string) (ext :string))

;; Check if file path (file or directory) is hidden by OS
(cffi:defcfun ("IsFileHidden" is-file-hidden) (:boolean :uint8) (file-path :string))

;; Get file length in bytes (NOTE: GetFileSize() conflicts with windows.h)
(cffi:defcfun ("GetFileLength" get-file-length) :int (file-name :string))

;; Get file modification time (last write time)
(cffi:defcfun ("GetFileModTime" get-file-mod-time) :long (file-name :string))

;; Get pointer to extension for a filename string (includes dot: '.png')
(cffi:defcfun ("GetFileExtension" get-file-extension) :string (file-name :string))

;; Get pointer to filename for a path string
(cffi:defcfun ("GetFileName" get-file-name) :string (file-path :string))

;; Get filename string without extension (uses static string)
(cffi:defcfun ("GetFileNameWithoutExt" get-file-name-without-ext) :string (file-path :string))

;; Get full path for a provided fileName with path (uses static string)
(cffi:defcfun ("GetDirectoryPath" get-directory-path) :string (file-path :string))

;; Get previous directory path for a provided path (uses static string)
(cffi:defcfun ("GetPrevDirectoryPath" get-prev-directory-path) :string (dir-path :string))

;; Get current working directory (uses static string)
(cffi:defcfun ("GetWorkingDirectory" get-working-directory) :string)

;; Get the directory of the running application (uses static string)
(cffi:defcfun ("GetApplicationDirectory" get-application-directory) :string)

;; Create directories (including full path requested), returns 0 on success
(cffi:defcfun ("MakeDirectory" make-directory) :int (dir-path :string))

;; Change working directory, returns 0 on success
(cffi:defcfun ("ChangeDirectory" change-directory) :int (dir-path :string))

;; Check if provided path points to a file
(cffi:defcfun ("IsPathFile" is-path-file) (:boolean :uint8) (path :string))

;; Check if provided path points to a directory
(cffi:defcfun ("IsPathDirectory" is-path-directory) (:boolean :uint8) (path :string))

;; Check if provided path is an absolute path
(cffi:defcfun ("IsPathAbsolute" is-path-absolute) (:boolean :uint8) (path :string))

;; Check if fileName is valid for the platform/OS
(cffi:defcfun ("IsFileNameValid" is-file-name-valid) (:boolean :uint8) (file-name :string))

;; Load directory filepaths, files and directories, no subdirs scan
(cffi:defcfun ("LoadDirectoryFiles" load-directory-files) (:struct file-path-list)
  (dir-path :string))

;; Load directory filepaths with extension filtering and subdir scan; some filters available: '*.*','FILES*','DIRS*'
(cffi:defcfun ("LoadDirectoryFilesEx" load-directory-files-ex) (:struct file-path-list)
  (base-path :string) (filter :string) (scan-subdirs (:boolean :uint8)))

;; Unload filepaths
(cffi:defcfun ("UnloadDirectoryFiles" unload-directory-files) :void
  (files (:struct file-path-list)))

;; Check if file has been dropped into window
(cffi:defcfun ("IsFileDropped" is-file-dropped) (:boolean :uint8))

;; Load dropped filepaths
(cffi:defcfun ("LoadDroppedFiles" load-dropped-files) (:struct file-path-list))

;; Unload dropped filepaths
(cffi:defcfun ("UnloadDroppedFiles" unload-dropped-files) :void (files (:struct file-path-list)))

;; Get the file count in a directory
(cffi:defcfun ("GetDirectoryFileCount" get-directory-file-count) :unsigned-int (dir-path :string))

;; Get the file count in a directory with extension filtering and recursive directory scan. Use 'DIR' in the filter string to include directories in the result
(cffi:defcfun ("GetDirectoryFileCountEx" get-directory-file-count-ex) :unsigned-int
  (base-path :string) (filter :string) (scan-subdirs (:boolean :uint8)))

;; Compress data (DEFLATE algorithm), memory must be MemFree()
(cffi:defcfun ("CompressData" compress-data) :pointer
  (data :pointer) (data-size :int) (comp-data-size :pointer))

;; Decompress data (DEFLATE algorithm), memory must be MemFree()
(cffi:defcfun ("DecompressData" decompress-data) :pointer
  (comp-data :pointer) (comp-data-size :int) (data-size :pointer))

;; Encode data to Base64 string (includes NULL terminator), memory must be MemFree()
(cffi:defcfun ("EncodeDataBase64" encode-data-base64) :pointer
  (data :pointer) (data-size :int) (output-size :pointer))

;; Decode Base64 string (expected NULL terminated), memory must be MemFree()
(cffi:defcfun ("DecodeDataBase64" decode-data-base64) :pointer
  (text :string) (output-size :pointer))

;; Compute CRC32 hash code
(cffi:defcfun ("ComputeCRC32" compute-crc32) :unsigned-int (data :pointer) (data-size :int))

;; Compute MD5 hash code, returns static int[4] (16 bytes)
(cffi:defcfun ("ComputeMD5" compute-md5) :pointer (data :pointer) (data-size :int))

;; Compute SHA1 hash code, returns static int[5] (20 bytes)
(cffi:defcfun ("ComputeSHA1" compute-sha1) :pointer (data :pointer) (data-size :int))

;; Compute SHA256 hash code, returns static int[8] (32 bytes)
(cffi:defcfun ("ComputeSHA256" compute-sha256) :pointer (data :pointer) (data-size :int))

;; Load automation events list from file, NULL for empty list, capacity = MAX_AUTOMATION_EVENTS
(cffi:defcfun ("LoadAutomationEventList" load-automation-event-list) (:struct automation-event-list)
  (file-name :string))

;; Unload automation events list from file
(cffi:defcfun ("UnloadAutomationEventList" unload-automation-event-list) :void
  (list (:struct automation-event-list)))

;; Export automation events list as text file
(cffi:defcfun ("ExportAutomationEventList" %export-automation-event-list) :unsigned-char
  (list (:struct automation-event-list)) (file-name :string))

(defun export-automation-event-list (list file-name)
  (not (zerop (%export-automation-event-list list file-name))))

;; Set automation event list to record to
(cffi:defcfun ("SetAutomationEventList" set-automation-event-list) :void (list :pointer))

;; Set automation event internal base frame to start recording
(cffi:defcfun ("SetAutomationEventBaseFrame" set-automation-event-base-frame) :void (frame :int))

;; Start recording automation events (AutomationEventList must be set)
(cffi:defcfun ("StartAutomationEventRecording" start-automation-event-recording) :void)

;; Stop recording automation events
(cffi:defcfun ("StopAutomationEventRecording" stop-automation-event-recording) :void)

;; Play a recorded automation event
(cffi:defcfun ("PlayAutomationEvent" play-automation-event) :void
  (event (:struct automation-event)))

;; Check if key has been pressed again
(cffi:defcfun ("IsKeyPressedRepeat" is-key-pressed-repeat) (:boolean :uint8) (key keyboard-key))

;; Check if key has been released once
(cffi:defcfun ("IsKeyReleased" is-key-released) (:boolean :uint8) (key keyboard-key))

;; Check if key is NOT being pressed
(cffi:defcfun ("IsKeyUp" is-key-up) (:boolean :uint8) (key keyboard-key))

;; Get char pressed (unicode), call it multiple times for chars queued, returns 0 when the queue is empty
(cffi:defcfun ("GetCharPressed" get-char-pressed) :int)

;; Get name of a QWERTY key on the current keyboard layout (eg returns string 'q' for KEY_A on an AZERTY keyboard)
(cffi:defcfun ("GetKeyName" get-key-name) :string (key keyboard-key))

;; Set a custom key to exit program (default is ESC)
(cffi:defcfun ("SetExitKey" set-exit-key) :void (key keyboard-key))

;; Get gamepad internal name id
(cffi:defcfun ("GetGamepadName" get-gamepad-name) :string (gamepad :int))

;; Check if gamepad button is being pressed
(cffi:defcfun ("IsGamepadButtonDown" is-gamepad-button-down) (:boolean :uint8)
  (gamepad :int) (button gamepad-button))

;; Check if gamepad button has been released once
(cffi:defcfun ("IsGamepadButtonReleased" is-gamepad-button-released) (:boolean :uint8)
  (gamepad :int) (button gamepad-button))

;; Check if gamepad button is NOT being pressed
(cffi:defcfun ("IsGamepadButtonUp" is-gamepad-button-up) (:boolean :uint8)
  (gamepad :int) (button gamepad-button))

;; Get the last gamepad button pressed
(cffi:defcfun ("GetGamepadButtonPressed" get-gamepad-button-pressed) :int)

;; Get axis count for a gamepad
(cffi:defcfun ("GetGamepadAxisCount" get-gamepad-axis-count) :int (gamepad :int))

;; Set internal gamepad mappings (SDL_GameControllerDB)
(cffi:defcfun ("SetGamepadMappings" set-gamepad-mappings) :int (mappings :string))

;; Set gamepad vibration for both motors (duration in seconds)
(cffi:defcfun ("SetGamepadVibration" set-gamepad-vibration) :void
  (gamepad :int) (left-motor :float) (right-motor :float) (duration :float))

;; Check if mouse button has been released once
(cffi:defcfun ("IsMouseButtonReleased" is-mouse-button-released) (:boolean :uint8)
  (button mouse-button))

;; Check if mouse button is NOT being pressed
(cffi:defcfun ("IsMouseButtonUp" is-mouse-button-up) (:boolean :uint8) (button mouse-button))

;; Get mouse position XY
(cffi:defcfun ("GetMousePosition" get-mouse-position) (:struct vector-2))

;; Get mouse delta between frames
(cffi:defcfun ("GetMouseDelta" get-mouse-delta) (:struct vector-2))

;; Set mouse position XY
(cffi:defcfun ("SetMousePosition" set-mouse-position) :void (x :int) (y :int))

;; Set mouse offset
(cffi:defcfun ("SetMouseOffset" set-mouse-offset) :void (offset-x :int) (offset-y :int))

;; Set mouse scaling
(cffi:defcfun ("SetMouseScale" set-mouse-scale) :void (scale-x :float) (scale-y :float))

;; Get mouse wheel movement for both X and Y
(cffi:defcfun ("GetMouseWheelMoveV" get-mouse-wheel-move-v) (:struct vector-2))

;; Set mouse cursor
(cffi:defcfun ("SetMouseCursor" set-mouse-cursor) :void (cursor mouse-cursor))

;; Get touch position X for touch point 0 (relative to screen size)
(cffi:defcfun ("GetTouchX" get-touch-x) :int)

;; Get touch position Y for touch point 0 (relative to screen size)
(cffi:defcfun ("GetTouchY" get-touch-y) :int)

;; Get touch position XY for a touch point index (relative to screen size)
(cffi:defcfun ("GetTouchPosition" get-touch-position) (:struct vector-2) (index :int))

;; Get touch point identifier for provided index
(cffi:defcfun ("GetTouchPointId" get-touch-point-id) :int (index :int))

;; Get number of touch points
(cffi:defcfun ("GetTouchPointCount" get-touch-point-count) :int)

;;; Gestures

;; Enable a set of gestures using flags
(cffi:defcfun ("SetGesturesEnabled" set-gestures-enabled) :void (flags :unsigned-int))

;; Check if gesture has been detected
(cffi:defcfun ("IsGestureDetected" is-gesture-detected) (:boolean :uint8) (gesture gesture))

;; Get latest detected gesture
(cffi:defcfun ("GetGestureDetected" get-gesture-detected) :int)

;; Get gesture hold time in seconds
(cffi:defcfun ("GetGestureHoldDuration" get-gesture-hold-duration) :float)

;; Get gesture drag vector
(cffi:defcfun ("GetGestureDragVector" get-gesture-drag-vector) (:struct vector-2))

;; Get gesture drag angle
(cffi:defcfun ("GetGestureDragAngle" get-gesture-drag-angle) :float)

;; Get gesture pinch delta
(cffi:defcfun ("GetGesturePinchVector" get-gesture-pinch-vector) (:struct vector-2))

;; Get gesture pinch angle
(cffi:defcfun ("GetGesturePinchAngle" get-gesture-pinch-angle) :float)

;;; Shape drawing

(cffi:defcfun ("DrawPixel" draw-pixel) :void (pos-x :int) (pos-y :int) (color (:struct rgba)))

(cffi:defcfun ("DrawPixelV" draw-pixel-v) :void
  (position (:struct vector-2)) (color (:struct rgba)))

(cffi:defcfun ("DrawLine" draw-line) :void
  (start-pos-x :int) (start-pos-y :int) (end-pos-x :int) (end-pos-y :int) (color (:struct rgba)))

(cffi:defcfun ("DrawLineV" draw-line-v) :void
  (start-pos (:struct vector-2)) (end-pos (:struct vector-2)) (color (:struct rgba)))

(cffi:defcfun ("DrawLineEx" draw-line-ex) :void
  (start-pos (:struct vector-2))
  (end-pos (:struct vector-2))
  (thick :float)
  (color (:struct rgba)))

(cffi:defcfun ("DrawLineStrip" %draw-line-strip) :void
  (points :pointer) (point-count :int) (color (:struct rgba)))

(defun draw-line-strip (points color)
  (with-point-array (pointer points (:struct vector-2))
    (%draw-line-strip pointer (length points) color)))

(cffi:defcfun ("DrawLineBezier" draw-line-bezier) :void
  (start-pos (:struct vector-2))
  (end-pos (:struct vector-2))
  (thick :float)
  (color (:struct rgba)))

(cffi:defcfun ("DrawLineDashed" draw-line-dashed) :void
  (start-pos (:struct vector-2))
  (end-pos (:struct vector-2))
  (dash-size :int)
  (space-size :int)
  (color (:struct rgba)))

(cffi:defcfun ("DrawTriangleGradient" draw-triangle-gradient) :void
  (v1 (:struct vector-2))
  (v2 (:struct vector-2))
  (v3 (:struct vector-2))
  (c1 (:struct rgba))
  (c2 (:struct rgba))
  (c3 (:struct rgba)))

(cffi:defcfun ("DrawTriangleLines" draw-triangle-lines) :void
  (v1 (:struct vector-2)) (v2 (:struct vector-2)) (v3 (:struct vector-2)) (color (:struct rgba)))

(cffi:defcfun ("DrawTriangleLinesEx" draw-triangle-lines-ex) :void
  (v1 (:struct vector-2))
  (v2 (:struct vector-2))
  (v3 (:struct vector-2))
  (thick :float)
  (color (:struct rgba)))

(cffi:defcfun ("DrawTriangleFan" %draw-triangle-fan) :void
  (points :pointer) (point-count :int) (color (:struct rgba)))

(defun draw-triangle-fan (points color)
  (with-point-array (pointer points (:struct vector-2))
    (%draw-triangle-fan pointer (length points) color)))

(cffi:defcfun ("DrawTriangleStrip" %draw-triangle-strip) :void
  (points :pointer) (point-count :int) (color (:struct rgba)))

(defun draw-triangle-strip (points color)
  (with-point-array (pointer points (:struct vector-2))
    (%draw-triangle-strip pointer (length points) color)))

(cffi:defcfun ("DrawRectangleV" draw-rectangle-v) :void
  (position (:struct vector-2)) (size (:struct vector-2)) (color (:struct rgba)))

(cffi:defcfun ("DrawRectangleRec" draw-rectangle-rec) :void
  (rec (:struct rectangle)) (color (:struct rgba)))

(cffi:defcfun ("DrawRectanglePro" draw-rectangle-pro) :void
  (rec (:struct rectangle)) (origin (:struct vector-2)) (rotation :float) (color (:struct rgba)))

(cffi:defcfun ("DrawRectangleGradientV" draw-rectangle-gradient-v) :void
  (pos-x :int)
  (pos-y :int)
  (width :int)
  (height :int)
  (top (:struct rgba))
  (bottom (:struct rgba)))

(cffi:defcfun ("DrawRectangleGradientH" draw-rectangle-gradient-h) :void
  (pos-x :int)
  (pos-y :int)
  (width :int)
  (height :int)
  (left (:struct rgba))
  (right (:struct rgba)))

(cffi:defcfun ("DrawRectangleGradientEx" draw-rectangle-gradient-ex) :void
  (rec (:struct rectangle))
  (col1 (:struct rgba))
  (col2 (:struct rgba))
  (col3 (:struct rgba))
  (col4 (:struct rgba)))

(cffi:defcfun ("DrawRectangleLines" draw-rectangle-lines) :void
  (pos-x :int) (pos-y :int) (width :int) (height :int) (color (:struct rgba)))

(cffi:defcfun ("DrawRectangleLinesEx" draw-rectangle-lines-ex) :void
  (rec (:struct rectangle)) (thick :float) (color (:struct rgba)))

(cffi:defcfun ("DrawRectangleRounded" draw-rectangle-rounded) :void
  (rec (:struct rectangle)) (roundness :float) (segments :int) (color (:struct rgba)))

(cffi:defcfun ("DrawRectangleRoundedLines" draw-rectangle-rounded-lines) :void
  (rec (:struct rectangle)) (roundness :float) (segments :int) (color (:struct rgba)))

(cffi:defcfun ("DrawRectangleRoundedLinesEx" draw-rectangle-rounded-lines-ex) :void
  (rec (:struct rectangle))
  (roundness :float)
  (segments :int)
  (thick :float)
  (color (:struct rgba)))

(cffi:defcfun ("DrawPoly" draw-poly) :void
  (center (:struct vector-2))
  (sides :int)
  (radius :float)
  (rotation :float)
  (color (:struct rgba)))

(cffi:defcfun ("DrawPolyLines" draw-poly-lines) :void
  (center (:struct vector-2))
  (sides :int)
  (radius :float)
  (rotation :float)
  (color (:struct rgba)))

(cffi:defcfun ("DrawPolyLinesEx" draw-poly-lines-ex) :void
  (center (:struct vector-2))
  (sides :int)
  (radius :float)
  (rotation :float)
  (thick :float)
  (color (:struct rgba)))

(cffi:defcfun ("DrawCircleV" draw-circle-v) :void
  (center (:struct vector-2)) (radius :float) (color (:struct rgba)))

(cffi:defcfun ("DrawCircleGradient" draw-circle-gradient) :void
  (center (:struct vector-2)) (radius :float) (inner (:struct rgba)) (outer (:struct rgba)))

(cffi:defcfun ("DrawCircleSector" draw-circle-sector) :void
  (center (:struct vector-2))
  (radius :float)
  (start-angle :float)
  (end-angle :float)
  (segments :int)
  (color (:struct rgba)))

(cffi:defcfun ("DrawCircleSectorLines" draw-circle-sector-lines) :void
  (center (:struct vector-2))
  (radius :float)
  (start-angle :float)
  (end-angle :float)
  (segments :int)
  (color (:struct rgba)))

(cffi:defcfun ("DrawCircleSectorLinesEx" draw-circle-sector-lines-ex) :void
  (center (:struct vector-2))
  (radius :float)
  (start-angle :float)
  (end-angle :float)
  (segments :int)
  (thick :float)
  (color (:struct rgba)))

(cffi:defcfun ("DrawCircleLines" draw-circle-lines) :void
  (center-x :int) (center-y :int) (radius :float) (color (:struct rgba)))

(cffi:defcfun ("DrawCircleLinesV" draw-circle-lines-v) :void
  (center (:struct vector-2)) (radius :float) (color (:struct rgba)))

(cffi:defcfun ("DrawCircleLinesEx" draw-circle-lines-ex) :void
  (center (:struct vector-2)) (radius :float) (thick :float) (color (:struct rgba)))

(cffi:defcfun ("DrawEllipse" draw-ellipse) :void
  (center-x :int) (center-y :int) (radius-h :float) (radius-v :float) (color (:struct rgba)))

(cffi:defcfun ("DrawEllipseV" draw-ellipse-v) :void
  (center (:struct vector-2)) (radius-h :float) (radius-v :float) (color (:struct rgba)))

(cffi:defcfun ("DrawEllipseLines" draw-ellipse-lines) :void
  (center-x :int) (center-y :int) (radius-h :float) (radius-v :float) (color (:struct rgba)))

(cffi:defcfun ("DrawEllipseLinesV" draw-ellipse-lines-v) :void
  (center (:struct vector-2)) (radius-h :float) (radius-v :float) (color (:struct rgba)))

(cffi:defcfun ("DrawEllipseLinesEx" draw-ellipse-lines-ex) :void
  (center (:struct vector-2))
  (radius-h :float)
  (radius-v :float)
  (thick :float)
  (color (:struct rgba)))

(cffi:defcfun ("DrawRing" draw-ring) :void
  (center (:struct vector-2))
  (inner-radius :float)
  (outer-radius :float)
  (start-angle :float)
  (end-angle :float)
  (segments :int)
  (color (:struct rgba)))

(cffi:defcfun ("DrawRingLines" draw-ring-lines) :void
  (center (:struct vector-2))
  (inner-radius :float)
  (outer-radius :float)
  (start-angle :float)
  (end-angle :float)
  (segments :int)
  (color (:struct rgba)))

(cffi:defcfun ("DrawRingLinesEx" draw-ring-lines-ex) :void
  (center (:struct vector-2))
  (inner-radius :float)
  (outer-radius :float)
  (start-angle :float)
  (end-angle :float)
  (segments :int)
  (thick :float)
  (color (:struct rgba)))

(cffi:defcfun ("DrawSplineLinear" %draw-spline-linear) :void
  (points :pointer) (point-count :int) (thick :float) (color (:struct rgba)))

(defun draw-spline-linear (points thick color)
  (with-point-array (pointer points (:struct vector-2))
    (%draw-spline-linear pointer (length points) thick color)))

(cffi:defcfun ("DrawSplineBasis" %draw-spline-basis) :void
  (points :pointer) (point-count :int) (thick :float) (color (:struct rgba)))

(defun draw-spline-basis (points thick color)
  (with-point-array (pointer points (:struct vector-2))
    (%draw-spline-basis pointer (length points) thick color)))

(cffi:defcfun ("DrawSplineCatmullRom" %draw-spline-catmull-rom) :void
  (points :pointer) (point-count :int) (thick :float) (color (:struct rgba)))

(defun draw-spline-catmull-rom (points thick color)
  (with-point-array (pointer points (:struct vector-2))
    (%draw-spline-catmull-rom pointer (length points) thick color)))

(cffi:defcfun ("DrawSplineBezierQuadratic" %draw-spline-bezier-quadratic) :void
  (points :pointer) (point-count :int) (thick :float) (color (:struct rgba)))

(defun draw-spline-bezier-quadratic (points thick color)
  (with-point-array (pointer points (:struct vector-2))
    (%draw-spline-bezier-quadratic pointer (length points) thick color)))

(cffi:defcfun ("DrawSplineBezierCubic" %draw-spline-bezier-cubic) :void
  (points :pointer) (point-count :int) (thick :float) (color (:struct rgba)))

(defun draw-spline-bezier-cubic (points thick color)
  (with-point-array (pointer points (:struct vector-2))
    (%draw-spline-bezier-cubic pointer (length points) thick color)))

(cffi:defcfun ("DrawSplineSegmentLinear" draw-spline-segment-linear) :void
  (p1 (:struct vector-2)) (p2 (:struct vector-2)) (thick :float) (color (:struct rgba)))

;; raylib 6.2 normalizes a zero-length step at t = 0 in these two C
;; routines. The next iteration replaces that pair of vertices. Give only
;; the native call the non-trapping arithmetic it expects.
(defmacro with-native-geometry (traps &body body)
  #-sbcl (declare (ignore traps))
  #+sbcl `(sb-int:with-float-traps-masked ,traps ,@body)
  #-sbcl `(progn ,@body))

(cffi:defcfun ("DrawSplineSegmentBasis" %draw-spline-segment-basis) :void
  (p1 (:struct vector-2))
  (p2 (:struct vector-2))
  (p3 (:struct vector-2))
  (p4 (:struct vector-2))
  (thick :float)
  (color (:struct rgba)))

(defun draw-spline-segment-basis (p1 p2 p3 p4 thick color)
  (with-native-geometry (:divide-by-zero :invalid)
    (%draw-spline-segment-basis p1 p2 p3 p4 thick color)))

(cffi:defcfun ("DrawSplineSegmentCatmullRom" %draw-spline-segment-catmull-rom) :void
  (p1 (:struct vector-2))
  (p2 (:struct vector-2))
  (p3 (:struct vector-2))
  (p4 (:struct vector-2))
  (thick :float)
  (color (:struct rgba)))

(defun draw-spline-segment-catmull-rom (p1 p2 p3 p4 thick color)
  (with-native-geometry (:divide-by-zero :invalid)
    (%draw-spline-segment-catmull-rom p1 p2 p3 p4 thick color)))

(cffi:defcfun ("DrawSplineSegmentBezierQuadratic" draw-spline-segment-bezier-quadratic) :void
  (p1 (:struct vector-2))
  (c2 (:struct vector-2))
  (p3 (:struct vector-2))
  (thick :float)
  (color (:struct rgba)))

(cffi:defcfun ("DrawSplineSegmentBezierCubic" draw-spline-segment-bezier-cubic) :void
  (p1 (:struct vector-2))
  (c2 (:struct vector-2))
  (c3 (:struct vector-2))
  (p4 (:struct vector-2))
  (thick :float)
  (color (:struct rgba)))

(cffi:defcfun ("DrawLine3D" draw-line-3d) :void
  (start-pos (:struct vector-3)) (end-pos (:struct vector-3)) (color (:struct rgba)))

(cffi:defcfun ("DrawPoint3D" draw-point-3d) :void
  (position (:struct vector-3)) (color (:struct rgba)))

(cffi:defcfun ("DrawCircle3D" draw-circle-3d) :void
  (center (:struct vector-3))
  (radius :float)
  (rotation-axis (:struct vector-3))
  (rotation-angle :float)
  (color (:struct rgba)))

(cffi:defcfun ("DrawTriangle3D" draw-triangle-3d) :void
  (v1 (:struct vector-3)) (v2 (:struct vector-3)) (v3 (:struct vector-3)) (color (:struct rgba)))

(cffi:defcfun ("DrawTriangleStrip3D" %draw-triangle-strip-3d) :void
  (points :pointer) (point-count :int) (color (:struct rgba)))

(defun draw-triangle-strip-3d (points color)
  (with-point-array (pointer points (:struct vector-3))
    (%draw-triangle-strip-3d pointer (length points) color)))

(cffi:defcfun ("DrawCubeV" draw-cube-v) :void
  (position (:struct vector-3)) (size (:struct vector-3)) (color (:struct rgba)))

(cffi:defcfun ("DrawCubeWires" draw-cube-wires) :void
  (position (:struct vector-3))
  (width :float)
  (height :float)
  (length :float)
  (color (:struct rgba)))

(cffi:defcfun ("DrawCubeWiresV" draw-cube-wires-v) :void
  (position (:struct vector-3)) (size (:struct vector-3)) (color (:struct rgba)))

(cffi:defcfun ("DrawSphereEx" draw-sphere-ex) :void
  (center-pos (:struct vector-3))
  (radius :float)
  (rings :int)
  (slices :int)
  (color (:struct rgba)))

(cffi:defcfun ("DrawSphereWires" draw-sphere-wires) :void
  (center-pos (:struct vector-3))
  (radius :float)
  (rings :int)
  (slices :int)
  (color (:struct rgba)))

(cffi:defcfun ("DrawCylinderEx" draw-cylinder-ex) :void
  (start-pos (:struct vector-3))
  (end-pos (:struct vector-3))
  (start-radius :float)
  (end-radius :float)
  (sides :int)
  (color (:struct rgba)))

(cffi:defcfun ("DrawCylinderWires" draw-cylinder-wires) :void
  (position (:struct vector-3))
  (radius-top :float)
  (radius-bottom :float)
  (height :float)
  (sides :int)
  (color (:struct rgba)))

(cffi:defcfun ("DrawCylinderWiresEx" draw-cylinder-wires-ex) :void
  (start-pos (:struct vector-3))
  (end-pos (:struct vector-3))
  (start-radius :float)
  (end-radius :float)
  (sides :int)
  (color (:struct rgba)))

(cffi:defcfun ("DrawCapsule" draw-capsule) :void
  (start-pos (:struct vector-3))
  (end-pos (:struct vector-3))
  (radius :float)
  (rings :int)
  (slices :int)
  (color (:struct rgba)))

(cffi:defcfun ("DrawCapsuleWires" draw-capsule-wires) :void
  (start-pos (:struct vector-3))
  (end-pos (:struct vector-3))
  (radius :float)
  (rings :int)
  (slices :int)
  (color (:struct rgba)))

(cffi:defcfun ("DrawPlane" draw-plane) :void
  (center-pos (:struct vector-3)) (size (:struct vector-2)) (color (:struct rgba)))

(cffi:defcfun ("DrawRay" draw-ray) :void (ray (:struct ray)) (color (:struct rgba)))

(cffi:defcfun ("DrawBoundingBox" draw-bounding-box) :void
  (box (:struct bounding-box)) (color (:struct rgba)))

;;; 2D shapes and collisions

;; Set texture and rectangle to be used on shapes drawing
(cffi:defcfun ("SetShapesTexture" set-shapes-texture) :void
  (texture (:struct texture)) (rec (:struct rectangle)))

;; Get texture that is used for shapes drawing
(cffi:defcfun ("GetShapesTexture" get-shapes-texture) (:struct texture))

;; Get texture source rectangle that is used for shapes drawing
(cffi:defcfun ("GetShapesTextureRectangle" get-shapes-texture-rectangle) (:struct rectangle))

;; Get (evaluate) spline point: Linear
(cffi:defcfun ("GetSplinePointLinear" get-spline-point-linear) (:struct vector-2)
  (start-pos (:struct vector-2)) (end-pos (:struct vector-2)) (amount :float))

;; Get (evaluate) spline point: B-Spline
(cffi:defcfun ("GetSplinePointBasis" get-spline-point-basis) (:struct vector-2)
  (p1 (:struct vector-2))
  (p2 (:struct vector-2))
  (p3 (:struct vector-2))
  (p4 (:struct vector-2))
  (amount :float))

;; Get (evaluate) spline point: Catmull-Rom
(cffi:defcfun ("GetSplinePointCatmullRom" get-spline-point-catmull-rom) (:struct vector-2)
  (p1 (:struct vector-2))
  (p2 (:struct vector-2))
  (p3 (:struct vector-2))
  (p4 (:struct vector-2))
  (amount :float))

;; Get (evaluate) spline point: Quadratic Bezier
(cffi:defcfun ("GetSplinePointBezierQuadratic" get-spline-point-bezier-quadratic) (:struct vector-2)
  (p1 (:struct vector-2)) (c2 (:struct vector-2)) (p3 (:struct vector-2)) (amount :float))

;; Get (evaluate) spline point: Cubic Bezier
(cffi:defcfun ("GetSplinePointBezierCubic" get-spline-point-bezier-cubic) (:struct vector-2)
  (p1 (:struct vector-2))
  (c2 (:struct vector-2))
  (c3 (:struct vector-2))
  (p4 (:struct vector-2))
  (amount :float))

;; Check collision between two rectangles
(cffi:defcfun ("CheckCollisionRecs" %check-collision-recs) :unsigned-char
  (rec1 (:struct rectangle)) (rec2 (:struct rectangle)))

(defun check-collision-recs (rec1 rec2)
  (not (zerop (%check-collision-recs rec1 rec2))))

;; Check collision between two circles
(cffi:defcfun ("CheckCollisionCircles" %check-collision-circles) :unsigned-char
  (center1 (:struct vector-2)) (radius1 :float) (center2 (:struct vector-2)) (radius2 :float))

(defun check-collision-circles (center1 radius1 center2 radius2)
  (not (zerop (%check-collision-circles center1 radius1 center2 radius2))))

;; Check collision between circle and rectangle
(cffi:defcfun ("CheckCollisionCircleRec" %check-collision-circle-rec) :unsigned-char
  (center (:struct vector-2)) (radius :float) (rec (:struct rectangle)))

(defun check-collision-circle-rec (center radius rec)
  (not (zerop (%check-collision-circle-rec center radius rec))))

;; Check if circle collides with a line created between two points [p1] and [p2]
(cffi:defcfun ("CheckCollisionCircleLine" %check-collision-circle-line) :unsigned-char
  (center (:struct vector-2)) (radius :float) (p1 (:struct vector-2)) (p2 (:struct vector-2)))

(defun check-collision-circle-line (center radius p1 p2)
  (not (zerop (%check-collision-circle-line center radius p1 p2))))

;; Check if point is inside rectangle
(cffi:defcfun ("CheckCollisionPointRec" %check-collision-point-rec) :unsigned-char
  (point (:struct vector-2)) (rec (:struct rectangle)))

(defun check-collision-point-rec (point rec)
  (not (zerop (%check-collision-point-rec point rec))))

;; Check if point is inside circle
(cffi:defcfun ("CheckCollisionPointCircle" %check-collision-point-circle) :unsigned-char
  (point (:struct vector-2)) (center (:struct vector-2)) (radius :float))

(defun check-collision-point-circle (point center radius)
  (not (zerop (%check-collision-point-circle point center radius))))

;; Check if point is inside a triangle
(cffi:defcfun ("CheckCollisionPointTriangle" %check-collision-point-triangle) :unsigned-char
  (point (:struct vector-2))
  (p1 (:struct vector-2))
  (p2 (:struct vector-2))
  (p3 (:struct vector-2)))

(defun check-collision-point-triangle (point p1 p2 p3)
  (not (zerop (%check-collision-point-triangle point p1 p2 p3))))

;; Check if point belongs to line created between two points [p1] and [p2] with defined margin in pixels [threshold]
(cffi:defcfun ("CheckCollisionPointLine" %check-collision-point-line) :unsigned-char
  (point (:struct vector-2)) (p1 (:struct vector-2)) (p2 (:struct vector-2)) (threshold :int))

(defun check-collision-point-line (point p1 p2 threshold)
  (not (zerop (%check-collision-point-line point p1 p2 threshold))))

;; Check if point is within a polygon described by array of vertices
(cffi:defcfun ("CheckCollisionPointPoly" %check-collision-point-poly) :unsigned-char
  (point (:struct vector-2)) (points :pointer) (point-count :int))

(defun check-collision-point-poly (point points point-count)
  (not (zerop (%check-collision-point-poly point points point-count))))

;; Check the collision between two lines defined by two points each, returns collision point by reference
(cffi:defcfun ("CheckCollisionLines" %check-collision-lines) :unsigned-char
  (start-pos1 (:struct vector-2))
  (end-pos1 (:struct vector-2))
  (start-pos2 (:struct vector-2))
  (end-pos2 (:struct vector-2))
  (collision-point :pointer))

(defun check-collision-lines (start-pos1 end-pos1 start-pos2 end-pos2 collision-point)
  (not (zerop (%check-collision-lines start-pos1 end-pos1 start-pos2 end-pos2 collision-point))))

;; Get collision rectangle for two rectangles collision
(cffi:defcfun ("GetCollisionRec" get-collision-rec) (:struct rectangle)
  (rec1 (:struct rectangle)) (rec2 (:struct rectangle)))

;;; Images, textures and colors

;; Load image from file into CPU memory (RAM)
(cffi:defcfun ("LoadImage" load-image) (:struct image) (file-name :string))

;; Load image from RAW file data
(cffi:defcfun ("LoadImageRaw" load-image-raw) (:struct image)
  (file-name :string) (width :int) (height :int) (format pixel-format) (header-size :int))

;; Load image sequence from file (frames appended to image.data)
(cffi:defcfun ("LoadImageAnim" load-image-anim) (:struct image)
  (file-name :string) (frames :pointer))

;; Load image sequence from memory buffer
(cffi:defcfun ("LoadImageAnimFromMemory" load-image-anim-from-memory) (:struct image)
  (file-type :string) (file-data :pointer) (data-size :int) (frames :pointer))

;; Load image from memory buffer, fileType refers to extension: i.e. '.png'
(cffi:defcfun ("LoadImageFromMemory" load-image-from-memory) (:struct image)
  (file-type :string) (file-data :pointer) (data-size :int))

;; Load image from GPU texture data
(cffi:defcfun ("LoadImageFromTexture" load-image-from-texture) (:struct image)
  (texture (:struct texture)))

;; Load image from screen buffer (screenshot)
(cffi:defcfun ("LoadImageFromScreen" load-image-from-screen) (:struct image))

;; Check if an image is valid (data and parameters)
(cffi:defcfun ("IsImageValid" %is-image-valid) :uint8 (image (:struct image)))

(defun is-image-valid (image)
  (not (zerop (%is-image-valid image))))

;; Unload image from CPU memory (RAM)
(cffi:defcfun ("UnloadImage" unload-image) :void (image (:struct image)))

;; Export image data to file, returns true on success
(cffi:defcfun ("ExportImage" %export-image) :uint8 (image (:struct image)) (file-name :string))

(defun export-image (image file-name)
  (not (zerop (%export-image image file-name))))

;; Export image to memory buffer, memory must be MemFree()
(cffi:defcfun ("ExportImageToMemory" export-image-to-memory) :pointer
  (image (:struct image)) (file-type :string) (file-size :pointer))

;; Export image as code file defining an array of bytes, returns true on success
(cffi:defcfun ("ExportImageAsCode" %export-image-as-code) :uint8
  (image (:struct image)) (file-name :string))

(defun export-image-as-code (image file-name)
  (not (zerop (%export-image-as-code image file-name))))

;; Generate image: plain color
(cffi:defcfun ("GenImageColor" gen-image-color) (:struct image)
  (width :int) (height :int) (color (:struct rgba)))

;; Generate image: linear gradient, direction in degrees [0..360], 0=Vertical gradient
(cffi:defcfun ("GenImageGradientLinear" gen-image-gradient-linear) (:struct image)
  (width :int) (height :int) (direction :int) (start (:struct rgba)) (end (:struct rgba)))

;; Generate image: radial gradient
(cffi:defcfun ("GenImageGradientRadial" gen-image-gradient-radial) (:struct image)
  (width :int) (height :int) (density :float) (inner (:struct rgba)) (outer (:struct rgba)))

;; Generate image: square gradient
(cffi:defcfun ("GenImageGradientSquare" gen-image-gradient-square) (:struct image)
  (width :int) (height :int) (density :float) (inner (:struct rgba)) (outer (:struct rgba)))

;; Generate image: checked
(cffi:defcfun ("GenImageChecked" gen-image-checked) (:struct image)
  (width :int)
  (height :int)
  (checks-x :int)
  (checks-y :int)
  (col1 (:struct rgba))
  (col2 (:struct rgba)))

;; Generate image: white noise
(cffi:defcfun ("GenImageWhiteNoise" gen-image-white-noise) (:struct image)
  (width :int) (height :int) (factor :float))

;; Generate image: perlin noise
(cffi:defcfun ("GenImagePerlinNoise" gen-image-perlin-noise) (:struct image)
  (width :int) (height :int) (offset-x :int) (offset-y :int) (scale :float))

;; Generate image: cellular algorithm, bigger tileSize means bigger cells
(cffi:defcfun ("GenImageCellular" gen-image-cellular) (:struct image)
  (width :int) (height :int) (tile-size :int))

;; Generate image: grayscale image from text data
(cffi:defcfun ("GenImageText" gen-image-text) (:struct image)
  (width :int) (height :int) (text :string))

;; Create an image duplicate (useful for transformations)
(cffi:defcfun ("ImageCopy" image-copy) (:struct image) (image (:struct image)))

;; Create an image from another image piece
(cffi:defcfun ("ImageFromImage" image-from-image) (:struct image)
  (image (:struct image)) (rec (:struct rectangle)))

;; Create an image from a selected channel of another image (GRAYSCALE)
(cffi:defcfun ("ImageFromChannel" image-from-channel) (:struct image)
  (image (:struct image)) (selected-channel :int))

;; Create an image from text (default font)
(cffi:defcfun ("ImageText" image-text) (:struct image)
  (text :string) (font-size :int) (color (:struct rgba)))

;; Create an image from text (custom sprite font)
(cffi:defcfun ("ImageTextEx" image-text-ex) (:struct image)
  (font (:struct font)) (text :string) (font-size :float) (spacing :float) (tint (:struct rgba)))

;; Convert image data to desired format
(cffi:defcfun ("ImageFormat" image-format) :void (image :pointer) (new-format pixel-format))

;; Convert image to POT (power-of-two)
(cffi:defcfun ("ImageToPOT" image-to-pot) :void (image :pointer) (fill (:struct rgba)))

;; Crop an image to a defined rectangle
(cffi:defcfun ("ImageCrop" image-crop) :void (image :pointer) (crop (:struct rectangle)))

;; Crop image depending on alpha value
(cffi:defcfun ("ImageAlphaCrop" image-alpha-crop) :void (image :pointer) (threshold :float))

;; Clear alpha channel to desired color
(cffi:defcfun ("ImageAlphaClear" image-alpha-clear) :void
  (image :pointer) (color (:struct rgba)) (threshold :float))

;; Apply alpha mask to image
(cffi:defcfun ("ImageAlphaMask" image-alpha-mask) :void
  (image :pointer) (alpha-mask (:struct image)))

;; Premultiply alpha channel
(cffi:defcfun ("ImageAlphaPremultiply" image-alpha-premultiply) :void (image :pointer))

;; Apply Gaussian blur using a box blur approximation
(cffi:defcfun ("ImageBlurGaussian" image-blur-gaussian) :void (image :pointer) (blur-size :int))

;; Apply custom square convolution kernel to image
(cffi:defcfun ("ImageKernelConvolution" image-kernel-convolution) :void
  (image :pointer) (kernel :pointer) (kernel-size :int))

;; Resize image (Bicubic scaling algorithm)
(cffi:defcfun ("ImageResize" image-resize) :void
  (image :pointer) (new-width :int) (new-height :int))

;; Resize image (Nearest-Neighbor scaling algorithm)
(cffi:defcfun ("ImageResizeNN" image-resize-nn) :void
  (image :pointer) (new-width :int) (new-height :int))

;; Resize canvas and fill with color
(cffi:defcfun ("ImageResizeCanvas" image-resize-canvas) :void
  (image :pointer)
  (new-width :int)
  (new-height :int)
  (offset-x :int)
  (offset-y :int)
  (fill (:struct rgba)))

;; Compute all mipmap levels for a provided image
(cffi:defcfun ("ImageMipmaps" image-mipmaps) :void (image :pointer))

;; Dither image data to 16bpp or lower (Floyd-Steinberg dithering)
(cffi:defcfun ("ImageDither" image-dither) :void
  (image :pointer) (r-bpp :int) (g-bpp :int) (b-bpp :int) (a-bpp :int))

;; Flip image vertically
(cffi:defcfun ("ImageFlipVertical" image-flip-vertical) :void (image :pointer))

;; Flip image horizontally
(cffi:defcfun ("ImageFlipHorizontal" image-flip-horizontal) :void (image :pointer))

;; Rotate image by input angle in degrees (-359 to 359)
(cffi:defcfun ("ImageRotate" image-rotate) :void (image :pointer) (degrees :int))

;; Rotate image clockwise 90deg
(cffi:defcfun ("ImageRotateCW" image-rotate-cw) :void (image :pointer))

;; Rotate image counter-clockwise 90deg
(cffi:defcfun ("ImageRotateCCW" image-rotate-ccw) :void (image :pointer))

;; Modify image color: tint
(cffi:defcfun ("ImageColorTint" image-color-tint) :void (image :pointer) (color (:struct rgba)))

;; Modify image color: invert
(cffi:defcfun ("ImageColorInvert" image-color-invert) :void (image :pointer))

;; Modify image color: grayscale
(cffi:defcfun ("ImageColorGrayscale" image-color-grayscale) :void (image :pointer))

;; Modify image color: contrast (-100 to 100)
(cffi:defcfun ("ImageColorContrast" image-color-contrast) :void (image :pointer) (contrast :int))

;; Modify image color: brightness (-255 to 255)
(cffi:defcfun ("ImageColorBrightness" image-color-brightness) :void
  (image :pointer) (brightness :int))

;; Modify image color: replace color
(cffi:defcfun ("ImageColorReplace" image-color-replace) :void
  (image :pointer) (color (:struct rgba)) (replace (:struct rgba)))

;; Load color data from image as a Color array (RGBA - 32bit)
(cffi:defcfun ("LoadImageColors" load-image-colors) :pointer (image (:struct image)))

;; Load colors palette from image as a Color array (RGBA - 32bit)
(cffi:defcfun ("LoadImagePalette" load-image-palette) :pointer
  (image (:struct image)) (max-palette-size :int) (color-count :pointer))

;; Unload color data loaded with LoadImageColors()
(cffi:defcfun ("UnloadImageColors" unload-image-colors) :void (colors :pointer))

;; Unload colors palette loaded with LoadImagePalette()
(cffi:defcfun ("UnloadImagePalette" unload-image-palette) :void (colors :pointer))

;; Get image alpha border rectangle
(cffi:defcfun ("GetImageAlphaBorder" get-image-alpha-border) (:struct rectangle)
  (image (:struct image)) (threshold :float))

;; Get image pixel color at (x, y) position
(cffi:defcfun ("GetImageColor" get-image-color) (:struct rgba)
  (image (:struct image)) (x :int) (y :int))

;; Clear image background with provided color
(cffi:defcfun ("ImageClearBackground" image-clear-background) :void
  (dst :pointer) (color (:struct rgba)))

;; Draw pixel within an image
(cffi:defcfun ("ImageDrawPixel" image-draw-pixel) :void
  (dst :pointer) (pos-x :int) (pos-y :int) (color (:struct rgba)))

;; Draw pixel within an image (Vector version)
(cffi:defcfun ("ImageDrawPixelV" image-draw-pixel-v) :void
  (dst :pointer) (position (:struct vector-2)) (color (:struct rgba)))

;; Draw line within an image
(cffi:defcfun ("ImageDrawLine" image-draw-line) :void
  (dst :pointer)
  (start-pos-x :int)
  (start-pos-y :int)
  (end-pos-x :int)
  (end-pos-y :int)
  (color (:struct rgba)))

;; Draw line within an image (Vector version)
(cffi:defcfun ("ImageDrawLineV" image-draw-line-v) :void
  (dst :pointer) (start (:struct vector-2)) (end (:struct vector-2)) (color (:struct rgba)))

;; Draw a line defining thickness within an image
(cffi:defcfun ("ImageDrawLineEx" image-draw-line-ex) :void
  (dst :pointer)
  (start (:struct vector-2))
  (end (:struct vector-2))
  (thick :int)
  (color (:struct rgba)))

;; Draw a lines sequence within an image
(cffi:defcfun ("ImageDrawLineStrip" image-draw-line-strip) :void
  (dst :pointer) (points :pointer) (point-count :int) (color (:struct rgba)))

;; Draw triangle within an image
(cffi:defcfun ("ImageDrawTriangle" image-draw-triangle) :void
  (dst :pointer)
  (v1 (:struct vector-2))
  (v2 (:struct vector-2))
  (v3 (:struct vector-2))
  (color (:struct rgba)))

;; Draw triangle with interpolated colors within an image
(cffi:defcfun ("ImageDrawTriangleGradient" image-draw-triangle-gradient) :void
  (dst :pointer)
  (v1 (:struct vector-2))
  (v2 (:struct vector-2))
  (v3 (:struct vector-2))
  (c1 (:struct rgba))
  (c2 (:struct rgba))
  (c3 (:struct rgba)))

;; Draw triangle outline within an image
(cffi:defcfun ("ImageDrawTriangleLines" image-draw-triangle-lines) :void
  (dst :pointer)
  (v1 (:struct vector-2))
  (v2 (:struct vector-2))
  (v3 (:struct vector-2))
  (color (:struct rgba)))

;; Draw a triangle fan defined by points within an image (first vertex is the center)
(cffi:defcfun ("ImageDrawTriangleFan" image-draw-triangle-fan) :void
  (dst :pointer) (points :pointer) (point-count :int) (color (:struct rgba)))

;; Draw a triangle strip defined by points within an image
(cffi:defcfun ("ImageDrawTriangleStrip" image-draw-triangle-strip) :void
  (dst :pointer) (points :pointer) (point-count :int) (color (:struct rgba)))

;; Draw rectangle within an image
(cffi:defcfun ("ImageDrawRectangle" image-draw-rectangle) :void
  (dst :pointer) (pos-x :int) (pos-y :int) (width :int) (height :int) (color (:struct rgba)))

;; Draw rectangle within an image (Vector version)
(cffi:defcfun ("ImageDrawRectangleV" image-draw-rectangle-v) :void
  (dst :pointer) (position (:struct vector-2)) (size (:struct vector-2)) (color (:struct rgba)))

;; Draw rectangle within an image
(cffi:defcfun ("ImageDrawRectangleRec" image-draw-rectangle-rec) :void
  (dst :pointer) (rec (:struct rectangle)) (color (:struct rgba)))

;; Draw a color-filled rectangle with pro parameters within and image
(cffi:defcfun ("ImageDrawRectanglePro" image-draw-rectangle-pro) :void
  (dst :pointer)
  (rec (:struct rectangle))
  (origin (:struct vector-2))
  (rotation :float)
  (color (:struct rgba)))

;; Draw rectangle lines within an image
(cffi:defcfun ("ImageDrawRectangleLines" image-draw-rectangle-lines) :void
  (dst :pointer) (pos-x :int) (pos-y :int) (width :int) (height :int) (color (:struct rgba)))

;; Draw rectangle lines within an image with line thickness
(cffi:defcfun ("ImageDrawRectangleLinesEx" image-draw-rectangle-lines-ex) :void
  (dst :pointer) (rec (:struct rectangle)) (thick :int) (color (:struct rgba)))

;; Draw rectangle with gradient colors within an image, counter-clockwise color order
(cffi:defcfun ("ImageDrawRectangleGradientEx" image-draw-rectangle-gradient-ex) :void
  (dst :pointer)
  (rec (:struct rectangle))
  (col1 (:struct rgba))
  (col2 (:struct rgba))
  (col3 (:struct rgba))
  (col4 (:struct rgba)))

;; Draw a filled circle within an image
(cffi:defcfun ("ImageDrawCircle" image-draw-circle) :void
  (dst :pointer) (center-x :int) (center-y :int) (radius :int) (color (:struct rgba)))

;; Draw a filled circle within an image (Vector version)
(cffi:defcfun ("ImageDrawCircleV" image-draw-circle-v) :void
  (dst :pointer) (center (:struct vector-2)) (radius :int) (color (:struct rgba)))

;; Draw circle outline within an image
(cffi:defcfun ("ImageDrawCircleLines" image-draw-circle-lines) :void
  (dst :pointer) (center-x :int) (center-y :int) (radius :int) (color (:struct rgba)))

;; Draw circle outline within an image (Vector version)
(cffi:defcfun ("ImageDrawCircleLinesV" image-draw-circle-lines-v) :void
  (dst :pointer) (center (:struct vector-2)) (radius :int) (color (:struct rgba)))

;; Draw a gradient-filled circle within an image
(cffi:defcfun ("ImageDrawCircleGradient" image-draw-circle-gradient) :void
  (dst :pointer)
  (center (:struct vector-2))
  (radius :float)
  (inner (:struct rgba))
  (outer (:struct rgba)))

;; Draw an image within an image
(cffi:defcfun ("ImageDrawImage" image-draw-image) :void
  (dst :pointer) (src (:struct image)) (pos-x :int) (pos-y :int) (tint (:struct rgba)))

;; Draw an image with scaling and rotation within an image
(cffi:defcfun ("ImageDrawImageEx" image-draw-image-ex) :void
  (dst :pointer)
  (src (:struct image))
  (position (:struct vector-2))
  (rotation :float)
  (scale :float)
  (tint (:struct rgba)))

;; Draw a part of an image defined by a rectangle within an image
(cffi:defcfun ("ImageDrawImageRec" image-draw-image-rec) :void
  (dst :pointer)
  (src (:struct image))
  (src-rec (:struct rectangle))
  (position (:struct vector-2))
  (tint (:struct rgba)))

;; Draw a part of an image defined by a rectangle into destination rectangle, with scaling and rotation, within an image
(cffi:defcfun ("ImageDrawImagePro" image-draw-image-pro) :void
  (dst :pointer)
  (src (:struct image))
  (src-rec (:struct rectangle))
  (dst-rec (:struct rectangle))
  (origin (:struct vector-2))
  (rotation :float)
  (tint (:struct rgba)))

;; Draw text (using default font) within an image (destination)
(cffi:defcfun ("ImageDrawText" image-draw-text) :void
  (dst :pointer) (text :string) (pos-x :int) (pos-y :int) (font-size :int) (color (:struct rgba)))

;; Draw text (custom sprite font) within an image (destination)
(cffi:defcfun ("ImageDrawTextEx" image-draw-text-ex) :void
  (dst :pointer)
  (font (:struct font))
  (text :string)
  (position (:struct vector-2))
  (font-size :float)
  (spacing :float)
  (tint (:struct rgba)))

;; Draw text using Font and pro parameters (rotation)
(cffi:defcfun ("ImageDrawTextPro" image-draw-text-pro) :void
  (dst :pointer)
  (font (:struct font))
  (text :string)
  (position (:struct vector-2))
  (origin (:struct vector-2))
  (rotation :float)
  (font-size :float)
  (spacing :float)
  (tint (:struct rgba)))

;; Load texture from file into GPU memory (VRAM)
(cffi:defcfun ("LoadTexture" load-texture) (:struct texture) (file-name :string))

;; Load texture from image data
(cffi:defcfun ("LoadTextureFromImage" load-texture-from-image) (:struct texture)
  (image (:struct image)))

;; Load cubemap from image, multiple image cubemap layouts supported
(cffi:defcfun ("LoadTextureCubemap" load-texture-cubemap) (:struct texture)
  (image (:struct image)) (layout cubemap-layout))

;; Load texture for rendering (framebuffer)
(cffi:defcfun ("LoadRenderTexture" load-render-texture) (:struct render-texture)
  (width :int) (height :int))

;; Load texture for rendering (framebuffer), with specific format
(cffi:defcfun ("LoadRenderTextureEx" load-render-texture-ex) (:struct render-texture)
  (width :int) (height :int) (format pixel-format))

;; Check if texture is valid (loaded in GPU)
(cffi:defcfun ("IsTextureValid" %is-texture-valid) :uint8 (texture (:struct texture)))

(defun is-texture-valid (texture)
  (not (zerop (%is-texture-valid texture))))

;; Unload texture from GPU memory (VRAM)
(cffi:defcfun ("UnloadTexture" unload-texture) :void (texture (:struct texture)))

;; Check if render texture is valid (loaded in GPU)
(cffi:defcfun ("IsRenderTextureValid" %is-render-texture-valid) :uint8
  (target (:struct render-texture)))

(defun is-render-texture-valid (target)
  (not (zerop (%is-render-texture-valid target))))

;; Unload render texture from GPU memory (VRAM)
(cffi:defcfun ("UnloadRenderTexture" unload-render-texture) :void (target (:struct render-texture)))

;; Update GPU texture with new data (pixels should be able to fill texture)
(cffi:defcfun ("UpdateTexture" update-texture) :void (texture (:struct texture)) (pixels :pointer))

;; Update GPU texture rectangle with new data (pixels and rec should fit in texture)
(cffi:defcfun ("UpdateTextureRec" update-texture-rec) :void
  (texture (:struct texture)) (rec (:struct rectangle)) (pixels :pointer))

;; Generate GPU mipmaps for a texture
(cffi:defcfun ("GenTextureMipmaps" gen-texture-mipmaps) :void (texture :pointer))

;; Set texture scaling filter mode
(cffi:defcfun ("SetTextureFilter" set-texture-filter) :void
  (texture (:struct texture)) (filter texture-filter))

;; Set texture wrapping mode
(cffi:defcfun ("SetTextureWrap" set-texture-wrap) :void
  (texture (:struct texture)) (wrap texture-wrap))

;; Draw a Texture2D
(cffi:defcfun ("DrawTexture" draw-texture) :void
  (texture (:struct texture)) (pos-x :int) (pos-y :int) (tint (:struct rgba)))

;; Draw a Texture2D with position defined as Vector2
(cffi:defcfun ("DrawTextureV" draw-texture-v) :void
  (texture (:struct texture)) (position (:struct vector-2)) (tint (:struct rgba)))

;; Draw a Texture2D with rotation and scale
(cffi:defcfun ("DrawTextureEx" draw-texture-ex) :void
  (texture (:struct texture))
  (position (:struct vector-2))
  (rotation :float)
  (scale :float)
  (tint (:struct rgba)))

;; Draw a part of a texture defined by a rectangle
(cffi:defcfun ("DrawTextureRec" draw-texture-rec) :void
  (texture (:struct texture))
  (rec (:struct rectangle))
  (position (:struct vector-2))
  (tint (:struct rgba)))

;; Draw a part of a texture defined by a source rectangle to destination rectangle, with scaling and rotation
(cffi:defcfun ("DrawTexturePro" draw-texture-pro) :void
  (texture (:struct texture))
  (srcrec (:struct rectangle))
  (dstrec (:struct rectangle))
  (origin (:struct vector-2))
  (rotation :float)
  (tint (:struct rgba)))

;; Draw a texture (or part of it) that stretches or shrinks nicely
(cffi:defcfun ("DrawTextureNPatch" draw-texture-n-patch) :void
  (texture (:struct texture))
  (n-patch-info (:struct n-patch-info))
  (dstrec (:struct rectangle))
  (origin (:struct vector-2))
  (rotation :float)
  (tint (:struct rgba)))

;; Check if two colors are equal
(cffi:defcfun ("ColorIsEqual" %color-is-equal) :uint8 (col1 (:struct rgba)) (col2 (:struct rgba)))

(defun color-is-equal (col1 col2)
  (not (zerop (%color-is-equal col1 col2))))

;; Get color with alpha applied, alpha goes from 0.0f to 1.0f
(cffi:defcfun ("Fade" fade) (:struct rgba) (color (:struct rgba)) (alpha :float))

;; Get hexadecimal value for a Color (0xRRGGBBAA)
(cffi:defcfun ("ColorToInt" color-to-int) :int (color (:struct rgba)))

;; Get Color normalized as float [0..1]
(cffi:defcfun ("ColorNormalize" color-normalize) (:struct vector-4) (color (:struct rgba)))

;; Get Color from normalized values [0..1]
(cffi:defcfun ("ColorFromNormalized" color-from-normalized) (:struct rgba)
  (normalized (:struct vector-4)))

;; Get HSV values for a Color, hue [0..360], saturation/value [0..1]
(cffi:defcfun ("ColorToHSV" color-to-hsv) (:struct vector-3) (color (:struct rgba)))

;; Get a Color from HSV values, hue [0..360], saturation/value [0..1]
(cffi:defcfun ("ColorFromHSV" color-from-hsv) (:struct rgba)
  (hue :float) (saturation :float) (value :float))

;; Get color multiplied with another color
(cffi:defcfun ("ColorTint" color-tint) (:struct rgba) (color (:struct rgba)) (tint (:struct rgba)))

;; Get color with brightness correction, brightness factor goes from -1.0f to 1.0f
(cffi:defcfun ("ColorBrightness" color-brightness) (:struct rgba)
  (color (:struct rgba)) (factor :float))

;; Get color with contrast correction, contrast values between -1.0f and 1.0f
(cffi:defcfun ("ColorContrast" color-contrast) (:struct rgba)
  (color (:struct rgba)) (contrast :float))

;; Get color with alpha applied, alpha goes from 0.0f to 1.0f
(cffi:defcfun ("ColorAlpha" color-alpha) (:struct rgba) (color (:struct rgba)) (alpha :float))

;; Get src alpha-blended into dst color with tint
(cffi:defcfun ("ColorAlphaBlend" color-alpha-blend) (:struct rgba)
  (dst (:struct rgba)) (src (:struct rgba)) (tint (:struct rgba)))

;; Get color lerp interpolation between two colors, factor [0.0f..1.0f]
(cffi:defcfun ("ColorLerp" color-lerp) (:struct rgba)
  (color1 (:struct rgba)) (color2 (:struct rgba)) (factor :float))

;; Get Color structure from hexadecimal value
(cffi:defcfun ("GetColor" get-color) (:struct rgba) (hex-value :unsigned-int))

;; Get Color from a source pixel pointer of certain format
(cffi:defcfun ("GetPixelColor" get-pixel-color) (:struct rgba)
  (src-ptr :pointer) (format pixel-format))

;; Set color formatted into destination pixel pointer
(cffi:defcfun ("SetPixelColor" set-pixel-color) :void
  (dst-ptr :pointer) (color (:struct rgba)) (format pixel-format))

;; Get pixel data size in bytes for certain format
(cffi:defcfun ("GetPixelDataSize" get-pixel-data-size) :int
  (width :int) (height :int) (format pixel-format))

;;; Fonts and text

;; Get the default Font
(cffi:defcfun ("GetFontDefault" get-font-default) (:struct font))

;; Load font from file into GPU memory (VRAM)
(cffi:defcfun ("LoadFont" load-font) (:struct font) (file-name :string))

;; Load font from file with defined codepoints and generation size, use NULL for codepoints and 0 for codepointCount to load the default character set, font size is provided in pixels height
(cffi:defcfun ("LoadFontEx" load-font-ex) (:struct font)
  (file-name :string) (font-size :int) (codepoints :pointer) (codepoint-count :int))

;; Load font from Image (XNA style)
(cffi:defcfun ("LoadFontFromImage" load-font-from-image) (:struct font)
  (image (:struct image)) (key (:struct rgba)) (first-char :int))

;; Load font from memory buffer, fileType refers to extension: i.e. '.ttf'
(cffi:defcfun ("LoadFontFromMemory" load-font-from-memory) (:struct font)
  (file-type :string)
  (file-data :pointer)
  (data-size :int)
  (font-size :int)
  (codepoints :pointer)
  (codepoint-count :int))

;; Check if font is valid (font data loaded, WARNING: GPU texture not checked)
(cffi:defcfun ("IsFontValid" %is-font-valid) :unsigned-char (font (:struct font)))

(defun is-font-valid (font)
  (not (zerop (%is-font-valid font))))

;; Load font data for further use
(cffi:defcfun ("LoadFontData" load-font-data) :pointer
  (file-data :pointer)
  (data-size :int)
  (font-size :int)
  (codepoints :pointer)
  (codepoint-count :int)
  (type font-type)
  (glyph-count :pointer))

;; Generate image font atlas using chars info
(cffi:defcfun ("GenImageFontAtlas" gen-image-font-atlas) (:struct image)
  (glyphs :pointer)
  (glyph-recs :pointer)
  (glyph-count :int)
  (font-size :int)
  (padding :int)
  (pack-method :int))

;; Unload font chars info data (RAM)
(cffi:defcfun ("UnloadFontData" unload-font-data) :void (glyphs :pointer) (glyph-count :int))

;; Unload font from GPU memory (VRAM)
(cffi:defcfun ("UnloadFont" unload-font) :void (font (:struct font)))

;; Export font as code file, returns true on success
(cffi:defcfun ("ExportFontAsCode" %export-font-as-code) :unsigned-char
  (font (:struct font)) (file-name :string))

(defun export-font-as-code (font file-name)
  (not (zerop (%export-font-as-code font file-name))))

;; Draw current FPS
(cffi:defcfun ("DrawFPS" draw-fps) :void (pos-x :int) (pos-y :int))

;; Draw text using font and additional parameters
(cffi:defcfun ("DrawTextEx" draw-text-ex) :void
  (font (:struct font))
  (text :string)
  (position (:struct vector-2))
  (font-size :float)
  (spacing :float)
  (tint (:struct rgba)))

;; Draw text using Font and pro parameters (rotation)
(cffi:defcfun ("DrawTextPro" draw-text-pro) :void
  (font (:struct font))
  (text :string)
  (position (:struct vector-2))
  (origin (:struct vector-2))
  (rotation :float)
  (font-size :float)
  (spacing :float)
  (tint (:struct rgba)))

;; Draw one character (codepoint)
(cffi:defcfun ("DrawTextCodepoint" draw-text-codepoint) :void
  (font (:struct font))
  (codepoint :int)
  (position (:struct vector-2))
  (font-size :float)
  (tint (:struct rgba)))

;; Draw multiple characters (codepoint)
(cffi:defcfun ("DrawTextCodepoints" draw-text-codepoints) :void
  (font (:struct font))
  (codepoints :pointer)
  (codepoint-count :int)
  (position (:struct vector-2))
  (font-size :float)
  (spacing :float)
  (tint (:struct rgba)))

;; Set vertical line spacing when drawing with line-breaks
(cffi:defcfun ("SetTextLineSpacing" set-text-line-spacing) :void (spacing :int))

;; Measure string width for default font
(cffi:defcfun ("MeasureText" measure-text) :int (text :string) (font-size :int))

;; Measure string size for Font
(cffi:defcfun ("MeasureTextEx" measure-text-ex) (:struct vector-2)
  (font (:struct font)) (text :string) (font-size :float) (spacing :float))

;; Measure string size for an existing array of codepoints for Font
(cffi:defcfun ("MeasureTextCodepoints" measure-text-codepoints) (:struct vector-2)
  (font (:struct font)) (codepoints :pointer) (length :int) (font-size :float) (spacing :float))

;; Get glyph index position in font for a codepoint (unicode character), fallback to '?' if not found
(cffi:defcfun ("GetGlyphIndex" get-glyph-index) :int (font (:struct font)) (codepoint :int))

;; Get glyph font info data for a codepoint (unicode character), fallback to '?' if not found
(cffi:defcfun ("GetGlyphInfo" get-glyph-info) (:struct glyph-info)
  (font (:struct font)) (codepoint :int))

;; Get glyph rectangle in font atlas for a codepoint (unicode character), fallback to '?' if not found
(cffi:defcfun ("GetGlyphAtlasRec" get-glyph-atlas-rec) (:struct rectangle)
  (font (:struct font)) (codepoint :int))

;; Load UTF-8 text encoded from codepoints array
(cffi:defcfun ("LoadUTF8" load-utf8) :pointer (codepoints :pointer) (length :int))

;; Unload UTF-8 text encoded from codepoints array
(cffi:defcfun ("UnloadUTF8" unload-utf8) :void (text :pointer))

;; Load all codepoints from a UTF-8 text string, codepoints count returned by parameter
(cffi:defcfun ("LoadCodepoints" load-codepoints) :pointer (text :string) (count :pointer))

;; Unload codepoints data from memory
(cffi:defcfun ("UnloadCodepoints" unload-codepoints) :void (codepoints :pointer))

;; Get total number of codepoints in a UTF-8 encoded string
(cffi:defcfun ("GetCodepointCount" get-codepoint-count) :int (text :string))

;; Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
(cffi:defcfun ("GetCodepoint" get-codepoint) :int (text :string) (codepoint-size :pointer))

;; Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
(cffi:defcfun ("GetCodepointNext" get-codepoint-next) :int (text :string) (codepoint-size :pointer))

;; Get previous codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
(cffi:defcfun ("GetCodepointPrevious" get-codepoint-previous) :int
  (text :pointer) (codepoint-size :pointer))

;; Encode one codepoint into UTF-8 byte array (array length returned as parameter)
(cffi:defcfun ("CodepointToUTF8" codepoint-to-utf8) :pointer (codepoint :int) (utf8-size :pointer))

;; Load text as separate lines ('\n')
(cffi:defcfun ("LoadTextLines" load-text-lines) :pointer (text :string) (count :pointer))

;; Unload text lines
(cffi:defcfun ("UnloadTextLines" unload-text-lines) :void (text :pointer) (line-count :int))

;; Copy one string to another, returns bytes copied
(cffi:defcfun ("TextCopy" text-copy) :int (dst :pointer) (src :string))

;; Check if two text strings are equal
(cffi:defcfun ("TextIsEqual" text-is-equal) (:boolean :uint8) (text1 :string) (text2 :string))

;; Get text length, checks for '\0' ending
(cffi:defcfun ("TextLength" text-length) :unsigned-int (text :string))

;; Text formatting with variables (sprintf() style)
(cffi:defcfun ("TextFormat" text-format) :string (text :string)
  &rest)

;; Get a piece of a text string
(cffi:defcfun ("TextSubtext" text-subtext) :string (text :string) (position :int) (length :int))

;; Remove text spaces, concat words
(cffi:defcfun ("TextRemoveSpaces" text-remove-spaces) :string (text :string))

;; Get text between two strings
(cffi:defcfun ("GetTextBetween" get-text-between) :string
  (text :string) (begin :string) (end :string))

;; Replace text string with new string
(cffi:defcfun ("TextReplace" text-replace) :string
  (text :string) (search :string) (replacement :string))

;; Replace text string with new string, memory must be MemFree()
(cffi:defcfun ("TextReplaceAlloc" text-replace-alloc) :pointer
  (text :string) (search :string) (replacement :string))

;; Replace text between two specific strings
(cffi:defcfun ("TextReplaceBetween" text-replace-between) :string
  (text :string) (begin :string) (end :string) (replacement :string))

;; Replace text between two specific strings, memory must be MemFree()
(cffi:defcfun ("TextReplaceBetweenAlloc" text-replace-between-alloc) :pointer
  (text :string) (begin :string) (end :string) (replacement :string))

;; Insert text in a defined byte position
(cffi:defcfun ("TextInsert" text-insert) :string (text :string) (insert :string) (position :int))

;; Insert text in a defined byte position, memory must be MemFree()
(cffi:defcfun ("TextInsertAlloc" text-insert-alloc) :pointer
  (text :string) (insert :string) (position :int))

;; Join text strings with delimiter
(cffi:defcfun ("TextJoin" text-join) :string (text-list :pointer) (count :int) (delimiter :string))

;; Split text into multiple strings, using MAX_TEXTSPLIT_COUNT static strings
(cffi:defcfun ("TextSplit" text-split) :pointer (text :string) (delimiter :char) (count :pointer))

;; Append text at specific position and move cursor
(cffi:defcfun ("TextAppend" text-append) :void (text :pointer) (append :string) (position :pointer))

;; Find first text occurrence within a string, -1 if not found
(cffi:defcfun ("TextFindIndex" text-find-index) :int (text :string) (search :string))

;; Get upper case version of provided string
(cffi:defcfun ("TextToUpper" text-to-upper) :string (text :string))

;; Get lower case version of provided string
(cffi:defcfun ("TextToLower" text-to-lower) :string (text :string))

;; Get Pascal case notation version of provided string
(cffi:defcfun ("TextToPascal" text-to-pascal) :string (text :string))

;; Get Snake case notation version of provided string
(cffi:defcfun ("TextToSnake" text-to-snake) :string (text :string))

;; Get Camel case notation version of provided string
(cffi:defcfun ("TextToCamel" text-to-camel) :string (text :string))

;; Get integer value from text
(cffi:defcfun ("TextToInteger" text-to-integer) :int (text :string))

;; Get float value from text
(cffi:defcfun ("TextToFloat" text-to-float) :float (text :string))

;;; Models, meshes and 3D collisions

;; Load model from files (meshes and materials)
(cffi:defcfun ("LoadModel" load-model) (:struct model) (file-name :string))

;; Load model from generated mesh (default material)
(cffi:defcfun ("LoadModelFromMesh" load-model-from-mesh) (:struct model) (mesh (:struct mesh)))

;; Check if model is valid (loaded in GPU, VAO/VBOs)
(cffi:defcfun ("IsModelValid" %is-model-valid) :unsigned-char (model (:struct model)))

(defun is-model-valid (model)
  (not (zerop (%is-model-valid model))))

;; Unload model (including meshes) from memory (RAM and/or VRAM)
(cffi:defcfun ("UnloadModel" unload-model) :void (model (:struct model)))

;; Compute model bounding box limits (considers all meshes)
(cffi:defcfun ("GetModelBoundingBox" get-model-bounding-box) (:struct bounding-box)
  (model (:struct model)))

;; Draw a model (with texture if set)
(cffi:defcfun ("DrawModel" draw-model) :void
  (model (:struct model)) (position (:struct vector-3)) (scale :float) (tint (:struct rgba)))

;; Draw a model with custom transform
(cffi:defcfun ("DrawModelEx" draw-model-ex) :void
  (model (:struct model))
  (position (:struct vector-3))
  (rotation-axis (:struct vector-3))
  (rotation-angle :float)
  (scale (:struct vector-3))
  (tint (:struct rgba)))

;; Draw a model wires (with texture if set)
(cffi:defcfun ("DrawModelWires" draw-model-wires) :void
  (model (:struct model)) (position (:struct vector-3)) (scale :float) (tint (:struct rgba)))

;; Draw a model wires with custom transform
(cffi:defcfun ("DrawModelWiresEx" draw-model-wires-ex) :void
  (model (:struct model))
  (position (:struct vector-3))
  (rotation-axis (:struct vector-3))
  (rotation-angle :float)
  (scale (:struct vector-3))
  (tint (:struct rgba)))

;; Draw a billboard texture
(cffi:defcfun ("DrawBillboard" draw-billboard) :void
  (camera (:struct camera-3d))
  (texture (:struct texture))
  (position (:struct vector-3))
  (scale :float)
  (tint (:struct rgba)))

;; Draw a billboard texture defined by rectangle
(cffi:defcfun ("DrawBillboardRec" draw-billboard-rec) :void
  (camera (:struct camera-3d))
  (texture (:struct texture))
  (rec (:struct rectangle))
  (position (:struct vector-3))
  (size (:struct vector-2))
  (tint (:struct rgba)))

;; Draw a billboard texture defined by source rectangle with scaling and rotation
(cffi:defcfun ("DrawBillboardPro" draw-billboard-pro) :void
  (camera (:struct camera-3d))
  (texture (:struct texture))
  (rec (:struct rectangle))
  (position (:struct vector-3))
  (up (:struct vector-3))
  (size (:struct vector-2))
  (origin (:struct vector-2))
  (rotation :float)
  (tint (:struct rgba)))

;; Upload mesh vertex data in GPU and provide VAO/VBO ids
(cffi:defcfun ("UploadMesh" upload-mesh) :void (mesh :pointer) (dynamic (:boolean :uint8)))

;; Update mesh vertex data in GPU for a specific buffer index
(cffi:defcfun ("UpdateMeshBuffer" update-mesh-buffer) :void
  (mesh (:struct mesh)) (index :int) (data :pointer) (data-size :int) (offset :int))

;; Unload mesh data from CPU and GPU
(cffi:defcfun ("UnloadMesh" unload-mesh) :void (mesh (:struct mesh)))

;; Draw a 3d mesh with material and transform
(cffi:defcfun ("DrawMesh" draw-mesh) :void
  (mesh (:struct mesh)) (material (:struct material)) (transform (:struct matrix)))

;; Draw multiple mesh instances with material and different transforms
(cffi:defcfun ("DrawMeshInstanced" draw-mesh-instanced) :void
  (mesh (:struct mesh)) (material (:struct material)) (transforms :pointer) (instances :int))

;; Compute mesh bounding box limits
(cffi:defcfun ("GetMeshBoundingBox" get-mesh-bounding-box) (:struct bounding-box)
  (mesh (:struct mesh)))

;; Compute mesh tangents
(cffi:defcfun ("GenMeshTangents" gen-mesh-tangents) :void (mesh :pointer))

;; Export mesh data to file, returns true on success
(cffi:defcfun ("ExportMesh" %export-mesh) :unsigned-char (mesh (:struct mesh)) (file-name :string))

(defun export-mesh (mesh file-name)
  (not (zerop (%export-mesh mesh file-name))))

;; Export mesh as code file (.h) defining multiple arrays of vertex attributes
(cffi:defcfun ("ExportMeshAsCode" %export-mesh-as-code) :unsigned-char
  (mesh (:struct mesh)) (file-name :string))

(defun export-mesh-as-code (mesh file-name)
  (not (zerop (%export-mesh-as-code mesh file-name))))

;; Generate polygonal mesh
(cffi:defcfun ("GenMeshPoly" gen-mesh-poly) (:struct mesh) (sides :int) (radius :float))

;; Generate plane mesh (with subdivisions)
(cffi:defcfun ("GenMeshPlane" gen-mesh-plane) (:struct mesh)
  (width :float) (length :float) (res-x :int) (res-z :int))

;; Generate cuboid mesh
(cffi:defcfun ("GenMeshCube" gen-mesh-cube) (:struct mesh)
  (width :float) (height :float) (length :float))

;; Generate sphere mesh (standard sphere)
(cffi:defcfun ("GenMeshSphere" gen-mesh-sphere) (:struct mesh)
  (radius :float) (rings :int) (slices :int))

;; Generate half-sphere mesh (no bottom cap)
(cffi:defcfun ("GenMeshHemiSphere" gen-mesh-hemi-sphere) (:struct mesh)
  (radius :float) (rings :int) (slices :int))

;; Generate cylinder mesh
(cffi:defcfun ("GenMeshCylinder" gen-mesh-cylinder) (:struct mesh)
  (radius :float) (height :float) (slices :int))

;; Generate cone/pyramid mesh
(cffi:defcfun ("GenMeshCone" gen-mesh-cone) (:struct mesh)
  (radius :float) (height :float) (slices :int))

;; Generate torus mesh
(cffi:defcfun ("GenMeshTorus" %gen-mesh-torus) (:struct mesh)
  (radius :float) (size :float) (rad-seg :int) (sides :int))

(defun gen-mesh-torus (radius size radial-segments sides)
  (with-native-geometry (:divide-by-zero :invalid :overflow)
    (%gen-mesh-torus radius size radial-segments sides)))

;; Generate trefoil knot mesh
(cffi:defcfun ("GenMeshKnot" gen-mesh-knot) (:struct mesh)
  (radius :float) (size :float) (rad-seg :int) (sides :int))

;; Generate heightmap mesh from image data
(cffi:defcfun ("GenMeshHeightmap" gen-mesh-heightmap) (:struct mesh)
  (heightmap (:struct image)) (size (:struct vector-3)))

;; Generate cubes-based map mesh from image data
(cffi:defcfun ("GenMeshCubicmap" gen-mesh-cubicmap) (:struct mesh)
  (cubicmap (:struct image)) (cube-size (:struct vector-3)))

;; Load materials from model file
(cffi:defcfun ("LoadMaterials" load-materials) :pointer
  (file-name :string) (material-count :pointer))

;; Load default material (Supports: DIFFUSE, SPECULAR, NORMAL maps)
(cffi:defcfun ("LoadMaterialDefault" load-material-default) (:struct material))

;; Check if material is valid (shader assigned, map textures loaded in GPU)
(cffi:defcfun ("IsMaterialValid" %is-material-valid) :unsigned-char (material (:struct material)))

(defun is-material-valid (material)
  (not (zerop (%is-material-valid material))))

;; Unload material from GPU memory (VRAM)
(cffi:defcfun ("UnloadMaterial" unload-material) :void (material (:struct material)))

;; Set texture for a material map type (MATERIAL_MAP_DIFFUSE, MATERIAL_MAP_SPECULAR...)
(cffi:defcfun ("SetMaterialTexture" set-material-texture) :void
  (material :pointer) (map-type material-map-index) (texture (:struct texture)))

;; Set material for a mesh
(cffi:defcfun ("SetModelMeshMaterial" set-model-mesh-material) :void
  (model :pointer) (mesh-id :int) (material-id :int))

;; Load model animations from file
(cffi:defcfun ("LoadModelAnimations" load-model-animations) :pointer
  (file-name :string) (anim-count :pointer))

;; Update model animation pose (vertex buffers and bone matrices)
(cffi:defcfun ("UpdateModelAnimation" update-model-animation) :void
  (model (:struct model)) (anim (:struct model-animation)) (frame :float))

;; Update model animation pose, blending two animations
(cffi:defcfun ("UpdateModelAnimationEx" update-model-animation-ex) :void
  (model (:struct model))
  (anim-a (:struct model-animation))
  (frame-a :float)
  (anim-b (:struct model-animation))
  (frame-b :float)
  (blend :float))

;; Unload animation array data
(cffi:defcfun ("UnloadModelAnimations" unload-model-animations) :void
  (animations :pointer) (anim-count :int))

;; Check model animation skeleton match
(cffi:defcfun ("IsModelAnimationValid" %is-model-animation-valid) :unsigned-char
  (model (:struct model)) (anim (:struct model-animation)))

(defun is-model-animation-valid (model anim)
  (not (zerop (%is-model-animation-valid model anim))))

;; Check collision between two spheres
(cffi:defcfun ("CheckCollisionSpheres" %check-collision-spheres) :unsigned-char
  (center1 (:struct vector-3)) (radius1 :float) (center2 (:struct vector-3)) (radius2 :float))

(defun check-collision-spheres (center1 radius1 center2 radius2)
  (not (zerop (%check-collision-spheres center1 radius1 center2 radius2))))

;; Check collision between two bounding boxes
(cffi:defcfun ("CheckCollisionBoxes" %check-collision-boxes) :unsigned-char
  (box1 (:struct bounding-box)) (box2 (:struct bounding-box)))

(defun check-collision-boxes (box1 box2)
  (not (zerop (%check-collision-boxes box1 box2))))

;; Check collision between box and sphere
(cffi:defcfun ("CheckCollisionBoxSphere" %check-collision-box-sphere) :unsigned-char
  (box (:struct bounding-box)) (center (:struct vector-3)) (radius :float))

(defun check-collision-box-sphere (box center radius)
  (not (zerop (%check-collision-box-sphere box center radius))))

;; Get collision info between ray and sphere
(cffi:defcfun ("GetRayCollisionSphere" get-ray-collision-sphere) (:struct ray-collision)
  (ray (:struct ray)) (center (:struct vector-3)) (radius :float))

;; Get collision info between ray and box
(cffi:defcfun ("GetRayCollisionBox" %get-ray-collision-box) (:struct ray-collision)
  (ray (:struct ray)) (box (:struct bounding-box)))

(defun get-ray-collision-box (ray box)
  ;; The slab test uses infinity when a ray is parallel to a box face.
  (with-native-geometry (:divide-by-zero :invalid) (%get-ray-collision-box ray box)))

;; Get collision info between ray and mesh
(cffi:defcfun ("GetRayCollisionMesh" get-ray-collision-mesh) (:struct ray-collision)
  (ray (:struct ray)) (mesh (:struct mesh)) (transform (:struct matrix)))

;; Get collision info between ray and triangle
(cffi:defcfun ("GetRayCollisionTriangle" get-ray-collision-triangle) (:struct ray-collision)
  (ray (:struct ray)) (p1 (:struct vector-3)) (p2 (:struct vector-3)) (p3 (:struct vector-3)))

;; Get collision info between ray and quad
(cffi:defcfun ("GetRayCollisionQuad" get-ray-collision-quad) (:struct ray-collision)
  (ray (:struct ray))
  (p1 (:struct vector-3))
  (p2 (:struct vector-3))
  (p3 (:struct vector-3))
  (p4 (:struct vector-3)))

;;; Camera controllers

;; Update camera position for selected mode
(cffi:defcfun ("UpdateCamera" update-camera) :void (camera :pointer) (mode camera-mode))

;; Update camera movement/rotation
(cffi:defcfun ("UpdateCameraPro" update-camera-pro) :void
  (camera :pointer) (movement (:struct vector-3)) (rotation (:struct vector-3)) (zoom :float))

;;; Audio

;; Initialize audio device and context
(cffi:defcfun ("InitAudioDevice" init-audio-device) :void)

;; Close the audio device and context
(cffi:defcfun ("CloseAudioDevice" close-audio-device) :void)

;; Check if audio device has been initialized successfully
(cffi:defcfun ("IsAudioDeviceReady" is-audio-device-ready) (:boolean :uint8))

;; Set master volume (listener)
(cffi:defcfun ("SetMasterVolume" set-master-volume) :void (volume :float))

;; Get master volume (listener)
(cffi:defcfun ("GetMasterVolume" get-master-volume) :float)

;; Load wave data from file
(cffi:defcfun ("LoadWave" load-wave) (:struct wave) (file-name :string))

;; Load wave from memory buffer, fileType refers to extension: i.e. '.wav'
(cffi:defcfun ("LoadWaveFromMemory" load-wave-from-memory) (:struct wave)
  (file-type :string) (file-data :pointer) (data-size :int))

;; Check if wave data is valid (data loaded and parameters)
(cffi:defcfun ("IsWaveValid" %is-wave-valid) :uint8 (wave (:struct wave)))

(defun is-wave-valid (wave)
  (not (zerop (%is-wave-valid wave))))

;; Load sound from file
(cffi:defcfun ("LoadSound" load-sound) (:struct sound) (file-name :string))

;; Load sound from wave data
(cffi:defcfun ("LoadSoundFromWave" load-sound-from-wave) (:struct sound) (wave (:struct wave)))

;; Load sound alias, new sound that shares the same sample data as the source sound, does not own the sound data
(cffi:defcfun ("LoadSoundAlias" load-sound-alias) (:struct sound) (source (:struct sound)))

;; Check if sound is valid (data loaded and buffers initialized)
(cffi:defcfun ("IsSoundValid" %is-sound-valid) :uint8 (sound (:struct sound)))

(defun is-sound-valid (sound)
  (not (zerop (%is-sound-valid sound))))

;; Update sound buffer with new data (default data format: 32 bit float, stereo)
(cffi:defcfun ("UpdateSound" update-sound) :void
  (sound (:struct sound)) (data :pointer) (frame-count :int))

;; Unload wave data
(cffi:defcfun ("UnloadWave" unload-wave) :void (wave (:struct wave)))

;; Unload sound
(cffi:defcfun ("UnloadSound" unload-sound) :void (sound (:struct sound)))

;; Unload sound alias (does not deallocate sample data)
(cffi:defcfun ("UnloadSoundAlias" unload-sound-alias) :void (alias (:struct sound)))

;; Export wave data to file, returns true on success
(cffi:defcfun ("ExportWave" %export-wave) :uint8 (wave (:struct wave)) (file-name :string))

(defun export-wave (wave file-name)
  (not (zerop (%export-wave wave file-name))))

;; Export wave sample data to code (.h), returns true on success
(cffi:defcfun ("ExportWaveAsCode" %export-wave-as-code) :uint8
  (wave (:struct wave)) (file-name :string))

(defun export-wave-as-code (wave file-name)
  (not (zerop (%export-wave-as-code wave file-name))))

;; Play a sound
(cffi:defcfun ("PlaySound" play-sound) :void (sound (:struct sound)))

;; Stop playing a sound
(cffi:defcfun ("StopSound" stop-sound) :void (sound (:struct sound)))

;; Pause a sound
(cffi:defcfun ("PauseSound" pause-sound) :void (sound (:struct sound)))

;; Resume a paused sound
(cffi:defcfun ("ResumeSound" resume-sound) :void (sound (:struct sound)))

;; Check if sound is currently playing
(cffi:defcfun ("IsSoundPlaying" %is-sound-playing) :uint8 (sound (:struct sound)))

(defun is-sound-playing (sound)
  (not (zerop (%is-sound-playing sound))))

;; Set volume for a sound (1.0 is max level)
(cffi:defcfun ("SetSoundVolume" set-sound-volume) :void (sound (:struct sound)) (volume :float))

;; Set pitch for a sound (1.0 is base level)
(cffi:defcfun ("SetSoundPitch" set-sound-pitch) :void (sound (:struct sound)) (pitch :float))

;; Set pan for a sound (-1.0 left, 0.0 center, 1.0 right)
(cffi:defcfun ("SetSoundPan" set-sound-pan) :void (sound (:struct sound)) (pan :float))

;; Copy a wave to a new wave
(cffi:defcfun ("WaveCopy" wave-copy) (:struct wave) (wave (:struct wave)))

;; Crop a wave to defined frames range
(cffi:defcfun ("WaveCrop" wave-crop) :void (wave :pointer) (init-frame :int) (final-frame :int))

;; Convert wave data to desired format
(cffi:defcfun ("WaveFormat" wave-format) :void
  (wave :pointer) (sample-rate :int) (sample-size :int) (channels :int))

;; Load samples data from wave as a 32bit float data array
(cffi:defcfun ("LoadWaveSamples" load-wave-samples) :pointer (wave (:struct wave)))

;; Unload samples data loaded with LoadWaveSamples()
(cffi:defcfun ("UnloadWaveSamples" unload-wave-samples) :void (samples :pointer))

;; Load music stream from file
(cffi:defcfun ("LoadMusicStream" load-music-stream) (:struct music) (file-name :string))

;; Load music stream from data
(cffi:defcfun ("LoadMusicStreamFromMemory" load-music-stream-from-memory) (:struct music)
  (file-type :string) (data :pointer) (data-size :int))

;; Check if music stream is valid (context and buffers initialized)
(cffi:defcfun ("IsMusicValid" %is-music-valid) :uint8 (music (:struct music)))

(defun is-music-valid (music)
  (not (zerop (%is-music-valid music))))

;; Unload music stream
(cffi:defcfun ("UnloadMusicStream" unload-music-stream) :void (music (:struct music)))

;; Start music playing
(cffi:defcfun ("PlayMusicStream" play-music-stream) :void (music (:struct music)))

;; Check if music is playing
(cffi:defcfun ("IsMusicStreamPlaying" %is-music-stream-playing) :uint8 (music (:struct music)))

(defun is-music-stream-playing (music)
  (not (zerop (%is-music-stream-playing music))))

;; Update buffers for music streaming
(cffi:defcfun ("UpdateMusicStream" update-music-stream) :void (music (:struct music)))

;; Stop music playing
(cffi:defcfun ("StopMusicStream" stop-music-stream) :void (music (:struct music)))

;; Pause music playing
(cffi:defcfun ("PauseMusicStream" pause-music-stream) :void (music (:struct music)))

;; Resume playing paused music
(cffi:defcfun ("ResumeMusicStream" resume-music-stream) :void (music (:struct music)))

;; Seek music to a position (in seconds)
(cffi:defcfun ("SeekMusicStream" seek-music-stream) :void (music (:struct music)) (position :float))

;; Set volume for music (1.0 is max level)
(cffi:defcfun ("SetMusicVolume" set-music-volume) :void (music (:struct music)) (volume :float))

;; Set pitch for music (1.0 is base level)
(cffi:defcfun ("SetMusicPitch" set-music-pitch) :void (music (:struct music)) (pitch :float))

;; Set pan for music (-1.0 left, 0.0 center, 1.0 right)
(cffi:defcfun ("SetMusicPan" set-music-pan) :void (music (:struct music)) (pan :float))

;; Get music time length (in seconds)
(cffi:defcfun ("GetMusicTimeLength" get-music-time-length) :float (music (:struct music)))

;; Get current music time played (in seconds)
(cffi:defcfun ("GetMusicTimePlayed" get-music-time-played) :float (music (:struct music)))

;; Load audio stream (to stream raw audio pcm data)
(cffi:defcfun ("LoadAudioStream" load-audio-stream) (:struct audio-stream)
  (sample-rate :unsigned-int) (sample-size :unsigned-int) (channels :unsigned-int))

;; Check if an audio stream is valid (buffers initialized)
(cffi:defcfun ("IsAudioStreamValid" %is-audio-stream-valid) :uint8 (stream (:struct audio-stream)))

(defun is-audio-stream-valid (stream)
  (not (zerop (%is-audio-stream-valid stream))))

;; Unload audio stream and free memory
(cffi:defcfun ("UnloadAudioStream" unload-audio-stream) :void (stream (:struct audio-stream)))

;; Update audio stream buffers with data
(cffi:defcfun ("UpdateAudioStream" update-audio-stream) :void
  (stream (:struct audio-stream)) (data :pointer) (frame-count :int))

;; Check if any audio stream buffers requires refill
(cffi:defcfun ("IsAudioStreamProcessed" %is-audio-stream-processed) :uint8
  (stream (:struct audio-stream)))

(defun is-audio-stream-processed (stream)
  (not (zerop (%is-audio-stream-processed stream))))

;; Play audio stream
(cffi:defcfun ("PlayAudioStream" play-audio-stream) :void (stream (:struct audio-stream)))

;; Pause audio stream
(cffi:defcfun ("PauseAudioStream" pause-audio-stream) :void (stream (:struct audio-stream)))

;; Resume audio stream
(cffi:defcfun ("ResumeAudioStream" resume-audio-stream) :void (stream (:struct audio-stream)))

;; Check if audio stream is playing
(cffi:defcfun ("IsAudioStreamPlaying" %is-audio-stream-playing) :uint8
  (stream (:struct audio-stream)))

(defun is-audio-stream-playing (stream)
  (not (zerop (%is-audio-stream-playing stream))))

;; Stop audio stream
(cffi:defcfun ("StopAudioStream" stop-audio-stream) :void (stream (:struct audio-stream)))

;; Set volume for audio stream (1.0 is max level)
(cffi:defcfun ("SetAudioStreamVolume" set-audio-stream-volume) :void
  (stream (:struct audio-stream)) (volume :float))

;; Set pitch for audio stream (1.0 is base level)
(cffi:defcfun ("SetAudioStreamPitch" set-audio-stream-pitch) :void
  (stream (:struct audio-stream)) (pitch :float))

;; Set pan for audio stream (-1.0 left, 0.0 center, 1.0 right)
(cffi:defcfun ("SetAudioStreamPan" set-audio-stream-pan) :void
  (stream (:struct audio-stream)) (pan :float))

;; Default size for new audio streams
(cffi:defcfun ("SetAudioStreamBufferSizeDefault" set-audio-stream-buffer-size-default) :void
  (size :int))

;; Audio thread callback to request new data
(cffi:defcfun ("SetAudioStreamCallback" set-audio-stream-callback) :void
  (stream (:struct audio-stream)) (callback :pointer))

;; Attach audio stream processor to stream, receives frames x 2 samples as 'float' (stereo)
(cffi:defcfun ("AttachAudioStreamProcessor" attach-audio-stream-processor) :void
  (stream (:struct audio-stream)) (processor :pointer))

;; Detach audio stream processor from stream
(cffi:defcfun ("DetachAudioStreamProcessor" detach-audio-stream-processor) :void
  (stream (:struct audio-stream)) (processor :pointer))

;; Attach audio stream processor to the entire audio pipeline, receives frames x 2 samples as 'float' (stereo)
(cffi:defcfun ("AttachAudioMixedProcessor" attach-audio-mixed-processor) :void (processor :pointer))

;; Detach audio stream processor from the entire audio pipeline
(cffi:defcfun ("DetachAudioMixedProcessor" detach-audio-mixed-processor) :void (processor :pointer))
