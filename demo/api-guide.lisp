(in-package #:raylisp)

(defparameter *core-guide*
  '(
    ("(init-window width height title)" "void InitWindow(int width, int height, const char *title)" "Initialize window and OpenGL context"
     "(init-window 720 420 \"My window\")")
    ("(close-window)" "void CloseWindow(void)" "Close window and unload OpenGL context"
     "(close-window)")
    ("(window-should-close-p)" "bool WindowShouldClose(void)" "Check if application should close (KEY_ESCAPE pressed or windows close icon clicked)"
     "(window-should-close-p)")
    ("(is-window-ready)" "bool IsWindowReady(void)" "Check if window has been initialized successfully"
     "(is-window-ready)")
    ("(is-window-fullscreen)" "bool IsWindowFullscreen(void)" "Check if window is currently fullscreen"
     "(is-window-fullscreen)")
    ("(is-window-hidden)" "bool IsWindowHidden(void)" "Check if window is currently hidden"
     "(is-window-hidden)")
    ("(is-window-minimized)" "bool IsWindowMinimized(void)" "Check if window is currently minimized"
     "(is-window-minimized)")
    ("(is-window-maximized)" "bool IsWindowMaximized(void)" "Check if window is currently maximized"
     "(is-window-maximized)")
    ("(is-window-focused)" "bool IsWindowFocused(void)" "Check if window is currently focused"
     "(is-window-focused)")
    ("(is-window-resized)" "bool IsWindowResized(void)" "Check if window has been resized last frame"
     "(is-window-resized)")
    ("(is-window-state flag)" "bool IsWindowState(unsigned int flag)" "Check if one specific window flag is enabled"
     "(is-window-state '(:window-resizable))")
    ("(set-window-state flags)" "void SetWindowState(unsigned int flags)" "Set window configuration state using flags"
     "(set-window-state '(:window-resizable))")
    ("(clear-window-state flags)" "void ClearWindowState(unsigned int flags)" "Clear window configuration state flags"
     "(clear-window-state '(:window-resizable))")
    ("(toggle-fullscreen)" "void ToggleFullscreen(void)" "Toggle window state: fullscreen/windowed, resizes monitor to match window resolution"
     "(toggle-fullscreen)")
    ("(toggle-borderless-windowed)" "void ToggleBorderlessWindowed(void)" "Toggle window state: borderless windowed, resizes window to match monitor resolution"
     "(toggle-borderless-windowed)")
    ("(maximize-window)" "void MaximizeWindow(void)" "Set window state: maximized, if resizable"
     "(maximize-window)")
    ("(minimize-window)" "void MinimizeWindow(void)" "Set window state: minimized, if resizable"
     "(minimize-window)")
    ("(restore-window)" "void RestoreWindow(void)" "Restore window from being minimized/maximized"
     "(restore-window)")
    ("(set-window-icon image)" "void SetWindowIcon(Image image)" "Set icon for window (single image, RGBA 32bit)"
     "(set-window-icon icon-image)")
    ("(set-window-icons images count)" "void SetWindowIcons(Image *images, int count)" "Set icon for window (multiple images, RGBA 32bit)"
     "(set-window-icons icon-array icon-count)")
    ("(set-window-title title)" "void SetWindowTitle(const char *title)" "Set title for window"
     "(set-window-title \"Level 2\")")
    ("(set-window-position x y)" "void SetWindowPosition(int x, int y)" "Set window position on screen"
     "(set-window-position 80 80)")
    ("(set-window-monitor monitor)" "void SetWindowMonitor(int monitor)" "Set monitor for the current window"
     "(set-window-monitor (get-current-monitor))")
    ("(set-window-min-size width height)" "void SetWindowMinSize(int width, int height)" "Set window minimum dimensions (for FLAG_WINDOW_RESIZABLE)"
     "(set-window-min-size 400 240)")
    ("(set-window-max-size width height)" "void SetWindowMaxSize(int width, int height)" "Set window maximum dimensions (for FLAG_WINDOW_RESIZABLE)"
     "(set-window-max-size 1600 1000)")
    ("(set-window-size width height)" "void SetWindowSize(int width, int height)" "Set window dimensions"
     "(set-window-size 720 420)")
    ("(set-window-opacity opacity)" "void SetWindowOpacity(float opacity)" "Set window opacity [0.0f..1.0f]"
     "(set-window-opacity 0.9f0)")
    ("(set-window-focused)" "void SetWindowFocused(void)" "Set window focused"
     "(set-window-focused)")
    ("(get-window-handle)" "void *GetWindowHandle(void)" "Get native window handle"
     "(get-window-handle)")
    ("(get-screen-width)" "int GetScreenWidth(void)" "Get current screen width"
     "(get-screen-width)")
    ("(get-screen-height)" "int GetScreenHeight(void)" "Get current screen height"
     "(get-screen-height)")
    ("(get-render-width)" "int GetRenderWidth(void)" "Get current render width (it considers HiDPI)"
     "(get-render-width)")
    ("(get-render-height)" "int GetRenderHeight(void)" "Get current render height (it considers HiDPI)"
     "(get-render-height)")
    ("(get-monitor-count)" "int GetMonitorCount(void)" "Get number of connected monitors"
     "(get-monitor-count)")
    ("(get-current-monitor)" "int GetCurrentMonitor(void)" "Get current monitor where window is placed"
     "(get-current-monitor)")
    ("(get-monitor-position monitor)" "Vector2 GetMonitorPosition(int monitor)" "Get specified monitor position"
     "(get-monitor-position (get-current-monitor))")
    ("(get-monitor-width monitor)" "int GetMonitorWidth(int monitor)" "Get specified monitor width (current video mode used by monitor)"
     "(get-monitor-width (get-current-monitor))")
    ("(get-monitor-height monitor)" "int GetMonitorHeight(int monitor)" "Get specified monitor height (current video mode used by monitor)"
     "(get-monitor-height (get-current-monitor))")
    ("(get-monitor-physical-width monitor)" "int GetMonitorPhysicalWidth(int monitor)" "Get specified monitor physical width in millimetres"
     "(get-monitor-physical-width (get-current-monitor))")
    ("(get-monitor-physical-height monitor)" "int GetMonitorPhysicalHeight(int monitor)" "Get specified monitor physical height in millimetres"
     "(get-monitor-physical-height (get-current-monitor))")
    ("(get-monitor-refresh-rate monitor)" "int GetMonitorRefreshRate(int monitor)" "Get specified monitor refresh rate"
     "(get-monitor-refresh-rate (get-current-monitor))")
    ("(get-window-position)" "Vector2 GetWindowPosition(void)" "Get window position XY on monitor"
     "(get-window-position)")
    ("(get-window-scale-dpi)" "Vector2 GetWindowScaleDPI(void)" "Get window scale DPI factor"
     "(get-window-scale-dpi)")
    ("(get-monitor-name monitor)" "const char *GetMonitorName(int monitor)" "Get the human-readable, UTF-8 encoded name of the specified monitor"
     "(get-monitor-name (get-current-monitor))")
    ("(set-clipboard-text text)" "void SetClipboardText(const char *text)" "Set clipboard text content"
     "(set-clipboard-text \"Score: 42\")")
    ("(get-clipboard-text)" "const char *GetClipboardText(void)" "Get clipboard text content"
     "(get-clipboard-text)")
    ("(get-clipboard-image)" "Image GetClipboardImage(void)" "Get clipboard image content"
     "(get-clipboard-image)")
    ("(enable-event-waiting)" "void EnableEventWaiting(void)" "Enable waiting for events on EndDrawing(), no automatic event polling"
     "(enable-event-waiting)")
    ("(disable-event-waiting)" "void DisableEventWaiting(void)" "Disable waiting for events on EndDrawing(), automatic events polling"
     "(disable-event-waiting)")
    ("(show-cursor)" "void ShowCursor(void)" "Show cursor"
     "(show-cursor)")
    ("(hide-cursor)" "void HideCursor(void)" "Hide cursor"
     "(hide-cursor)")
    ("(is-cursor-hidden)" "bool IsCursorHidden(void)" "Check if cursor is not visible"
     "(is-cursor-hidden)")
    ("(enable-cursor)" "void EnableCursor(void)" "Enable cursor (unlock cursor)"
     "(enable-cursor)")
    ("(disable-cursor)" "void DisableCursor(void)" "Disable cursor (lock cursor)"
     "(disable-cursor)")
    ("(is-cursor-on-screen)" "bool IsCursorOnScreen(void)" "Check if cursor is on the screen"
     "(is-cursor-on-screen)")
    ("(clear-background color)" "void ClearBackground(Color color)" "Clear background (framebuffer) to color"
     "(clear-background (color 245 245 245))")
    ("(begin-drawing)" "void BeginDrawing(void)" "Begin canvas (framebuffer) drawing"
     "(begin-drawing)")
    ("(end-drawing)" "void EndDrawing(void)" "End canvas (framebuffer) drawing and swap buffers (double buffering)"
     "(end-drawing)")
    ("(begin-mode-2d camera)" "void BeginMode2D(Camera2D camera)" "Begin 2D mode with custom camera (2D)"
     "(begin-mode-2d camera2d)")
    ("(end-mode-2d)" "void EndMode2D(void)" "End 2D mode with custom camera"
     "(end-mode-2d)")
    ("(begin-mode-3d camera)" "void BeginMode3D(Camera3D camera)" "Begin 3D mode with custom camera (3D)"
     "(begin-mode-3d camera3d)")
    ("(end-mode-3d)" "void EndMode3D(void)" "End 3D mode and returns to default 2D orthographic mode"
     "(end-mode-3d)")
    ("(begin-texture-mode target)" "void BeginTextureMode(RenderTexture2D target)" "Begin drawing to render texture"
     "(begin-texture-mode render-target)")
    ("(end-texture-mode)" "void EndTextureMode(void)" "End drawing to render texture"
     "(end-texture-mode)")
    ("(begin-shader-mode shader)" "void BeginShaderMode(Shader shader)" "Begin custom shader drawing"
     "(begin-shader-mode shader)")
    ("(end-shader-mode)" "void EndShaderMode(void)" "End custom shader drawing (use default shader)"
     "(end-shader-mode)")
    ("(begin-blend-mode mode)" "void BeginBlendMode(int mode)" "Begin blending mode (alpha, additive, multiplied, subtract, custom)"
     "(begin-blend-mode :additive)")
    ("(end-blend-mode)" "void EndBlendMode(void)" "End blending mode (reset to default: alpha blending)"
     "(end-blend-mode)")
    ("(begin-scissor-mode x y width height)" "void BeginScissorMode(int x, int y, int width, int height)" "Begin scissor mode (define screen area for following drawing)"
     "(begin-scissor-mode 20 20 200 100)")
    ("(end-scissor-mode)" "void EndScissorMode(void)" "End scissor mode"
     "(end-scissor-mode)")
    ("(begin-vr-stereo-mode config)" "void BeginVrStereoMode(VrStereoConfig config)" "Begin stereo rendering (requires VR simulator)"
     "(begin-vr-stereo-mode stereo-config)")
    ("(end-vr-stereo-mode)" "void EndVrStereoMode(void)" "End stereo rendering (requires VR simulator)"
     "(end-vr-stereo-mode)")
    ("(load-vr-stereo-config device)" "VrStereoConfig LoadVrStereoConfig(VrDeviceInfo device)" "Load VR stereo config for VR simulator device parameters"
     "(load-vr-stereo-config headset-info)")
    ("(unload-vr-stereo-config config)" "void UnloadVrStereoConfig(VrStereoConfig config)" "Unload VR stereo config"
     "(unload-vr-stereo-config stereo-config)")
    ("(load-shader vs-file-name fs-file-name)" "Shader LoadShader(const char *vsFileName, const char *fsFileName)" "Load shader from files and bind default locations"
     "(load-shader (cffi:null-pointer) \"glow.fs\")")
    ("(load-shader-from-memory vs-code fs-code)" "Shader LoadShaderFromMemory(const char *vsCode, const char *fsCode)" "Load shader from code strings and bind default locations"
     "(load-shader-from-memory (cffi:null-pointer) fragment-source)")
    ("(is-shader-valid shader)" "bool IsShaderValid(Shader shader)" "Check if shader is valid (loaded on GPU)"
     "(is-shader-valid shader)")
    ("(get-shader-location shader uniform-name)" "int GetShaderLocation(Shader shader, const char *uniformName)" "Get shader uniform location"
     "(get-shader-location shader \"strength\")")
    ("(get-shader-location-attrib shader attrib-name)" "int GetShaderLocationAttrib(Shader shader, const char *attribName)" "Get shader attribute location"
     "(get-shader-location-attrib shader \"vertexPosition\")")
    ("(set-shader-value shader loc-index value uniform-type)" "void SetShaderValue(Shader shader, int locIndex, const void *value, int uniformType)" "Set shader uniform value"
     "(set-shader-value shader location float-buffer :float)")
    ("(set-shader-value-v shader loc-index value uniform-type count)" "void SetShaderValueV(Shader shader, int locIndex, const void *value, int uniformType, int count)" "Set shader uniform value vector"
     "(set-shader-value-v shader location vector-buffer :vec3 2)")
    ("(set-shader-value-matrix shader loc-index mat)" "void SetShaderValueMatrix(Shader shader, int locIndex, Matrix mat)" "Set shader uniform value (matrix 4x4)"
     "(set-shader-value-matrix shader location transform)")
    ("(set-shader-value-texture shader loc-index texture)" "void SetShaderValueTexture(Shader shader, int locIndex, Texture2D texture)" "Set shader uniform value and bind the texture (sampler2d)"
     "(set-shader-value-texture shader location texture)")
    ("(unload-shader shader)" "void UnloadShader(Shader shader)" "Unload shader from GPU memory (VRAM)"
     "(unload-shader shader)")
    ("(get-screen-to-world-ray position camera)" "Ray GetScreenToWorldRay(Vector2 position, Camera camera)" "Get a ray trace from screen position (i.e mouse)"
     "(get-screen-to-world-ray (get-mouse-position) camera3d)")
    ("(get-screen-to-world-ray-ex position camera width height)" "Ray GetScreenToWorldRayEx(Vector2 position, Camera camera, int width, int height)" "Get a ray trace from screen position (i.e mouse) in a viewport"
     "(get-screen-to-world-ray-ex (vec2 100 100) camera3d 720 420)")
    ("(get-world-to-screen position camera)" "Vector2 GetWorldToScreen(Vector3 position, Camera camera)" "Get screen space position for a 3d world space position"
     "(get-world-to-screen (vec3 0 1 0) camera3d)")
    ("(get-world-to-screen-ex position camera width height)" "Vector2 GetWorldToScreenEx(Vector3 position, Camera camera, int width, int height)" "Get sized screen space position for a 3d world space position"
     "(get-world-to-screen-ex (vec3 0 1 0) camera3d 720 420)")
    ("(get-world-to-screen-2d position camera)" "Vector2 GetWorldToScreen2D(Vector2 position, Camera2D camera)" "Get screen space position for a 2d camera world space position"
     "(get-world-to-screen-2d (vec2 0 0) camera2d)")
    ("(get-screen-to-world-2d position camera)" "Vector2 GetScreenToWorld2D(Vector2 position, Camera2D camera)" "Get world space position for a 2d camera screen space position"
     "(get-screen-to-world-2d (get-mouse-position) camera2d)")
    ("(get-camera-matrix camera)" "Matrix GetCameraMatrix(Camera camera)" "Get camera transform matrix (view matrix)"
     "(get-camera-matrix camera3d)")
    ("(get-camera-matrix-2d camera)" "Matrix GetCameraMatrix2D(Camera2D camera)" "Get camera 2d transform matrix"
     "(get-camera-matrix-2d camera2d)")
    ("(set-target-fps fps)" "void SetTargetFPS(int fps)" "Set target FPS (maximum)"
     "(set-target-fps 60)")
    ("(get-frame-time)" "float GetFrameTime(void)" "Get time in seconds for last frame drawn (delta time)"
     "(get-frame-time)")
    ("(get-time)" "double GetTime(void)" "Get elapsed time in seconds since InitWindow()"
     "(get-time)")
    ("(get-fps)" "int GetFPS(void)" "Get current FPS"
     "(get-fps)")
    ("(swap-screen-buffer)" "void SwapScreenBuffer(void)" "Swap back buffer with front buffer (screen drawing)"
     "(swap-screen-buffer)")
    ("(poll-input-events)" "void PollInputEvents(void)" "Register all input events"
     "(poll-input-events)")
    ("(wait-time seconds)" "void WaitTime(double seconds)" "Wait for some time (halt program execution)"
     "(wait-time 0.01d0)")
    ("(set-random-seed seed)" "void SetRandomSeed(unsigned int seed)" "Set the seed for the random number generator"
     "(set-random-seed 42)")
    ("(get-random-value min max)" "int GetRandomValue(int min, int max)" "Get a random value between min and max (both included)"
     "(get-random-value 1 6)")
    ("(load-random-sequence count min max)" "int *LoadRandomSequence(unsigned int count, int min, int max)" "Load random values sequence, no values repeated"
     "(load-random-sequence 4 1 10)")
    ("(unload-random-sequence sequence)" "void UnloadRandomSequence(int *sequence)" "Unload random values sequence"
     "(unload-random-sequence rolls)")
    ("(take-screenshot file-name)" "void TakeScreenshot(const char *fileName)" "Takes a screenshot of current screen (filename extension defines format)"
     "(take-screenshot \"frame.png\")")
    ("(set-config-flags flags)" "void SetConfigFlags(unsigned int flags)" "Set init configuration flags (view FLAGS)"
     "(set-config-flags '(:window-resizable :vsync-hint))")
    ("(open-url url)" "void OpenURL(const char *url)" "Open URL with default system browser (if available)"
     "(open-url \"https://www.raylib.com\")")
    ("(set-trace-log-level log-level)" "void SetTraceLogLevel(int logLevel)" "Set the current threshold (minimum) log level"
     "(set-trace-log-level :warning)")
    ("(trace-log log-level text typed-varargs...)" "void TraceLog(int logLevel, const char *text, ...)" "Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...)"
     "(trace-log :info \"Level %d\" :int 2)")
    ("(set-trace-log-callback callback)" "void SetTraceLogCallback(TraceLogCallback callback)" "Set custom trace log"
     "(set-trace-log-callback (cffi:null-pointer))")
    ("(mem-alloc size)" "void *MemAlloc(unsigned int size)" "Internal memory allocator"
     "(mem-alloc 256)")
    ("(mem-realloc ptr size)" "void *MemRealloc(void *ptr, unsigned int size)" "Internal memory reallocator"
     "(mem-realloc buffer 512)")
    ("(mem-free ptr)" "void MemFree(void *ptr)" "Internal memory free"
     "(mem-free buffer)")
    ("(load-file-data file-name data-size)" "unsigned char *LoadFileData(const char *fileName, int *dataSize)" "Load file data as byte array (read)"
     "(load-file-data \"level.bin\" size-out)")
    ("(unload-file-data data)" "void UnloadFileData(unsigned char *data)" "Unload file data allocated by LoadFileData()"
     "(unload-file-data bytes)")
    ("(save-file-data file-name data data-size)" "bool SaveFileData(const char *fileName, const void *data, int dataSize)" "Save data to file from byte array (write), returns true on success"
     "(save-file-data \"copy.bin\" bytes byte-count)")
    ("(export-data-as-code data data-size file-name)" "bool ExportDataAsCode(const unsigned char *data, int dataSize, const char *fileName)" "Export data to code (.h), returns true on success"
     "(export-data-as-code bytes byte-count \"level.h\")")
    ("(load-file-text file-name)" "char *LoadFileText(const char *fileName)" "Load text data from file (read), returns a '\\0' terminated string"
     "(load-file-text \"level.txt\")")
    ("(unload-file-text text)" "void UnloadFileText(char *text)" "Unload file text data allocated by LoadFileText()"
     "(unload-file-text text-buffer)")
    ("(save-file-text file-name text)" "bool SaveFileText(const char *fileName, const char *text)" "Save text data to file (write), string must be '\\0' terminated, returns true on success"
     "(save-file-text \"level.txt\" \"Level one\")")
    ("(set-load-file-data-callback callback)" "void SetLoadFileDataCallback(LoadFileDataCallback callback)" "Set custom file binary data loader"
     "(set-load-file-data-callback (cffi:null-pointer))")
    ("(set-save-file-data-callback callback)" "void SetSaveFileDataCallback(SaveFileDataCallback callback)" "Set custom file binary data saver"
     "(set-save-file-data-callback (cffi:null-pointer))")
    ("(set-load-file-text-callback callback)" "void SetLoadFileTextCallback(LoadFileTextCallback callback)" "Set custom file text data loader"
     "(set-load-file-text-callback (cffi:null-pointer))")
    ("(set-save-file-text-callback callback)" "void SetSaveFileTextCallback(SaveFileTextCallback callback)" "Set custom file text data saver"
     "(set-save-file-text-callback (cffi:callback preview-text-save))")
    ("(file-rename file-name file-rename)" "int FileRename(const char *fileName, const char *fileRename)" "Rename file (if exists), returns 0 on success"
     "(file-rename \"level.txt\" \"level1.txt\")")
    ("(file-remove file-name)" "int FileRemove(const char *fileName)" "Remove file (if exists), returns 0 on success"
     "(file-remove \"scratch.txt\")")
    ("(file-copy src-path dst-path)" "int FileCopy(const char *srcPath, const char *dstPath)" "Copy file from one path to another, dstPath created if it doesn't exist, returns 0 on success"
     "(file-copy \"level.txt\" \"backup/level.txt\")")
    ("(file-move src-path dst-path)" "int FileMove(const char *srcPath, const char *dstPath)" "Move file from one directory to another, dstPath created if it doesn't exist, returns 0 on success"
     "(file-move \"level.txt\" \"backup/level.txt\")")
    ("(file-text-replace file-name search replacement)" "int FileTextReplace(const char *fileName, const char *search, const char *replacement)" "Replace text in an existing file, returns 0 on success"
     "(file-text-replace \"level.txt\" \"green\" \"blue\")")
    ("(file-text-find-index file-name search)" "int FileTextFindIndex(const char *fileName, const char *search)" "Find text in existing file, returns -1 if index not found or index otherwise"
     "(file-text-find-index \"level.txt\" \"blue\")")
    ("(file-exists file-name)" "bool FileExists(const char *fileName)" "Check if file exists"
     "(file-exists \"level.txt\")")
    ("(directory-exists dir-path)" "bool DirectoryExists(const char *dirPath)" "Check if directory path exists"
     "(directory-exists \"levels\")")
    ("(is-file-extension file-name ext)" "bool IsFileExtension(const char *fileName, const char *ext)" "Check file extension (recommended include point: .png, .wav)"
     "(is-file-extension \"level.txt\" \".txt\")")
    ("(is-file-hidden file-path)" "bool IsFileHidden(const char *filePath)" "Check if file path (file or directory) is hidden by OS"
     "(is-file-hidden \"level.txt\")")
    ("(get-file-length file-name)" "int GetFileLength(const char *fileName)" "Get file length in bytes (NOTE: GetFileSize() conflicts with windows.h)"
     "(get-file-length \"level.txt\")")
    ("(get-file-mod-time file-name)" "long GetFileModTime(const char *fileName)" "Get file modification time (last write time)"
     "(get-file-mod-time \"level.txt\")")
    ("(get-file-extension file-name)" "const char *GetFileExtension(const char *fileName)" "Get pointer to extension for a filename string (includes dot: '.png')"
     "(get-file-extension \"levels/first.txt\")")
    ("(get-file-name file-path)" "const char *GetFileName(const char *filePath)" "Get pointer to filename for a path string"
     "(get-file-name \"levels/first.txt\")")
    ("(get-file-name-without-ext file-path)" "const char *GetFileNameWithoutExt(const char *filePath)" "Get filename string without extension (uses static string)"
     "(get-file-name-without-ext \"levels/first.txt\")")
    ("(get-directory-path file-path)" "const char *GetDirectoryPath(const char *filePath)" "Get full path for a provided fileName with path (uses static string)"
     "(get-directory-path \"levels/first.txt\")")
    ("(get-prev-directory-path dir-path)" "const char *GetPrevDirectoryPath(const char *dirPath)" "Get previous directory path for a provided path (uses static string)"
     "(get-prev-directory-path \"assets/levels\")")
    ("(get-working-directory)" "const char *GetWorkingDirectory(void)" "Get current working directory (uses static string)"
     "(get-working-directory)")
    ("(get-application-directory)" "const char *GetApplicationDirectory(void)" "Get the directory of the running application (uses static string)"
     "(get-application-directory)")
    ("(make-directory dir-path)" "int MakeDirectory(const char *dirPath)" "Create directories (including full path requested), returns 0 on success"
     "(make-directory \"levels\")")
    ("(change-directory dir-path)" "int ChangeDirectory(const char *dirPath)" "Change working directory, returns 0 on success"
     "(change-directory \"levels\")")
    ("(is-path-file path)" "bool IsPathFile(const char *path)" "Check if provided path points to a file"
     "(is-path-file \"level.txt\")")
    ("(is-path-directory path)" "bool IsPathDirectory(const char *path)" "Check if provided path points to a directory"
     "(is-path-directory \"levels\")")
    ("(is-path-absolute path)" "bool IsPathAbsolute(const char *path)" "Check if provided path is an absolute path"
     "(is-path-absolute \"/tmp/level.txt\")")
    ("(is-file-name-valid file-name)" "bool IsFileNameValid(const char *fileName)" "Check if fileName is valid for the platform/OS"
     "(is-file-name-valid \"level1.txt\")")
    ("(load-directory-files dir-path)" "FilePathList LoadDirectoryFiles(const char *dirPath)" "Load directory filepaths, files and directories, no subdirs scan"
     "(load-directory-files \"levels\")")
    ("(load-directory-files-ex base-path filter scan-subdirs)" "FilePathList LoadDirectoryFilesEx(const char *basePath, const char *filter, bool scanSubdirs)" "Load directory filepaths with extension filtering and subdir scan; some filters available: '*.*','FILES*','DIRS*'"
     "(load-directory-files-ex \"levels\" \".txt\" nil)")
    ("(unload-directory-files files)" "void UnloadDirectoryFiles(FilePathList files)" "Unload filepaths"
     "(unload-directory-files files)")
    ("(is-file-dropped)" "bool IsFileDropped(void)" "Check if file has been dropped into window"
     "(is-file-dropped)")
    ("(load-dropped-files)" "FilePathList LoadDroppedFiles(void)" "Load dropped filepaths"
     "(load-dropped-files)")
    ("(unload-dropped-files files)" "void UnloadDroppedFiles(FilePathList files)" "Unload dropped filepaths"
     "(unload-dropped-files files)")
    ("(get-directory-file-count dir-path)" "unsigned int GetDirectoryFileCount(const char *dirPath)" "Get the file count in a directory"
     "(get-directory-file-count \"levels\")")
    ("(get-directory-file-count-ex base-path filter scan-subdirs)" "unsigned int GetDirectoryFileCountEx(const char *basePath, const char *filter, bool scanSubdirs)" "Get the file count in a directory with extension filtering and recursive directory scan. Use 'DIR' in the filter string to include directories in the result"
     "(get-directory-file-count-ex \"levels\" \".txt\" nil)")
    ("(compress-data data data-size comp-data-size)" "unsigned char *CompressData(const unsigned char *data, int dataSize, int *compDataSize)" "Compress data (DEFLATE algorithm), memory must be MemFree()"
     "(compress-data bytes byte-count size-out)")
    ("(decompress-data comp-data comp-data-size data-size)" "unsigned char *DecompressData(const unsigned char *compData, int compDataSize, int *dataSize)" "Decompress data (DEFLATE algorithm), memory must be MemFree()"
     "(decompress-data compressed compressed-size size-out)")
    ("(encode-data-base64 data data-size output-size)" "char *EncodeDataBase64(const unsigned char *data, int dataSize, int *outputSize)" "Encode data to Base64 string (includes NULL terminator), memory must be MemFree()"
     "(encode-data-base64 bytes byte-count size-out)")
    ("(decode-data-base64 text output-size)" "unsigned char *DecodeDataBase64(const char *text, int *outputSize)" "Decode Base64 string (expected NULL terminated), memory must be MemFree()"
     "(decode-data-base64 \"SGk=\" size-out)")
    ("(compute-crc32 data data-size)" "unsigned int ComputeCRC32(const unsigned char *data, int dataSize)" "Compute CRC32 hash code"
     "(compute-crc32 bytes byte-count)")
    ("(compute-md5 data data-size)" "unsigned int *ComputeMD5(const unsigned char *data, int dataSize)" "Compute MD5 hash code, returns static int[4] (16 bytes)"
     "(compute-md5 bytes byte-count)")
    ("(compute-sha1 data data-size)" "unsigned int *ComputeSHA1(const unsigned char *data, int dataSize)" "Compute SHA1 hash code, returns static int[5] (20 bytes)"
     "(compute-sha1 bytes byte-count)")
    ("(compute-sha256 data data-size)" "unsigned int *ComputeSHA256(const unsigned char *data, int dataSize)" "Compute SHA256 hash code, returns static int[8] (32 bytes)"
     "(compute-sha256 bytes byte-count)")
    ("(load-automation-event-list file-name)" "AutomationEventList LoadAutomationEventList(const char *fileName)" "Load automation events list from file, NULL for empty list, capacity = MAX_AUTOMATION_EVENTS"
     "(load-automation-event-list (cffi:null-pointer))")
    ("(unload-automation-event-list list)" "void UnloadAutomationEventList(AutomationEventList list)" "Unload automation events list from file"
     "(unload-automation-event-list events)")
    ("(export-automation-event-list list file-name)" "bool ExportAutomationEventList(AutomationEventList list, const char *fileName)" "Export automation events list as text file"
     "(export-automation-event-list events \"replay.rae\")")
    ("(set-automation-event-list list)" "void SetAutomationEventList(AutomationEventList *list)" "Set automation event list to record to"
     "(set-automation-event-list event-list-pointer)")
    ("(set-automation-event-base-frame frame)" "void SetAutomationEventBaseFrame(int frame)" "Set automation event internal base frame to start recording"
     "(set-automation-event-base-frame 0)")
    ("(start-automation-event-recording)" "void StartAutomationEventRecording(void)" "Start recording automation events (AutomationEventList must be set)"
     "(start-automation-event-recording)")
    ("(stop-automation-event-recording)" "void StopAutomationEventRecording(void)" "Stop recording automation events"
     "(stop-automation-event-recording)")
    ("(play-automation-event event)" "void PlayAutomationEvent(AutomationEvent event)" "Play a recorded automation event"
     "(play-automation-event event)")
    ("(key-pressed-p key)" "bool IsKeyPressed(int key)" "Check if key has been pressed once"
     "(key-pressed-p :space)")
    ("(is-key-pressed-repeat key)" "bool IsKeyPressedRepeat(int key)" "Check if key has been pressed again"
     "(is-key-pressed-repeat :space)")
    ("(key-down-p key)" "bool IsKeyDown(int key)" "Check if key is being pressed"
     "(key-down-p :space)")
    ("(is-key-released key)" "bool IsKeyReleased(int key)" "Check if key has been released once"
     "(is-key-released :space)")
    ("(is-key-up key)" "bool IsKeyUp(int key)" "Check if key is NOT being pressed"
     "(is-key-up :space)")
    ("(get-key-pressed)" "int GetKeyPressed(void)" "Get key pressed (keycode), call it multiple times for keys queued, returns 0 when the queue is empty"
     "(get-key-pressed)")
    ("(get-char-pressed)" "int GetCharPressed(void)" "Get char pressed (unicode), call it multiple times for chars queued, returns 0 when the queue is empty"
     "(get-char-pressed)")
    ("(get-key-name key)" "const char *GetKeyName(int key)" "Get name of a QWERTY key on the current keyboard layout (eg returns string 'q' for KEY_A on an AZERTY keyboard)"
     "(get-key-name :a)")
    ("(set-exit-key key)" "void SetExitKey(int key)" "Set a custom key to exit program (default is ESC)"
     "(set-exit-key :escape)")
    ("(gamepad-available-p gamepad)" "bool IsGamepadAvailable(int gamepad)" "Check if gamepad is available"
     "(gamepad-available-p 0)")
    ("(get-gamepad-name gamepad)" "const char *GetGamepadName(int gamepad)" "Get gamepad internal name id"
     "(get-gamepad-name 0)")
    ("(gamepad-button-pressed-p gamepad button)" "bool IsGamepadButtonPressed(int gamepad, int button)" "Check if gamepad button has been pressed once"
     "(gamepad-button-pressed-p 0 :right-face-down)")
    ("(is-gamepad-button-down gamepad button)" "bool IsGamepadButtonDown(int gamepad, int button)" "Check if gamepad button is being pressed"
     "(is-gamepad-button-down 0 :right-face-down)")
    ("(is-gamepad-button-released gamepad button)" "bool IsGamepadButtonReleased(int gamepad, int button)" "Check if gamepad button has been released once"
     "(is-gamepad-button-released 0 :right-face-down)")
    ("(is-gamepad-button-up gamepad button)" "bool IsGamepadButtonUp(int gamepad, int button)" "Check if gamepad button is NOT being pressed"
     "(is-gamepad-button-up 0 :right-face-down)")
    ("(get-gamepad-button-pressed)" "int GetGamepadButtonPressed(void)" "Get the last gamepad button pressed"
     "(get-gamepad-button-pressed)")
    ("(get-gamepad-axis-count gamepad)" "int GetGamepadAxisCount(int gamepad)" "Get axis count for a gamepad"
     "(get-gamepad-axis-count 0)")
    ("(get-gamepad-axis-movement gamepad axis)" "float GetGamepadAxisMovement(int gamepad, int axis)" "Get movement value for a gamepad axis"
     "(get-gamepad-axis-movement 0 :left-x)")
    ("(set-gamepad-mappings mappings)" "int SetGamepadMappings(const char *mappings)" "Set internal gamepad mappings (SDL_GameControllerDB)"
     "(set-gamepad-mappings mappings-text)")
    ("(set-gamepad-vibration gamepad left-motor right-motor duration)" "void SetGamepadVibration(int gamepad, float leftMotor, float rightMotor, float duration)" "Set gamepad vibration for both motors (duration in seconds)"
     "(set-gamepad-vibration 0 0.25f0 0.5f0 0.2f0)")
    ("(mouse-button-pressed-p button)" "bool IsMouseButtonPressed(int button)" "Check if mouse button has been pressed once"
     "(mouse-button-pressed-p :left)")
    ("(mouse-button-down-p button)" "bool IsMouseButtonDown(int button)" "Check if mouse button is being pressed"
     "(mouse-button-down-p :left)")
    ("(is-mouse-button-released button)" "bool IsMouseButtonReleased(int button)" "Check if mouse button has been released once"
     "(is-mouse-button-released :left)")
    ("(is-mouse-button-up button)" "bool IsMouseButtonUp(int button)" "Check if mouse button is NOT being pressed"
     "(is-mouse-button-up :left)")
    ("(get-mouse-x)" "int GetMouseX(void)" "Get mouse position X"
     "(get-mouse-x)")
    ("(get-mouse-y)" "int GetMouseY(void)" "Get mouse position Y"
     "(get-mouse-y)")
    ("(get-mouse-position)" "Vector2 GetMousePosition(void)" "Get mouse position XY"
     "(get-mouse-position)")
    ("(get-mouse-delta)" "Vector2 GetMouseDelta(void)" "Get mouse delta between frames"
     "(get-mouse-delta)")
    ("(set-mouse-position x y)" "void SetMousePosition(int x, int y)" "Set mouse position XY"
     "(set-mouse-position 360 210)")
    ("(set-mouse-offset offset-x offset-y)" "void SetMouseOffset(int offsetX, int offsetY)" "Set mouse offset"
     "(set-mouse-offset 0 0)")
    ("(set-mouse-scale scale-x scale-y)" "void SetMouseScale(float scaleX, float scaleY)" "Set mouse scaling"
     "(set-mouse-scale 1f0 1f0)")
    ("(get-mouse-wheel-move)" "float GetMouseWheelMove(void)" "Get mouse wheel movement for X or Y, whichever is larger"
     "(get-mouse-wheel-move)")
    ("(get-mouse-wheel-move-v)" "Vector2 GetMouseWheelMoveV(void)" "Get mouse wheel movement for both X and Y"
     "(get-mouse-wheel-move-v)")
    ("(set-mouse-cursor cursor)" "void SetMouseCursor(int cursor)" "Set mouse cursor"
     "(set-mouse-cursor :crosshair)")
    ("(get-touch-x)" "int GetTouchX(void)" "Get touch position X for touch point 0 (relative to screen size)"
     "(get-touch-x)")
    ("(get-touch-y)" "int GetTouchY(void)" "Get touch position Y for touch point 0 (relative to screen size)"
     "(get-touch-y)")
    ("(get-touch-position index)" "Vector2 GetTouchPosition(int index)" "Get touch position XY for a touch point index (relative to screen size)"
     "(get-touch-position 0)")
    ("(get-touch-point-id index)" "int GetTouchPointId(int index)" "Get touch point identifier for provided index"
     "(get-touch-point-id 0)")
    ("(get-touch-point-count)" "int GetTouchPointCount(void)" "Get number of touch points"
     "(get-touch-point-count)")))

