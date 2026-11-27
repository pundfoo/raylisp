(in-package #:raylisp)

(defun camera-2d-demo ()
  "Move the mouse horizontally to pan across a row of blocks."
  (init-window 640 400 "2D camera")
  (unwind-protect
       (progn
         (set-target-fps 60)
         (loop until (window-should-close-p)
               do (begin-drawing)
                  (clear-background (color 245 245 245))
                  ;; The target in world coordinates appears at the screen center.
                  (begin-mode-2d (camera-2d :target (vec2 (get-mouse-x) 0)
                                            :offset (vec2 320 200)))
                  (loop for x from 0 to 640 by 80
                        do (draw-rectangle x -20 40 40 (color 0 121 241)))
                  (end-mode-2d)
                  ;; After leaving camera mode, text uses screen coordinates.
                  (draw-text "Move the mouse to pan" 16 16 20 (color 30 35 45))
                  (end-drawing)))
    (close-window)))

(defun camera-3d-demo ()
  "Move the mouse horizontally to view a cube from different angles."
  (init-window 640 400 "3D camera")
  (unwind-protect
       (progn
         (set-target-fps 60)
         (loop until (window-should-close-p)
               do (begin-drawing)
                  (clear-background (color 245 245 245))
                  ;; Slide the camera sideways while keeping the cube in view.
                  (begin-mode-3d (camera-3d :position (vec3 (/ (- (get-mouse-x) 320) 40) 5 8)
                                            :target (vec3 0 1 0)))
                  (draw-grid 20 1f0)
                  (draw-cube (vec3 0 1 0) 2f0 2f0 2f0 (color 0 121 241))
                  (end-mode-3d)
                  (draw-text "Move the mouse to change viewpoint" 16 16 20 (color 30 35 45))
                  (end-drawing)))
    (close-window)))
