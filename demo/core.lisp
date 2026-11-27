(in-package #:raylisp)

(defun core-demo ()
  "Move with the arrow keys, resize the window, or press R to reset the dot."
  (with-window (720 420 "Core: window, input and time")
    (set-window-state '(:window-resizable))
    (set-window-min-size 400 240)
    (let ((x 100f0) (paper (color 245 245 245)) (ink (color 30 35 45)))
      (lesson-frames (:core paper)
        ;; Pixels per second times seconds per frame gives pixels per frame.
        (let ((step (* 220 (get-frame-time))))
          (when (key-down-p :left) (decf x step))
          (when (key-down-p :right) (incf x step)))
        (when (key-pressed-p :r)
          (setf x (float (get-random-value 12 (- (get-screen-width) 12)) 1f0)))
        (setf x (min (- (get-screen-width) 12) (max 12 x)))
        (draw-circle (round x) (floor (get-screen-height) 2) 12f0 ink)
        (draw-text "Arrows: move   R: random position   Esc: close" 16 16 18 ink)
        (draw-text (format nil "~D x ~D   ~D FPS" (get-screen-width)
                           (get-screen-height) (get-fps)) 16 45 18 ink)))))

;; File data illustrates the ownership rule. The caller supplies a path.
(defun core-read-text (path)
  (let ((buffer (load-file-text (namestring (pathname path)))))
    (unless (cffi:null-pointer-p buffer)
      (unwind-protect (cffi:foreign-string-to-lisp buffer :encoding :utf-8)
        (unload-file-text buffer)))))

;; For every core call, including shaders, automation and file callbacks:
;; (api-guide :core)
;; (api-guide :core "callback")

;; A directory listing is one native allocation with a count and an array of
;; char pointers. Copy the names to Lisp strings before releasing the listing.
(defun directory-names (directory)
  (let ((files (load-directory-files (namestring (pathname directory)))))
    (unwind-protect
         (loop with paths = (struct-field files :paths)
               for i below (struct-field files :count)
               collect (cffi:mem-aref paths :string i))
      (unload-directory-files files))))

;; A file callback runs when raylib asks to save text. This example prints
;; the request and reports success; it is a preview of what would be saved.
(cffi:defcallback preview-text-save (:boolean :uint8) ((path :string) (text :string))
  (format t "~&Save request for ~A (~D characters)~%" path (length text))
  t)

;; In a fresh REPL session, try installing the callback for just one call:
;; (set-save-file-text-callback (cffi:callback preview-text-save))
;; (unwind-protect (save-file-text "example.txt" "Hello")
;;   (set-save-file-text-callback (cffi:null-pointer)))
;;
;; TraceLog and TextFormat follow C's variable-argument convention:
;; (trace-log :info "Score: %d" :int 42)
;; (text-format "%.1f%%" :double 75d0)