(defparameter *shapes-2d-guide*
  '(
    ("(set-shapes-texture texture rec)" "void SetShapesTexture(Texture2D texture, Rectangle rec)" "Set texture and rectangle to be used on shapes drawing"
     "(set-shapes-texture (get-shapes-texture) (get-shapes-texture-rectangle))")
    ("(get-shapes-texture)" "Texture2D GetShapesTexture(void)" "Get texture that is used for shapes drawing"
     "(get-shapes-texture)")
    ("(get-shapes-texture-rectangle)" "Rectangle GetShapesTextureRectangle(void)" "Get texture source rectangle that is used for shapes drawing"
     "(get-shapes-texture-rectangle)")
    ("(draw-pixel pos-x pos-y color)" "void DrawPixel(int posX, int posY, Color color)" "Draw a pixel using geometry [Can be slow, use with care]"
     "(draw-pixel 360 210 blue)")
    ("(draw-pixel-v position color)" "void DrawPixelV(Vector2 position, Color color)" "Draw a pixel using geometry (Vector version) [Can be slow, use with care]"
     "(draw-pixel-v center blue)")
    ("(draw-line start-pos-x start-pos-y end-pos-x end-pos-y color)" "void DrawLine(int startPosX, int startPosY, int endPosX, int endPosY, Color color)" "Draw a line"
     "(draw-line 240 250 480 150 blue)")
    ("(draw-line-v start-pos end-pos color)" "void DrawLineV(Vector2 startPos, Vector2 endPos, Color color)" "Draw a line (using gl lines)"
     "(draw-line-v a c blue)")
    ("(draw-line-ex start-pos end-pos thick color)" "void DrawLineEx(Vector2 startPos, Vector2 endPos, float thick, Color color)" "Draw a line (using triangles/quads)"
     "(draw-line-ex a c 5f0 blue)")
    ("(draw-line-strip points color)" "void DrawLineStrip(const Vector2 *points, int pointCount, Color color)" "Draw lines sequence (using gl lines)"
     "(draw-line-strip points blue)")
    ("(draw-line-bezier start-pos end-pos thick color)" "void DrawLineBezier(Vector2 startPos, Vector2 endPos, float thick, Color color)" "Draw line segment cubic-bezier in-out interpolation"
     "(draw-line-bezier a c 5f0 blue)")
    ("(draw-line-dashed start-pos end-pos dash-size space-size color)" "void DrawLineDashed(Vector2 startPos, Vector2 endPos, int dashSize, int spaceSize, Color color)" "Draw a dashed line"
     "(draw-line-dashed a c 12 8 blue)")
    ("(draw-triangle v1 v2 v3 color)" "void DrawTriangle(Vector2 v1, Vector2 v2, Vector2 v3, Color color)" "Draw a color-filled triangle, counter-clockwise vertex order"
     "(draw-triangle b a c blue)")
    ("(draw-triangle-gradient v1 v2 v3 c1 c2 c3)" "void DrawTriangleGradient(Vector2 v1, Vector2 v2, Vector2 v3, Color c1, Color c2, Color c3)" "Draw triangle with interpolated colors, counter-clockwise vertex/color order"
     "(draw-triangle-gradient b a c blue orange green)")
    ("(draw-triangle-lines v1 v2 v3 color)" "void DrawTriangleLines(Vector2 v1, Vector2 v2, Vector2 v3, Color color)" "Draw triangle outline, counter-clockwise vertex order"
     "(draw-triangle-lines b a c blue)")
    ("(draw-triangle-lines-ex v1 v2 v3 thick color)" "void DrawTriangleLinesEx(Vector2 v1, Vector2 v2, Vector2 v3, float thick, Color color)" "Draw triangle outline with line thickness, counter-clockwise vertex order"
     "(draw-triangle-lines-ex b a c 5f0 blue)")
    ("(draw-triangle-fan points color)" "void DrawTriangleFan(const Vector2 *points, int pointCount, Color color)" "Draw a triangle fan defined by points (first vertex is the center)"
     "(draw-triangle-fan fan blue)")
    ("(draw-triangle-strip points color)" "void DrawTriangleStrip(const Vector2 *points, int pointCount, Color color)" "Draw a triangle strip defined by points"
     "(draw-triangle-strip (list b a d c) blue)")
    ("(draw-rectangle pos-x pos-y width height color)" "void DrawRectangle(int posX, int posY, int width, int height, Color color)" "Draw a color-filled rectangle"
     "(draw-rectangle 270 160 180 100 blue)")
    ("(draw-rectangle-v position size color)" "void DrawRectangleV(Vector2 position, Vector2 size, Color color)" "Draw a color-filled rectangle (Vector version)"
     "(draw-rectangle-v corner (vec2 180 100) blue)")
    ("(draw-rectangle-rec rec color)" "void DrawRectangleRec(Rectangle rec, Color color)" "Draw a color-filled rectangle"
     "(draw-rectangle-rec box blue)")
    ("(draw-rectangle-pro rec origin rotation color)" "void DrawRectanglePro(Rectangle rec, Vector2 origin, float rotation, Color color)" "Draw a color-filled rectangle with pro parameters"
     "(draw-rectangle-pro box (vec2 0 0) 18f0 blue)")
    ("(draw-rectangle-gradient-v pos-x pos-y width height top bottom)" "void DrawRectangleGradientV(int posX, int posY, int width, int height, Color top, Color bottom)" "Draw a vertical-gradient-filled rectangle"
     "(draw-rectangle-gradient-v 270 160 180 100 orange blue)")
    ("(draw-rectangle-gradient-h pos-x pos-y width height left right)" "void DrawRectangleGradientH(int posX, int posY, int width, int height, Color left, Color right)" "Draw a horizontal-gradient-filled rectangle"
     "(draw-rectangle-gradient-h 270 160 180 100 green blue)")
    ("(draw-rectangle-gradient-ex rec col1 col2 col3 col4)" "void DrawRectangleGradientEx(Rectangle rec, Color col1, Color col2, Color col3, Color col4)" "Draw a gradient-filled rectangle with custom vertex colors, counter-clockwise color order"
     "(draw-rectangle-gradient-ex box blue orange green orange)")
    ("(draw-rectangle-lines pos-x pos-y width height color)" "void DrawRectangleLines(int posX, int posY, int width, int height, Color color)" "Draw rectangle outline"
     "(draw-rectangle-lines 270 160 180 100 blue)")
    ("(draw-rectangle-lines-ex rec thick color)" "void DrawRectangleLinesEx(Rectangle rec, float thick, Color color)" "Draw rectangle outline with line thickness"
     "(draw-rectangle-lines-ex box 5f0 blue)")
    ("(draw-rectangle-rounded rec roundness segments color)" "void DrawRectangleRounded(Rectangle rec, float roundness, int segments, Color color)" "Draw rectangle with rounded edges"
     "(draw-rectangle-rounded box 0.45f0 48 blue)")
    ("(draw-rectangle-rounded-lines rec roundness segments color)" "void DrawRectangleRoundedLines(Rectangle rec, float roundness, int segments, Color color)" "Draw rectangle lines with rounded edges"
     "(draw-rectangle-rounded-lines box 0.45f0 48 blue)")
    ("(draw-rectangle-rounded-lines-ex rec roundness segments thick color)" "void DrawRectangleRoundedLinesEx(Rectangle rec, float roundness, int segments, float thick, Color color)" "Draw rectangle lines with rounded edges outline and line thickness"
     "(draw-rectangle-rounded-lines-ex box 0.45f0 48 5f0 blue)")
    ("(draw-poly center sides radius rotation color)" "void DrawPoly(Vector2 center, int sides, float radius, float rotation, Color color)" "Draw a polygon of n sides"
     "(draw-poly center 8 75f0 18f0 blue)")
    ("(draw-poly-lines center sides radius rotation color)" "void DrawPolyLines(Vector2 center, int sides, float radius, float rotation, Color color)" "Draw a polygon outline of n sides"
     "(draw-poly-lines center 8 75f0 18f0 blue)")
    ("(draw-poly-lines-ex center sides radius rotation thick color)" "void DrawPolyLinesEx(Vector2 center, int sides, float radius, float rotation, float thick, Color color)" "Draw a polygon outline of n sides with line thickness"
     "(draw-poly-lines-ex center 8 75f0 18f0 5f0 blue)")
    ("(draw-circle center-x center-y radius color)" "void DrawCircle(int centerX, int centerY, float radius, Color color)" "Draw a color-filled circle"
     "(draw-circle 360 210 75f0 blue)")
    ("(draw-circle-v center radius color)" "void DrawCircleV(Vector2 center, float radius, Color color)" "Draw a color-filled circle (Vector version)"
     "(draw-circle-v center 75f0 blue)")
    ("(draw-circle-gradient center radius inner outer)" "void DrawCircleGradient(Vector2 center, float radius, Color inner, Color outer)" "Draw a gradient-filled circle"
     "(draw-circle-gradient center 75f0 orange blue)")
    ("(draw-circle-sector center radius start-angle end-angle segments color)" "void DrawCircleSector(Vector2 center, float radius, float startAngle, float endAngle, int segments, Color color)" "Draw a piece of a circle"
     "(draw-circle-sector center 75f0 20f0 310f0 48 blue)")
    ("(draw-circle-sector-lines center radius start-angle end-angle segments color)" "void DrawCircleSectorLines(Vector2 center, float radius, float startAngle, float endAngle, int segments, Color color)" "Draw circle sector outline"
     "(draw-circle-sector-lines center 75f0 20f0 310f0 48 blue)")
    ("(draw-circle-sector-lines-ex center radius start-angle end-angle segments thick color)" "void DrawCircleSectorLinesEx(Vector2 center, float radius, float startAngle, float endAngle, int segments, float thick, Color color)" "Draw circle sector outline with thickness"
     "(draw-circle-sector-lines-ex center 75f0 20f0 310f0 48 5f0 blue)")
    ("(draw-circle-lines center-x center-y radius color)" "void DrawCircleLines(int centerX, int centerY, float radius, Color color)" "Draw circle outline"
     "(draw-circle-lines 360 210 75f0 blue)")
    ("(draw-circle-lines-v center radius color)" "void DrawCircleLinesV(Vector2 center, float radius, Color color)" "Draw circle outline (Vector version)"
     "(draw-circle-lines-v center 75f0 blue)")
    ("(draw-circle-lines-ex center radius thick color)" "void DrawCircleLinesEx(Vector2 center, float radius, float thick, Color color)" "Draw circle outline with line thickness"
     "(draw-circle-lines-ex center 75f0 5f0 blue)")
    ("(draw-ellipse center-x center-y radius-h radius-v color)" "void DrawEllipse(int centerX, int centerY, float radiusH, float radiusV, Color color)" "Draw ellipse"
     "(draw-ellipse 360 210 110f0 55f0 blue)")
    ("(draw-ellipse-v center radius-h radius-v color)" "void DrawEllipseV(Vector2 center, float radiusH, float radiusV, Color color)" "Draw ellipse (Vector version)"
     "(draw-ellipse-v center 110f0 55f0 blue)")
    ("(draw-ellipse-lines center-x center-y radius-h radius-v color)" "void DrawEllipseLines(int centerX, int centerY, float radiusH, float radiusV, Color color)" "Draw ellipse outline"
     "(draw-ellipse-lines 360 210 110f0 55f0 blue)")
    ("(draw-ellipse-lines-v center radius-h radius-v color)" "void DrawEllipseLinesV(Vector2 center, float radiusH, float radiusV, Color color)" "Draw ellipse outline (Vector version)"
     "(draw-ellipse-lines-v center 110f0 55f0 blue)")
    ("(draw-ellipse-lines-ex center radius-h radius-v thick color)" "void DrawEllipseLinesEx(Vector2 center, float radiusH, float radiusV, float thick, Color color)" "Draw ellipse outline with line thickness"
     "(draw-ellipse-lines-ex center 110f0 55f0 5f0 blue)")
    ("(draw-ring center inner-radius outer-radius start-angle end-angle segments color)" "void DrawRing(Vector2 center, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments, Color color)" "Draw ring"
     "(draw-ring center 45f0 85f0 20f0 310f0 48 blue)")
    ("(draw-ring-lines center inner-radius outer-radius start-angle end-angle segments color)" "void DrawRingLines(Vector2 center, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments, Color color)" "Draw ring outline"
     "(draw-ring-lines center 45f0 85f0 20f0 310f0 48 blue)")
    ("(draw-ring-lines-ex center inner-radius outer-radius start-angle end-angle segments thick color)" "void DrawRingLinesEx(Vector2 center, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments, float thick, Color color)" "Draw ring outline with line thickness"
     "(draw-ring-lines-ex center 45f0 85f0 20f0 310f0 48 5f0 blue)")
    ("(draw-spline-linear points thick color)" "void DrawSplineLinear(const Vector2 *points, int pointCount, float thick, Color color)" "Draw spline: Linear, minimum 2 points"
     "(draw-spline-linear points 5f0 blue)")
    ("(draw-spline-basis points thick color)" "void DrawSplineBasis(const Vector2 *points, int pointCount, float thick, Color color)" "Draw spline: B-Spline, minimum 4 points"
     "(draw-spline-basis points 5f0 blue)")
    ("(draw-spline-catmull-rom points thick color)" "void DrawSplineCatmullRom(const Vector2 *points, int pointCount, float thick, Color color)" "Draw spline: Catmull-Rom, minimum 4 points"
     "(draw-spline-catmull-rom points 5f0 blue)")
    ("(draw-spline-bezier-quadratic points thick color)" "void DrawSplineBezierQuadratic(const Vector2 *points, int pointCount, float thick, Color color)" "Draw spline: Quadratic Bezier, minimum 3 points (1 control point): [p1, c2, p3, c4...]"
     "(draw-spline-bezier-quadratic points 5f0 blue)")
    ("(draw-spline-bezier-cubic points thick color)" "void DrawSplineBezierCubic(const Vector2 *points, int pointCount, float thick, Color color)" "Draw spline: Cubic Bezier, minimum 4 points (2 control points): [p1, c2, c3, p4, c5, c6...]"
     "(draw-spline-bezier-cubic points 5f0 blue)")
    ("(draw-spline-segment-linear p1 p2 thick color)" "void DrawSplineSegmentLinear(Vector2 p1, Vector2 p2, float thick, Color color)" "Draw spline segment: Linear, 2 points"
     "(draw-spline-segment-linear a b 5f0 blue)")
    ("(draw-spline-segment-basis p1 p2 p3 p4 thick color)" "void DrawSplineSegmentBasis(Vector2 p1, Vector2 p2, Vector2 p3, Vector2 p4, float thick, Color color)" "Draw spline segment: B-Spline, 4 points"
     "(draw-spline-segment-basis a b c d 5f0 blue)")
    ("(draw-spline-segment-catmull-rom p1 p2 p3 p4 thick color)" "void DrawSplineSegmentCatmullRom(Vector2 p1, Vector2 p2, Vector2 p3, Vector2 p4, float thick, Color color)" "Draw spline segment: Catmull-Rom, 4 points"
     "(draw-spline-segment-catmull-rom a b c d 5f0 blue)")
    ("(draw-spline-segment-bezier-quadratic p1 c2 p3 thick color)" "void DrawSplineSegmentBezierQuadratic(Vector2 p1, Vector2 c2, Vector2 p3, float thick, Color color)" "Draw spline segment: Quadratic Bezier, 2 points, 1 control point"
     "(draw-spline-segment-bezier-quadratic a b c 5f0 blue)")
    ("(draw-spline-segment-bezier-cubic p1 c2 c3 p4 thick color)" "void DrawSplineSegmentBezierCubic(Vector2 p1, Vector2 c2, Vector2 c3, Vector2 p4, float thick, Color color)" "Draw spline segment: Cubic Bezier, 2 points, 2 control points"
     "(draw-spline-segment-bezier-cubic a b c d 5f0 blue)")
    ("(get-spline-point-linear start-pos end-pos amount)" "Vector2 GetSplinePointLinear(Vector2 startPos, Vector2 endPos, float t)" "Get (evaluate) spline point: Linear"
     "(get-spline-point-linear start end 0.5f0)")
    ("(get-spline-point-basis p1 p2 p3 p4 amount)" "Vector2 GetSplinePointBasis(Vector2 p1, Vector2 p2, Vector2 p3, Vector2 p4, float t)" "Get (evaluate) spline point: B-Spline"
     "(get-spline-point-basis a b c d 0.5f0)")
    ("(get-spline-point-catmull-rom p1 p2 p3 p4 amount)" "Vector2 GetSplinePointCatmullRom(Vector2 p1, Vector2 p2, Vector2 p3, Vector2 p4, float t)" "Get (evaluate) spline point: Catmull-Rom"
     "(get-spline-point-catmull-rom a b c d 0.5f0)")
    ("(get-spline-point-bezier-quadratic p1 c2 p3 amount)" "Vector2 GetSplinePointBezierQuadratic(Vector2 p1, Vector2 c2, Vector2 p3, float t)" "Get (evaluate) spline point: Quadratic Bezier"
     "(get-spline-point-bezier-quadratic start control end 0.5f0)")
    ("(get-spline-point-bezier-cubic p1 c2 c3 p4 amount)" "Vector2 GetSplinePointBezierCubic(Vector2 p1, Vector2 c2, Vector2 c3, Vector2 p4, float t)" "Get (evaluate) spline point: Cubic Bezier"
     "(get-spline-point-bezier-cubic a b c d 0.5f0)")
    ("(check-collision-recs rec1 rec2)" "bool CheckCollisionRecs(Rectangle rec1, Rectangle rec2)" "Check collision between two rectangles"
     "(check-collision-recs cursor target)")
    ("(check-collision-circles center1 radius1 center2 radius2)" "bool CheckCollisionCircles(Vector2 center1, float radius1, Vector2 center2, float radius2)" "Check collision between two circles"
     "(check-collision-circles (vec2 10 10) 5f0 (vec2 16 10) 4f0)")
    ("(check-collision-circle-rec center radius rec)" "bool CheckCollisionCircleRec(Vector2 center, float radius, Rectangle rec)" "Check collision between circle and rectangle"
     "(check-collision-circle-rec (get-mouse-position) 8f0 target)")
    ("(check-collision-circle-line center radius p1 p2)" "bool CheckCollisionCircleLine(Vector2 center, float radius, Vector2 p1, Vector2 p2)" "Check if circle collides with a line created between two points [p1] and [p2]"
     "(check-collision-circle-line (get-mouse-position) 8f0 start end)")
    ("(check-collision-point-rec point rec)" "bool CheckCollisionPointRec(Vector2 point, Rectangle rec)" "Check if point is inside rectangle"
     "(check-collision-point-rec (get-mouse-position) target)")
    ("(check-collision-point-circle point center radius)" "bool CheckCollisionPointCircle(Vector2 point, Vector2 center, float radius)" "Check if point is inside circle"
     "(check-collision-point-circle (get-mouse-position) (vec2 320 200) 50f0)")
    ("(check-collision-point-triangle point p1 p2 p3)" "bool CheckCollisionPointTriangle(Vector2 point, Vector2 p1, Vector2 p2, Vector2 p3)" "Check if point is inside a triangle"
     "(check-collision-point-triangle (get-mouse-position) a b c)")
    ("(check-collision-point-line point p1 p2 threshold)" "bool CheckCollisionPointLine(Vector2 point, Vector2 p1, Vector2 p2, int threshold)" "Check if point belongs to line created between two points [p1] and [p2] with defined margin in pixels [threshold]"
     "(check-collision-point-line (get-mouse-position) start end 4)")
    ("(check-collision-point-poly point points point-count)" "bool CheckCollisionPointPoly(Vector2 point, const Vector2 *points, int pointCount)" "Check if point is within a polygon described by array of vertices"
     "(check-collision-point-poly (get-mouse-position) vertices vertex-count)")
    ("(check-collision-lines start-pos1 end-pos1 start-pos2 end-pos2 collision-point)" "bool CheckCollisionLines(Vector2 startPos1, Vector2 endPos1, Vector2 startPos2, Vector2 endPos2, Vector2 *collisionPoint)" "Check the collision between two lines defined by two points each, returns collision point by reference"
     "(check-collision-lines a b c d point-out)")
    ("(get-collision-rec rec1 rec2)" "Rectangle GetCollisionRec(Rectangle rec1, Rectangle rec2)" "Get collision rectangle for two rectangles collision"
     "(get-collision-rec cursor target)")))

