(in-package #:raylisp)

(defun fonts-demo (&optional path)
  "Center text and inspect glyphs. Optionally pass a path to a TTF or OTF file."
  (with-window (720 420 "Fonts: measure, draw and inspect")
    ;; Raylib owns the default font. A font loaded here must be released
    ;; while the window and its graphics context are still alive.
    (let* ((font (if path (load-font-ex (namestring (pathname path)) 40
                                        (cffi:null-pointer) 0)
                     (get-font-default)))
           (paper (color 245 245 245)) (ink (color 30 35 45))
           (blue (color 0 110 200)) (message "Hello from Common Lisp"))
      (unwind-protect
           (progn
             (unless (is-font-valid font)
               (error "Could not load a drawable font from ~S." path))
             (lesson-frames (:fonts paper)
               (let* ((size (measure-text-ex font message 32f0 1f0))
                      (left (/ (- (get-screen-width) (struct-field size :x)) 2)))
                 (draw-text-ex font message (vec2 left 160) 32f0 1f0 ink))
               (draw-text-codepoint font (char-code #\A) (vec2 20 250) 48f0 blue)
               (draw-text (format nil "Glyph index for A: ~D" (get-glyph-index font 65))
                          85 265 20 ink)
               (draw-text "Measured text stays centered. Esc: close." 16 16 18 ink)))
        (when path (unload-font font))))))

;; Count and decode UTF-8 without a window. The int pointer is an output
;; parameter. Raylib writes the number of codepoints into it.
(defun font-codepoints (text)
  (cffi:with-foreign-object (count :int)
    (let ((codes (load-codepoints text count)))
      (unwind-protect
           (unless (cffi:null-pointer-p codes)
             (loop for i below (cffi:mem-ref count :int)
                   collect (cffi:mem-aref codes :int i)))
        (unload-codepoints codes)))))

;; (api-guide :fonts "glyph")

;; The Alloc variants return native memory. Copy their result to Lisp and
;; release the original with raylib's allocator, including on early exit.
(defun replace-all-text (text old new)
  (let ((buffer (text-replace-alloc text old new)))
    (unless (cffi:null-pointer-p buffer)
      (unwind-protect (cffi:foreign-string-to-lisp buffer :encoding :utf-8)
        (mem-free buffer)))))

;; (font-codepoints "Aλ")             => (65 955)
;; (replace-all-text "a+b+c" "+" "/") => "a/b/c"
