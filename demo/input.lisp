(in-package #:raylisp)

(defun input-demo ()
  "Show the names raylib reports for keys, mouse buttons and gamepad controls."
  (let ((ink (color 30 35 45))
        (paper (color 245 245 245))
        (last-key "none") (last-mouse "none") (last-pad "none")
        (space-presses 0) (wheel 0)
        (buttons (cffi:foreign-enum-keyword-list 'mouse-button))
        (pad-buttons (remove :unknown (cffi:foreign-enum-keyword-list 'gamepad-button)))
        (axes (cffi:foreign-enum-keyword-list 'gamepad-axis)))
    (init-window 720 520 "Input playground")
    (unwind-protect
         (progn
           (set-target-fps 60)
           (loop until (window-should-close-p)
                 do ;; Drain the key queue each frame, retaining the most recent name.
                    (loop for key = (next-key-pressed) while key do (setf last-key key))
                    (when (key-pressed-p :space) (incf space-presses))
                    (incf wheel (get-mouse-wheel-move))
                    (dolist (button buttons)
                      (when (mouse-button-pressed-p button) (setf last-mouse button)))

                    (begin-drawing)
                    (clear-background paper)
                    (draw-text "Keyboard: press any key" 20 20 24 ink)
                    (draw-text (format nil "Last: ~A    Space presses: ~D" last-key space-presses)
                               20 60 20 ink)
                    (draw-text (format nil "Left arrow held: ~A" (key-down-p :left)) 20 88 20 ink)

                    (draw-text "Mouse: press any button, move, or scroll" 20 145 24 ink)
                    (draw-text (format nil "Last: ~A    Position: (~D, ~D)    Wheel: ~,1F"
                                       last-mouse (get-mouse-x) (get-mouse-y) wheel)
                               20 185 20 ink)
                    (draw-text (format nil "Held: ~{~A~^, ~}"
                                       (remove-if-not #'mouse-button-down-p buttons))
                               20 213 20 ink)

                    (draw-text "Gamepad: try buttons, sticks and triggers" 20 270 24 ink)
                    (if (gamepad-available-p 0)
                        (progn
                          (dolist (button pad-buttons)
                            (when (gamepad-button-pressed-p 0 button) (setf last-pad button)))
                          (draw-text (format nil "Last button: ~A" last-pad) 20 310 20 ink)
                          (loop for axis in axes for y from 345 by 25
                                do (draw-text (format nil "~A: ~,2F" axis
                                                      (get-gamepad-axis-movement 0 axis))
                                              20 y 20 ink)))
                        (progn
                          (setf last-pad "none")
                          (draw-text "Connect a gamepad to inspect its controls." 20 310 20 ink)))
                    (end-drawing)))
      (close-window))))