(defparameter *fonts-guide*
  '(
    ("(get-font-default)" "Font GetFontDefault(void)" "Get the default Font"
     "(get-font-default)")
    ("(load-font file-name)" "Font LoadFont(const char *fileName)" "Load font from file into GPU memory (VRAM)"
     "(load-font \"title.ttf\")")
    ("(load-font-ex file-name font-size codepoints codepoint-count)" "Font LoadFontEx(const char *fileName, int fontSize, const int *codepoints, int codepointCount)" "Load font from file with defined codepoints and generation size, use NULL for codepoints and 0 for codepointCount to load the default character set, font size is provided in pixels height"
     "(load-font-ex \"title.ttf\" 40 (cffi:null-pointer) 0)")
    ("(load-font-from-image image key first-char)" "Font LoadFontFromImage(Image image, Color key, int firstChar)" "Load font from Image (XNA style)"
     "(load-font-from-image atlas-image (color 255 0 255) 32)")
    ("(load-font-from-memory file-type file-data data-size font-size codepoints codepoint-count)" "Font LoadFontFromMemory(const char *fileType, const unsigned char *fileData, int dataSize, int fontSize, const int *codepoints, int codepointCount)" "Load font from memory buffer, fileType refers to extension: i.e. '.ttf'"
     "(load-font-from-memory \".ttf\" bytes byte-count 32 (cffi:null-pointer) 0)")
    ("(is-font-valid font)" "bool IsFontValid(Font font)" "Check if font is valid (font data loaded, WARNING: GPU texture not checked)"
     "(is-font-valid font)")
    ("(load-font-data file-data data-size font-size codepoints codepoint-count type glyph-count)" "GlyphInfo *LoadFontData(const unsigned char *fileData, int dataSize, int fontSize, const int *codepoints, int codepointCount, int type, int *glyphCount)" "Load font data for further use"
     "(load-font-data bytes byte-count 32 (cffi:null-pointer) 0 :default count-out)")
    ("(gen-image-font-atlas glyphs glyph-recs glyph-count font-size padding pack-method)" "Image GenImageFontAtlas(const GlyphInfo *glyphs, Rectangle **glyphRecs, int glyphCount, int fontSize, int padding, int packMethod)" "Generate image font atlas using chars info"
     "(gen-image-font-atlas glyphs rectangles-out glyph-count 32 2 0)")
    ("(unload-font-data glyphs glyph-count)" "void UnloadFontData(GlyphInfo *glyphs, int glyphCount)" "Unload font chars info data (RAM)"
     "(unload-font-data glyphs glyph-count)")
    ("(unload-font font)" "void UnloadFont(Font font)" "Unload font from GPU memory (VRAM)"
     "(unload-font font)")
    ("(export-font-as-code font file-name)" "bool ExportFontAsCode(Font font, const char *fileName)" "Export font as code file, returns true on success"
     "(export-font-as-code font \"title.h\")")
    ("(draw-fps pos-x pos-y)" "void DrawFPS(int posX, int posY)" "Draw current FPS"
     "(draw-fps 16 16)")
    ("(draw-text text pos-x pos-y font-size color)" "void DrawText(const char *text, int posX, int posY, int fontSize, Color color)" "Draw text (using default font)"
     "(draw-text \"Hello!\" 16 16 20 ink)")
    ("(draw-text-ex font text position font-size spacing tint)" "void DrawTextEx(Font font, const char *text, Vector2 position, float fontSize, float spacing, Color tint)" "Draw text using font and additional parameters"
     "(draw-text-ex font \"Hello!\" (vec2 16 16) 32f0 1f0 ink)")
    ("(draw-text-pro font text position origin rotation font-size spacing tint)" "void DrawTextPro(Font font, const char *text, Vector2 position, Vector2 origin, float rotation, float fontSize, float spacing, Color tint)" "Draw text using Font and pro parameters (rotation)"
     "(draw-text-pro font \"Hello!\" (vec2 80 80) (vec2 0 0) 15f0 32f0 1f0 ink)")
    ("(draw-text-codepoint font codepoint position font-size tint)" "void DrawTextCodepoint(Font font, int codepoint, Vector2 position, float fontSize, Color tint)" "Draw one character (codepoint)"
     "(draw-text-codepoint font (char-code #\\A) (vec2 16 16) 32f0 ink)")
    ("(draw-text-codepoints font codepoints codepoint-count position font-size spacing tint)" "void DrawTextCodepoints(Font font, const int *codepoints, int codepointCount, Vector2 position, float fontSize, float spacing, Color tint)" "Draw multiple characters (codepoint)"
     "(draw-text-codepoints font codes code-count (vec2 16 16) 32f0 1f0 ink)")
    ("(set-text-line-spacing spacing)" "void SetTextLineSpacing(int spacing)" "Set vertical line spacing when drawing with line-breaks"
     "(set-text-line-spacing 24)")
    ("(measure-text text font-size)" "int MeasureText(const char *text, int fontSize)" "Measure string width for default font"
     "(measure-text \"Hello!\" 20)")
    ("(measure-text-ex font text font-size spacing)" "Vector2 MeasureTextEx(Font font, const char *text, float fontSize, float spacing)" "Measure string size for Font"
     "(measure-text-ex font \"Hello!\" 32f0 1f0)")
    ("(measure-text-codepoints font codepoints length font-size spacing)" "Vector2 MeasureTextCodepoints(Font font, const int *codepoints, int length, float fontSize, float spacing)" "Measure string size for an existing array of codepoints for Font"
     "(measure-text-codepoints font codes code-count 32f0 1f0)")
    ("(get-glyph-index font codepoint)" "int GetGlyphIndex(Font font, int codepoint)" "Get glyph index position in font for a codepoint (unicode character), fallback to '?' if not found"
     "(get-glyph-index font (char-code #\\A))")
    ("(get-glyph-info font codepoint)" "GlyphInfo GetGlyphInfo(Font font, int codepoint)" "Get glyph font info data for a codepoint (unicode character), fallback to '?' if not found"
     "(get-glyph-info font (char-code #\\A))")
    ("(get-glyph-atlas-rec font codepoint)" "Rectangle GetGlyphAtlasRec(Font font, int codepoint)" "Get glyph rectangle in font atlas for a codepoint (unicode character), fallback to '?' if not found"
     "(get-glyph-atlas-rec font (char-code #\\A))")
    ("(load-utf8 codepoints length)" "char *LoadUTF8(const int *codepoints, int length)" "Load UTF-8 text encoded from codepoints array"
     "(load-utf8 codes code-count)")
    ("(unload-utf8 text)" "void UnloadUTF8(char *text)" "Unload UTF-8 text encoded from codepoints array"
     "(unload-utf8 utf8-buffer)")
    ("(load-codepoints text count)" "int *LoadCodepoints(const char *text, int *count)" "Load all codepoints from a UTF-8 text string, codepoints count returned by parameter"
     "(load-codepoints \"café\" count-out)")
    ("(unload-codepoints codepoints)" "void UnloadCodepoints(int *codepoints)" "Unload codepoints data from memory"
     "(unload-codepoints codes)")
    ("(get-codepoint-count text)" "int GetCodepointCount(const char *text)" "Get total number of codepoints in a UTF-8 encoded string"
     "(get-codepoint-count \"café\")")
    ("(get-codepoint text codepoint-size)" "int GetCodepoint(const char *text, int *codepointSize)" "Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure"
     "(get-codepoint \"é\" size-out)")
    ("(get-codepoint-next text codepoint-size)" "int GetCodepointNext(const char *text, int *codepointSize)" "Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure"
     "(get-codepoint-next \"é\" size-out)")
    ("(get-codepoint-previous text codepoint-size)" "int GetCodepointPrevious(const char *text, int *codepointSize)" "Get previous codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure"
     "(get-codepoint-previous end-pointer size-out)")
    ("(codepoint-to-utf8 codepoint utf8-size)" "const char *CodepointToUTF8(int codepoint, int *utf8Size)" "Encode one codepoint into UTF-8 byte array (array length returned as parameter)"
     "(codepoint-to-utf8 (char-code #\\A) size-out)")
    ("(load-text-lines text count)" "char **LoadTextLines(const char *text, int *count)" "Load text as separate lines ('\\n')"
     "(load-text-lines \"First line\" count-out)")
    ("(unload-text-lines text line-count)" "void UnloadTextLines(char **text, int lineCount)" "Unload text lines"
     "(unload-text-lines lines line-count)")
    ("(text-copy dst src)" "int TextCopy(char *dst, const char *src)" "Copy one string to another, returns bytes copied"
     "(text-copy destination \"Hello\")")
    ("(text-is-equal text1 text2)" "bool TextIsEqual(const char *text1, const char *text2)" "Check if two text strings are equal"
     "(text-is-equal \"one\" \"two\")")
    ("(text-length text)" "unsigned int TextLength(const char *text)" "Get text length, checks for '\\0' ending"
     "(text-length \"café\")")
    ("(text-format text typed-varargs...)" "const char *TextFormat(const char *text, ...)" "Text formatting with variables (sprintf() style)"
     "(text-format \"Score: %d\" :int 42)")
    ("(text-subtext text position length)" "const char *TextSubtext(const char *text, int position, int length)" "Get a piece of a text string"
     "(text-subtext \"raylib\" 0 3)")
    ("(text-remove-spaces text)" "const char *TextRemoveSpaces(const char *text)" "Remove text spaces, concat words"
     "(text-remove-spaces \"hello world\")")
    ("(get-text-between text begin end)" "char *GetTextBetween(const char *text, const char *begin, const char *end)" "Get text between two strings"
     "(get-text-between \"[gold]\" \"[\" \"]\")")
    ("(text-replace text search replacement)" "char *TextReplace(const char *text, const char *search, const char *replacement)" "Replace text string with new string"
     "(text-replace \"hello world\" \"world\" \"Lisp\")")
    ("(text-replace-alloc text search replacement)" "char *TextReplaceAlloc(const char *text, const char *search, const char *replacement)" "Replace text string with new string, memory must be MemFree()"
     "(text-replace-alloc \"hello world\" \"world\" \"Lisp\")")
    ("(text-replace-between text begin end replacement)" "char *TextReplaceBetween(const char *text, const char *begin, const char *end, const char *replacement)" "Replace text between two specific strings"
     "(text-replace-between \"a[old]b\" \"[\" \"]\" \"new\")")
    ("(text-replace-between-alloc text begin end replacement)" "char *TextReplaceBetweenAlloc(const char *text, const char *begin, const char *end, const char *replacement)" "Replace text between two specific strings, memory must be MemFree()"
     "(text-replace-between-alloc \"a[old]b\" \"[\" \"]\" \"new\")")
    ("(text-insert text insert position)" "char *TextInsert(const char *text, const char *insert, int position)" "Insert text in a defined byte position"
     "(text-insert \"raylib\" \"-\" 3)")
    ("(text-insert-alloc text insert position)" "char *TextInsertAlloc(const char *text, const char *insert, int position)" "Insert text in a defined byte position, memory must be MemFree()"
     "(text-insert-alloc \"raylib\" \"-\" 3)")
    ("(text-join text-list count delimiter)" "char *TextJoin(char **textList, int count, const char *delimiter)" "Join text strings with delimiter"
     "(text-join string-pointers string-count \", \")")
    ("(text-split text delimiter count)" "char **TextSplit(const char *text, char delimiter, int *count)" "Split text into multiple strings, using MAX_TEXTSPLIT_COUNT static strings"
     "(text-split \"red,blue\" (char-code #\\,) count-out)")
    ("(text-append text append position)" "void TextAppend(char *text, const char *append, int *position)" "Append text at specific position and move cursor"
     "(text-append destination \"!\" position-out)")
    ("(text-find-index text search)" "int TextFindIndex(const char *text, const char *search)" "Find first text occurrence within a string, -1 if not found"
     "(text-find-index \"raylib\" \"lib\")")
    ("(text-to-upper text)" "char *TextToUpper(const char *text)" "Get upper case version of provided string"
     "(text-to-upper \"Hello world\")")
    ("(text-to-lower text)" "char *TextToLower(const char *text)" "Get lower case version of provided string"
     "(text-to-lower \"Hello world\")")
    ("(text-to-pascal text)" "char *TextToPascal(const char *text)" "Get Pascal case notation version of provided string"
     "(text-to-pascal \"Hello world\")")
    ("(text-to-snake text)" "char *TextToSnake(const char *text)" "Get Snake case notation version of provided string"
     "(text-to-snake \"Hello world\")")
    ("(text-to-camel text)" "char *TextToCamel(const char *text)" "Get Camel case notation version of provided string"
     "(text-to-camel \"Hello world\")")
    ("(text-to-integer text)" "int TextToInteger(const char *text)" "Get integer value from text"
     "(text-to-integer \"42\")")
    ("(text-to-float text)" "float TextToFloat(const char *text)" "Get float value from text"
     "(text-to-float \"3.5\")")))

