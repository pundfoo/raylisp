(in-package #:raylisp)

(defun controllers-demo ()
  "Press Space to switch between an orbit and manually controlled motion."
  (with-window (720 420 "Camera controllers")
    ;; UpdateCamera takes a pointer because it writes back the new position.
    ;; Keep the same camera in native memory for the whole loop.
    (cffi:with-foreign-object (camera '(:struct camera-3d))
      (setf (cffi:mem-ref camera '(:struct camera-3d))
            (camera-3d :position (vec3 6 4 6) :target (vec3 0 0 0)))
      (let ((manual nil) (paper (color 245 245 245)) (ink (color 30 35 45)))
        (lesson-frames (:controllers paper)
          (when-key-pressed :space (setf manual (not manual)))
          (if manual
              (let ((speed (* 3 (get-frame-time))))
                ;; Movement uses forward, right and up in camera space.
                (update-camera-pro camera
                                   (vec3 0 (cond ((key-down-p :left) (- speed))
                                                 ((key-down-p :right) speed)
                                                 (t 0)) 0)
                                   (vec3 0 0 0) 0f0))
              (update-camera camera :orbital))
          (begin-mode-3d (cffi:mem-ref camera '(:struct camera-3d)))
          (unwind-protect
               (progn (draw-grid 10 1f0)
                      (draw-cube (vec3 0 1 0) 2f0 2f0 2f0 (color 0 110 200)))
            (end-mode-3d))
          (draw-text (if manual "Manual: left/right to slide. Space to orbit."
                         "Orbital: Space for manual control.")
                     16 16 20 ink))))))

;; (api-guide :controllers)
