(in-package #:raylisp)

(defun shapes-3d-demo (&optional path)
  "Pick a model with the mouse. Pass an optional model path to use your own."
  (with-window (720 420 "3D shapes: mesh, model and picking")
    (let ((camera (camera-3d :position (vec3 5 4 6) :target (vec3 0 0 0)))
          (model (if path (load-model (namestring (pathname path)))
                     (load-model-from-mesh (gen-mesh-torus 0.5f0 2f0 24 32))))
          (paper (color 245 245 245)) (ink (color 30 35 45))
          (blue (color 0 110 200)) (orange (color 245 135 20)))
      ;; The model now owns the mesh. One UnloadModel releases both.
      (unwind-protect
           (progn
             (unless (is-model-valid model)
               (error "Could not load a drawable model from ~S." path))
             (let ((box (get-model-bounding-box model)))
               (lesson-frames (:shapes-3d paper)
                 (let* ((ray (get-screen-to-world-ray (get-mouse-position) camera))
                        (collision (get-ray-collision-box ray box))
                        (tint (if (struct-field collision :hit) orange blue)))
                   (begin-mode-3d camera)
                   (unwind-protect
                        (progn (draw-grid 10 1f0)
                               (draw-model model (vec3 0 0 0) 1f0 tint)
                               (draw-bounding-box box ink))
                     (end-mode-3d)))
                 (draw-text "Point at the bounding box to highlight the model" 16 16 18 ink))))
        (unload-model model)))))

;; (api-guide :shapes-3d "mesh")
;; (api-guide :shapes-3d "animation")

;; Load an animation file for an existing model. Each array element is a
;; ModelAnimation value. Raylib updates the model's native pose buffers.
(defun apply-first-animation (model path frame)
  (cffi:with-foreign-object (count :int)
    (let ((animations (load-model-animations (namestring (pathname path)) count)))
      (unless (cffi:null-pointer-p animations)
        (unwind-protect
             (when (plusp (cffi:mem-ref count :int))
               (let ((clip (cffi:mem-aref animations '(:struct model-animation) 0)))
                 (when (and (plusp (struct-field clip :keyframe-count))
                            (is-model-animation-valid model clip))
                   (update-model-animation model clip
                                           (float (mod frame (struct-field clip :keyframe-count))
                                                  1f0))
                   t)))
          (unload-model-animations animations (cffi:mem-ref count :int)))))))