(defparameter *shapes-3d-guide*
  '(
    ("(draw-line-3d start-pos end-pos color)" "void DrawLine3D(Vector3 startPos, Vector3 endPos, Color color)" "Draw a line in 3D world space"
     "(draw-line-3d (vec3 -1 0 0) (vec3 1 1 0) blue)")
    ("(draw-point-3d position color)" "void DrawPoint3D(Vector3 position, Color color)" "Draw a point in 3D space, actually a small line"
     "(draw-point-3d origin blue)")
    ("(draw-circle-3d center radius rotation-axis rotation-angle color)" "void DrawCircle3D(Vector3 center, float radius, Vector3 rotationAxis, float rotationAngle, Color color)" "Draw a circle in 3D world space"
     "(draw-circle-3d origin 1f0 (vec3 1 0 0) 60f0 blue)")
    ("(draw-triangle-3d v1 v2 v3 color)" "void DrawTriangle3D(Vector3 v1, Vector3 v2, Vector3 v3, Color color)" "Draw a color-filled triangle, counter-clockwise vertex order"
     "(draw-triangle-3d (vec3 -1 -1 0) (vec3 1 -1 0) (vec3 0 1 0) blue)")
    ("(draw-triangle-strip-3d points color)" "void DrawTriangleStrip3D(const Vector3 *points, int pointCount, Color color)" "Draw a triangle strip defined by points"
     "(draw-triangle-strip-3d strip blue)")
    ("(draw-cube position width height length color)" "void DrawCube(Vector3 position, float width, float height, float length, Color color)" "Draw cube"
     "(draw-cube origin 2f0 2f0 2f0 blue)")
    ("(draw-cube-v position size color)" "void DrawCubeV(Vector3 position, Vector3 size, Color color)" "Draw cube (Vector version)"
     "(draw-cube-v origin (vec3 2 2 2) blue)")
    ("(draw-cube-wires position width height length color)" "void DrawCubeWires(Vector3 position, float width, float height, float length, Color color)" "Draw cube wires"
     "(draw-cube-wires origin 2f0 2f0 2f0 blue)")
    ("(draw-cube-wires-v position size color)" "void DrawCubeWiresV(Vector3 position, Vector3 size, Color color)" "Draw cube wires (Vector version)"
     "(draw-cube-wires-v origin (vec3 2 2 2) blue)")
    ("(draw-sphere center-pos radius color)" "void DrawSphere(Vector3 centerPos, float radius, Color color)" "Draw sphere"
     "(draw-sphere origin 1f0 blue)")
    ("(draw-sphere-ex center-pos radius rings slices color)" "void DrawSphereEx(Vector3 centerPos, float radius, int rings, int slices, Color color)" "Draw sphere with defined rings and slices"
     "(draw-sphere-ex origin 1f0 12 16 blue)")
    ("(draw-sphere-wires center-pos radius rings slices color)" "void DrawSphereWires(Vector3 centerPos, float radius, int rings, int slices, Color color)" "Draw sphere wires"
     "(draw-sphere-wires origin 1f0 12 16 blue)")
    ("(draw-cylinder position radius-top radius-bottom height sides color)" "void DrawCylinder(Vector3 position, float radiusTop, float radiusBottom, float height, int sides, Color color)" "Draw a cylinder/cone"
     "(draw-cylinder origin 0.65f0 1f0 2f0 8 blue)")
    ("(draw-cylinder-ex start-pos end-pos start-radius end-radius sides color)" "void DrawCylinderEx(Vector3 startPos, Vector3 endPos, float startRadius, float endRadius, int sides, Color color)" "Draw a cylinder with base at startPos and top at endPos"
     "(draw-cylinder-ex (vec3 -1 0 0) (vec3 1 1 0) 1f0 0.55f0 8 blue)")
    ("(draw-cylinder-wires position radius-top radius-bottom height sides color)" "void DrawCylinderWires(Vector3 position, float radiusTop, float radiusBottom, float height, int sides, Color color)" "Draw a cylinder/cone wires"
     "(draw-cylinder-wires origin 0.65f0 1f0 2f0 8 blue)")
    ("(draw-cylinder-wires-ex start-pos end-pos start-radius end-radius sides color)" "void DrawCylinderWiresEx(Vector3 startPos, Vector3 endPos, float startRadius, float endRadius, int sides, Color color)" "Draw a cylinder wires with base at startPos and top at endPos"
     "(draw-cylinder-wires-ex (vec3 -1 0 0) (vec3 1 1 0) 1f0 0.55f0 8 blue)")
    ("(draw-capsule start-pos end-pos radius rings slices color)" "void DrawCapsule(Vector3 startPos, Vector3 endPos, float radius, int rings, int slices, Color color)" "Draw a capsule with the center of its sphere caps at startPos and endPos"
     "(draw-capsule (vec3 -1 0 0) (vec3 1 1 0) 1f0 12 16 blue)")
    ("(draw-capsule-wires start-pos end-pos radius rings slices color)" "void DrawCapsuleWires(Vector3 startPos, Vector3 endPos, float radius, int rings, int slices, Color color)" "Draw capsule wireframe with the center of its sphere caps at startPos and endPos"
     "(draw-capsule-wires (vec3 -1 0 0) (vec3 1 1 0) 1f0 12 16 blue)")
    ("(draw-plane center-pos size color)" "void DrawPlane(Vector3 centerPos, Vector2 size, Color color)" "Draw a plane XZ"
     "(draw-plane origin (vec2 2 3) blue)")
    ("(draw-ray ray color)" "void DrawRay(Ray ray, Color color)" "Draw a ray line"
     "(draw-ray (ray (vec3 0 0 0) (vec3 1 0 0)) blue)")
    ("(draw-grid slices spacing)" "void DrawGrid(int slices, float spacing)" "Draw a grid (centered at (0, 0, 0))"
     "(draw-grid 16 1f0)")
    ("(load-model file-name)" "Model LoadModel(const char *fileName)" "Load model from files (meshes and materials)"
     "(load-model \"ship.glb\")")
    ("(load-model-from-mesh mesh)" "Model LoadModelFromMesh(Mesh mesh)" "Load model from generated mesh (default material)"
     "(load-model-from-mesh (gen-mesh-cube 2f0 2f0 2f0))")
    ("(is-model-valid model)" "bool IsModelValid(Model model)" "Check if model is valid (loaded in GPU, VAO/VBOs)"
     "(is-model-valid model)")
    ("(unload-model model)" "void UnloadModel(Model model)" "Unload model (including meshes) from memory (RAM and/or VRAM)"
     "(unload-model model)")
    ("(get-model-bounding-box model)" "BoundingBox GetModelBoundingBox(Model model)" "Compute model bounding box limits (considers all meshes)"
     "(get-model-bounding-box model)")
    ("(draw-model model position scale tint)" "void DrawModel(Model model, Vector3 position, float scale, Color tint)" "Draw a model (with texture if set)"
     "(draw-model model (vec3 0 0 0) 1f0 blue)")
    ("(draw-model-ex model position rotation-axis rotation-angle scale tint)" "void DrawModelEx(Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, Color tint)" "Draw a model with custom transform"
     "(draw-model-ex model (vec3 0 0 0) (vec3 0 1 0) 45f0 (vec3 1 1 1) blue)")
    ("(draw-model-wires model position scale tint)" "void DrawModelWires(Model model, Vector3 position, float scale, Color tint)" "Draw a model wires (with texture if set)"
     "(draw-model-wires model (vec3 0 0 0) 1f0 blue)")
    ("(draw-model-wires-ex model position rotation-axis rotation-angle scale tint)" "void DrawModelWiresEx(Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, Color tint)" "Draw a model wires with custom transform"
     "(draw-model-wires-ex model (vec3 0 0 0) (vec3 0 1 0) 45f0 (vec3 1 1 1) blue)")
    ("(draw-bounding-box box color)" "void DrawBoundingBox(BoundingBox box, Color color)" "Draw bounding box (wires)"
     "(draw-bounding-box (bounding-box (vec3 -1 -1 -1) (vec3 1 1 1)) blue)")
    ("(draw-billboard camera texture position scale tint)" "void DrawBillboard(Camera camera, Texture2D texture, Vector3 position, float scale, Color tint)" "Draw a billboard texture"
     "(draw-billboard camera texture (vec3 0 1 0) 2f0 white)")
    ("(draw-billboard-rec camera texture rec position size tint)" "void DrawBillboardRec(Camera camera, Texture2D texture, Rectangle rec, Vector3 position, Vector2 size, Color tint)" "Draw a billboard texture defined by rectangle"
     "(draw-billboard-rec camera texture source (vec3 0 1 0) (vec2 2 2) white)")
    ("(draw-billboard-pro camera texture rec position up size origin rotation tint)" "void DrawBillboardPro(Camera camera, Texture2D texture, Rectangle rec, Vector3 position, Vector3 up, Vector2 size, Vector2 origin, float rotation, Color tint)" "Draw a billboard texture defined by source rectangle with scaling and rotation"
     "(draw-billboard-pro camera texture source (vec3 0 1 0) (vec3 0 1 0) (vec2 2 2) (vec2 0 0) 0f0 white)")
    ("(upload-mesh mesh dynamic)" "void UploadMesh(Mesh *mesh, bool dynamic)" "Upload mesh vertex data in GPU and provide VAO/VBO ids"
     "(upload-mesh mesh-pointer t)")
    ("(update-mesh-buffer mesh index data data-size offset)" "void UpdateMeshBuffer(Mesh mesh, int index, const void *data, int dataSize, int offset)" "Update mesh vertex data in GPU for a specific buffer index"
     "(update-mesh-buffer mesh 0 vertex-bytes byte-count 0)")
    ("(unload-mesh mesh)" "void UnloadMesh(Mesh mesh)" "Unload mesh data from CPU and GPU"
     "(unload-mesh mesh)")
    ("(draw-mesh mesh material transform)" "void DrawMesh(Mesh mesh, Material material, Matrix transform)" "Draw a 3d mesh with material and transform"
     "(draw-mesh mesh material transform)")
    ("(draw-mesh-instanced mesh material transforms instances)" "void DrawMeshInstanced(Mesh mesh, Material material, const Matrix *transforms, int instances)" "Draw multiple mesh instances with material and different transforms"
     "(draw-mesh-instanced mesh material matrices instance-count)")
    ("(get-mesh-bounding-box mesh)" "BoundingBox GetMeshBoundingBox(Mesh mesh)" "Compute mesh bounding box limits"
     "(get-mesh-bounding-box mesh)")
    ("(gen-mesh-tangents mesh)" "void GenMeshTangents(Mesh *mesh)" "Compute mesh tangents"
     "(gen-mesh-tangents mesh-pointer)")
    ("(export-mesh mesh file-name)" "bool ExportMesh(Mesh mesh, const char *fileName)" "Export mesh data to file, returns true on success"
     "(export-mesh mesh \"shape.obj\")")
    ("(export-mesh-as-code mesh file-name)" "bool ExportMeshAsCode(Mesh mesh, const char *fileName)" "Export mesh as code file (.h) defining multiple arrays of vertex attributes"
     "(export-mesh-as-code mesh \"shape.h\")")
    ("(gen-mesh-poly sides radius)" "Mesh GenMeshPoly(int sides, float radius)" "Generate polygonal mesh"
     "(gen-mesh-poly 6 1f0)")
    ("(gen-mesh-plane width length res-x res-z)" "Mesh GenMeshPlane(float width, float length, int resX, int resZ)" "Generate plane mesh (with subdivisions)"
     "(gen-mesh-plane 4f0 4f0 8 8)")
    ("(gen-mesh-cube width height length)" "Mesh GenMeshCube(float width, float height, float length)" "Generate cuboid mesh"
     "(gen-mesh-cube 2f0 2f0 2f0)")
    ("(gen-mesh-sphere radius rings slices)" "Mesh GenMeshSphere(float radius, int rings, int slices)" "Generate sphere mesh (standard sphere)"
     "(gen-mesh-sphere 1f0 16 24)")
    ("(gen-mesh-hemi-sphere radius rings slices)" "Mesh GenMeshHemiSphere(float radius, int rings, int slices)" "Generate half-sphere mesh (no bottom cap)"
     "(gen-mesh-hemi-sphere 1f0 16 24)")
    ("(gen-mesh-cylinder radius height slices)" "Mesh GenMeshCylinder(float radius, float height, int slices)" "Generate cylinder mesh"
     "(gen-mesh-cylinder 1f0 2f0 24)")
    ("(gen-mesh-cone radius height slices)" "Mesh GenMeshCone(float radius, float height, int slices)" "Generate cone/pyramid mesh"
     "(gen-mesh-cone 1f0 2f0 24)")
    ("(gen-mesh-torus radius size rad-seg sides)" "Mesh GenMeshTorus(float radius, float size, int radSeg, int sides)" "Generate torus mesh"
     "(gen-mesh-torus 0.5f0 2f0 24 32)")
    ("(gen-mesh-knot radius size rad-seg sides)" "Mesh GenMeshKnot(float radius, float size, int radSeg, int sides)" "Generate trefoil knot mesh"
     "(gen-mesh-knot 1f0 0.25f0 48 12)")
    ("(gen-mesh-heightmap heightmap size)" "Mesh GenMeshHeightmap(Image heightmap, Vector3 size)" "Generate heightmap mesh from image data"
     "(gen-mesh-heightmap height-image (vec3 10 3 10))")
    ("(gen-mesh-cubicmap cubicmap cube-size)" "Mesh GenMeshCubicmap(Image cubicmap, Vector3 cubeSize)" "Generate cubes-based map mesh from image data"
     "(gen-mesh-cubicmap map-image (vec3 1 1 1))")
    ("(load-materials file-name material-count)" "Material *LoadMaterials(const char *fileName, int *materialCount)" "Load materials from model file"
     "(load-materials \"ship.mtl\" count-out)")
    ("(load-material-default)" "Material LoadMaterialDefault(void)" "Load default material (Supports: DIFFUSE, SPECULAR, NORMAL maps)"
     "(load-material-default)")
    ("(is-material-valid material)" "bool IsMaterialValid(Material material)" "Check if material is valid (shader assigned, map textures loaded in GPU)"
     "(is-material-valid material)")
    ("(unload-material material)" "void UnloadMaterial(Material material)" "Unload material from GPU memory (VRAM)"
     "(unload-material material)")
    ("(set-material-texture material map-type texture)" "void SetMaterialTexture(Material *material, int mapType, Texture2D texture)" "Set texture for a material map type (MATERIAL_MAP_DIFFUSE, MATERIAL_MAP_SPECULAR...)"
     "(set-material-texture material-pointer :albedo texture)")
    ("(set-model-mesh-material model mesh-id material-id)" "void SetModelMeshMaterial(Model *model, int meshId, int materialId)" "Set material for a mesh"
     "(set-model-mesh-material model-pointer 0 0)")
    ("(load-model-animations file-name anim-count)" "ModelAnimation *LoadModelAnimations(const char *fileName, int *animCount)" "Load model animations from file"
     "(load-model-animations \"character.glb\" count-out)")
    ("(update-model-animation model anim frame)" "void UpdateModelAnimation(Model model, ModelAnimation anim, float frame)" "Update model animation pose (vertex buffers and bone matrices)"
     "(update-model-animation model clip 0f0)")
    ("(update-model-animation-ex model anim-a frame-a anim-b frame-b blend)" "void UpdateModelAnimationEx(Model model, ModelAnimation animA, float frameA, ModelAnimation animB, float frameB, float blend)" "Update model animation pose, blending two animations"
     "(update-model-animation-ex model idle 0f0 walk 5f0 0.5f0)")
    ("(unload-model-animations animations anim-count)" "void UnloadModelAnimations(ModelAnimation *animations, int animCount)" "Unload animation array data"
     "(unload-model-animations animations animation-count)")
    ("(is-model-animation-valid model anim)" "bool IsModelAnimationValid(Model model, ModelAnimation anim)" "Check model animation skeleton match"
     "(is-model-animation-valid model clip)")
    ("(check-collision-spheres center1 radius1 center2 radius2)" "bool CheckCollisionSpheres(Vector3 center1, float radius1, Vector3 center2, float radius2)" "Check collision between two spheres"
     "(check-collision-spheres (vec3 0 0 0) 1f0 (vec3 1 0 0) 1f0)")
    ("(check-collision-boxes box1 box2)" "bool CheckCollisionBoxes(BoundingBox box1, BoundingBox box2)" "Check collision between two bounding boxes"
     "(check-collision-boxes box1 box2)")
    ("(check-collision-box-sphere box center radius)" "bool CheckCollisionBoxSphere(BoundingBox box, Vector3 center, float radius)" "Check collision between box and sphere"
     "(check-collision-box-sphere box (vec3 0 0 0) 1f0)")
    ("(get-ray-collision-sphere ray center radius)" "RayCollision GetRayCollisionSphere(Ray ray, Vector3 center, float radius)" "Get collision info between ray and sphere"
     "(get-ray-collision-sphere ray (vec3 0 0 0) 1f0)")
    ("(get-ray-collision-box ray box)" "RayCollision GetRayCollisionBox(Ray ray, BoundingBox box)" "Get collision info between ray and box"
     "(get-ray-collision-box ray box)")
    ("(get-ray-collision-mesh ray mesh transform)" "RayCollision GetRayCollisionMesh(Ray ray, Mesh mesh, Matrix transform)" "Get collision info between ray and mesh"
     "(get-ray-collision-mesh ray mesh transform)")
    ("(get-ray-collision-triangle ray p1 p2 p3)" "RayCollision GetRayCollisionTriangle(Ray ray, Vector3 p1, Vector3 p2, Vector3 p3)" "Get collision info between ray and triangle"
     "(get-ray-collision-triangle ray a b c)")
    ("(get-ray-collision-quad ray p1 p2 p3 p4)" "RayCollision GetRayCollisionQuad(Ray ray, Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4)" "Get collision info between ray and quad"
     "(get-ray-collision-quad ray a b c d)")))

