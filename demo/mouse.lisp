(in-package #:raylisp)

(defun demo ()
  "Draw a circle that follows the mouse. Press Escape to close the window."
  (let ((paper (color 245 245 245))
        (ink (color 30 35 45))
        (blue (color 0 121 241)))
    (init-window 640 400 "Hello from Common Lisp")
    ;; UNWIND-PROTECT also closes the window if you interrupt the loop.
    (unwind-protect
         (progn
           (set-target-fps 60)
           (loop until (window-should-close-p)
                 do (begin-drawing)
                    (clear-background paper)
                    (draw-circle (get-mouse-x) (get-mouse-y) 16.0f0 blue)
                    (draw-text "Move the mouse. Escape to quit." 16 16 20 ink)
                    (end-drawing)))
      (close-window))))