(defparameter *controllers-guide*
  '(
    ("(update-camera camera mode)" "void UpdateCamera(Camera *camera, int mode)" "Update camera position for selected mode"
     "(update-camera camera-pointer :orbital)")
    ("(update-camera-pro camera movement rotation zoom)" "void UpdateCameraPro(Camera *camera, Vector3 movement, Vector3 rotation, float zoom)" "Update camera movement/rotation"
     "(update-camera-pro camera-pointer (vec3 1 0 0) (vec3 0 0 0) 0f0)")))

(defun lesson-entries (area)
  (ecase area
    (:core *core-guide*)
    (:shapes-2d *shapes-2d-guide*)
    (:fonts *fonts-guide*)
    (:shapes-3d *shapes-3d-guide*)
    (:controllers *controllers-guide*)))

(defun api-guide (area &optional (search-text "") (stream *standard-output*))
  "Print Lisp calls, C signatures and descriptions. Filter by any part of the text."
  (dolist (entry (lesson-entries area))
    (when (some (lambda (text) (search search-text text :test #'char-equal)) entry)
      (destructuring-bind (call prototype description example) entry
        (format stream "~A~%  ~A~%  ~A~%  Example: ~A~%~%" call prototype description example)))))

(defun draw-wrapped-text (text y size tint)
  "Draw whole words on successive lines and return the next available Y."
  (let ((line "") (width (- (get-screen-width) 32)))
    (dolist (word (uiop:split-string text :separator " "))
      (let ((candidate (if (zerop (length line)) word (format nil "~A ~A" line word))))
        (when (and (plusp (length line)) (> (measure-text candidate size) width))
          (draw-text line 16 y size tint)
          (incf y (+ size 5))
          (setf candidate word))
        (setf line candidate)))
    (draw-text line 16 y size tint)
    (+ y size 10)))

(defun draw-api-card (area index entries)
  (destructuring-bind (call prototype description example) (nth index entries)
    (let ((ink (color 30 35 45)) (blue (color 0 90 170)))
      (draw-text (format nil "~A   ~D / ~D" area (1+ index) (length entries)) 16 16 20 ink)
      (let* ((y (draw-wrapped-text call 60 22 blue))
             (y (draw-wrapped-text description (+ y 8) 18 ink))
             (y (draw-wrapped-text (format nil "Example: ~A" example) (+ y 8) 18 blue)))
        (draw-wrapped-text prototype (+ y 10) 16 ink)))))

(defmacro lesson-frames ((area background) &body scene)
  "Give a scene a browsable reference. The scene pauses while its guide is open."
  (let ((show (gensym)) (index (gensym)) (entries (gensym)))
    `(let ((,show nil) (,index 0) (,entries (lesson-entries ,area)))
       (do-frames ,background
         (when-key-pressed :f1 (setf ,show (not ,show)))
         (if ,show
             (progn
               (incf ,index (cond ((key-pressed-p :right) 1)
                                  ((key-pressed-p :left) -1)
                                  ((key-pressed-p :page-down) 10)
                                  ((key-pressed-p :page-up) -10)
                                  (t 0)))
               (setf ,index (mod ,index (length ,entries)))
               (draw-api-card ,area ,index ,entries))
             (progn ,@scene))
         (draw-text (if ,show "F1: scene   Arrows: browse   PgUp/PgDn: jump"
                        "F1: browse this API")
                    16 (- (get-screen-height) 26) 16 (color 30 35 45))))))
